defmodule PhoenixPaperWebsiteWeb.ThemeTokens do
  @moduledoc """
  The data behind the theme creator (`PhoenixPaperWebsiteWeb.ThemeCreatorLive`):
  phoenix_paper's own `--color-pp-*` tokens and their defaults, a WCAG
  contrast check, a random brand palette, and the `app.css` export.

  The defaults are parsed from the installed `phoenix_paper.css` at compile
  time (the `@theme` block for light, `[data-theme="dark"]` for dark), so the
  creator always starts from exactly what the library ships -- and recompiles
  when that file changes.
  """

  @css_path Application.app_dir(:phoenix_paper, "priv/static/phoenix_paper.css")
  @external_resource @css_path

  parse_block = fn css, opener ->
    [_, block] = Regex.run(~r/#{Regex.escape(opener)}\s*\{(.*?)\n\}/s, css)

    ~r/--color-pp-([a-z-]+):\s*(#[0-9a-fA-F]{6})/
    |> Regex.scan(block)
    |> Enum.map(fn [_, name, hex] -> {name, String.downcase(hex)} end)
  end

  css = File.read!(@css_path)
  light = parse_block.(css, "@theme")
  dark = parse_block.(css, ~s([data-theme="dark"]))

  @order Enum.map(light, &elem(&1, 0))
  @defaults %{light: Map.new(light), dark: Map.new(dark)}

  @groups [
    {"Brand", ~w(primary on-primary secondary on-secondary accent on-accent error on-error)},
    {"Surface", ~w(surface on-surface surface-variant outline)},
    {"Status", ~w(success on-success warning on-warning info on-info)}
  ]

  @doc "Token names (without the `--color-pp-` prefix), in the library's order."
  def names, do: @order

  @doc "The library's default palettes: `%{light: %{name => hex}, dark: ...}`."
  def defaults, do: @defaults

  @doc "Tokens grouped for the editor (only names the library actually defines)."
  def groups do
    for {label, names} <- @groups do
      {label, Enum.filter(names, &(&1 in @order))}
    end
  end

  @doc "The background token an `on-*` token is drawn on, or nil."
  def pair_of("on-" <> base), do: if(base in @order, do: base)
  def pair_of(_), do: nil

  @doc "An inline `style` value setting every token, for a preview container."
  def style(palette) do
    Enum.map_join(@order, " ", fn name -> "--color-pp-#{name}: #{palette[name]};" end)
  end

  @doc """
  The `app.css` block for a light and a dark palette: light on `:root`,
  dark on `[data-theme="dark"]`.
  """
  def css(%{light: light, dark: dark}) do
    """
    /* assets/css/app.css, after the phoenix_paper import */

    /* Light (default) */
    :root {
    #{declarations(light, "  ")}
    }

    /* Dark */
    [data-theme="dark"] {
    #{declarations(dark, "  ")}
    }\
    """
  end

  # Grouped like the editor (Brand / Surface / Status), a blank line and a
  # comment between groups; any token outside the groups goes last.
  defp declarations(palette, indent) do
    grouped = groups()
    rest = @order -- Enum.flat_map(grouped, &elem(&1, 1))
    sections = if rest == [], do: grouped, else: grouped ++ [{"Other", rest}]

    Enum.map_join(sections, "\n\n", fn {label, names} ->
      lines = Enum.map(names, &"#{indent}--color-pp-#{&1}: #{palette[&1]};")
      Enum.join(["#{indent}/* #{label} */" | lines], "\n")
    end)
  end

  @doc "WCAG contrast ratio between two `#rrggbb` colors (1.0 to 21.0)."
  def contrast(a, b) do
    {hi, lo} =
      Enum.min_max_by([luminance(a), luminance(b)], & &1) |> then(fn {l, h} -> {h, l} end)

    Float.round((hi + 0.05) / (lo + 0.05), 2)
  end

  @doc "`:aaa` (>= 7), `:aa` (>= 4.5), `:large` (>= 3, large text and icons only) or `:fail`."
  def rating(ratio) when ratio >= 7, do: :aaa
  def rating(ratio) when ratio >= 4.5, do: :aa
  def rating(ratio) when ratio >= 3, do: :large
  def rating(_), do: :fail

  defp luminance(hex) do
    {r, g, b} = rgb(hex)

    [r, g, b]
    |> Enum.map(fn c ->
      c = c / 255
      if c <= 0.03928, do: c / 12.92, else: :math.pow((c + 0.055) / 1.055, 2.4)
    end)
    |> then(fn [r, g, b] -> 0.2126 * r + 0.7152 * g + 0.0722 * b end)
  end

  defp rgb("#" <> hex) do
    <<r::binary-2, g::binary-2, b::binary-2>> = hex
    {String.to_integer(r, 16), String.to_integer(g, 16), String.to_integer(b, 16)}
  end

  @doc """
  A random brand palette on top of `palettes`: primary, secondary and
  accent get related hues (a random base, its complement-ish and a
  neighbor), mid-tone in light mode and lighter in dark mode, each with
  whichever of white/near-black reads best as its `on-*` color. Surfaces,
  error and status tokens are left as they are.
  """
  def random(%{light: light, dark: dark}) do
    base = :rand.uniform(360) - 1
    hues = %{"primary" => base, "secondary" => base + 150, "accent" => base + 60}

    {light, dark} =
      Enum.reduce(hues, {light, dark}, fn {name, hue}, {l, d} ->
        hue = rem(hue, 360)
        l_bg = hsl_to_hex(hue, 0.65, 0.45)
        d_bg = hsl_to_hex(hue, 0.70, 0.72)

        {Map.merge(l, %{name => l_bg, "on-#{name}" => best_on(l_bg, "#ffffff", "#111111")}),
         Map.merge(d, %{name => d_bg, "on-#{name}" => best_on(d_bg, "#ffffff", "#111111")})}
      end)

    %{light: light, dark: dark}
  end

  defp best_on(bg, a, b), do: if(contrast(bg, a) >= contrast(bg, b), do: a, else: b)

  defp hsl_to_hex(h, s, l) do
    c = (1 - abs(2 * l - 1)) * s
    x = c * (1 - abs(:math.fmod(h / 60, 2) - 1))
    m = l - c / 2

    {r, g, b} =
      cond do
        h < 60 -> {c, x, 0}
        h < 120 -> {x, c, 0}
        h < 180 -> {0, c, x}
        h < 240 -> {0, x, c}
        h < 300 -> {x, 0, c}
        true -> {c, 0, x}
      end

    "#" <>
      Enum.map_join([r, g, b], fn v ->
        round((v + m) * 255)
        |> Integer.to_string(16)
        |> String.pad_leading(2, "0")
        |> String.downcase()
      end)
  end

  @doc "Is `value` a `#rrggbb` color?"
  def hex?(value), do: is_binary(value) and Regex.match?(~r/\A#[0-9a-fA-F]{6}\z/, value)
end
