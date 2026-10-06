defmodule PhoenixPaperWebsiteWeb.ThemeTokens do
  @moduledoc """
  The data behind the theme creator (`PhoenixPaperWebsiteWeb.ThemeCreatorLive`):
  phoenix_paper's own `--color-pp-*` tokens and their defaults, a WCAG
  contrast check, a random brand palette, and the `app.css` export.

  Generated palettes come from the library's own HCT color science
  (`generate/2`). The defaults are parsed from the installed `phoenix_paper.css` at compile
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
  light = parse_block.(css, "@theme static")
  dark = parse_block.(css, ~s([data-theme="dark"]))

  @order Enum.map(light, &elem(&1, 0))
  # MD3's fixed roles, shadow and scrim are the same in both modes, so the
  # library's dark block omits them: fall back to the light values.
  @defaults %{light: Map.new(light), dark: Map.merge(Map.new(light), Map.new(dark))}

  @groups [
    {"Primary", ~w(primary on-primary primary-container on-primary-container)},
    {"Secondary", ~w(secondary on-secondary secondary-container on-secondary-container)},
    {"Tertiary", ~w(tertiary on-tertiary tertiary-container on-tertiary-container)},
    {"Error", ~w(error on-error error-container on-error-container)},
    {"Surface",
     ~w(surface surface-dim surface-bright surface-container-lowest surface-container-low surface-container surface-container-high surface-container-highest surface-variant on-surface on-surface-variant)},
    {"Outline", ~w(outline outline-variant)},
    {"Inverse", ~w(inverse-surface inverse-on-surface inverse-primary)},
    {"Fixed",
     ~w(primary-fixed primary-fixed-dim on-primary-fixed on-primary-fixed-variant secondary-fixed secondary-fixed-dim on-secondary-fixed on-secondary-fixed-variant tertiary-fixed tertiary-fixed-dim on-tertiary-fixed on-tertiary-fixed-variant)},
    {"Other", ~w(shadow scrim)}
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
  def pair_of("inverse-on-surface"), do: "inverse-surface"

  def pair_of("on-" <> base) do
    base = String.replace_suffix(base, "-fixed-variant", "-fixed")
    if base in @order, do: base
  end

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
  Both palettes for a seed color, generated by phoenix_paper's own MD3 color
  science (`PhoenixPaper.Theme.scheme/3`, a port of Material's HCT): every
  role is one tone of one tonal palette, like Material Theme Builder. The
  same output as `mix phoenix_paper.gen.theme --seed <seed> --scheme <variant>`.
  """
  def generate(seed, variant \\ :tonal_spot) do
    %{
      light: Map.take(PhoenixPaper.Theme.scheme(seed, :light, variant: variant), @order),
      dark: Map.take(PhoenixPaper.Theme.scheme(seed, :dark, variant: variant), @order)
    }
  end

  @doc "Scheme variants `generate/2` accepts (`PhoenixPaper.Theme.variants/0`)."
  def variants, do: PhoenixPaper.Theme.variants()

  @doc "A random seed color, as `#rrggbb`."
  def random_seed do
    ("#" <>
       for(
         _ <- 1..3,
         into: "",
         do: (:rand.uniform(256) - 1) |> Integer.to_string(16) |> String.pad_leading(2, "0")
       ))
    |> String.downcase()
  end

  @doc "Is `value` a `#rrggbb` color?"
  def hex?(value), do: is_binary(value) and Regex.match?(~r/\A#[0-9a-fA-F]{6}\z/, value)
end
