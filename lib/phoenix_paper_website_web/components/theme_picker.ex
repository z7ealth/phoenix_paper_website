defmodule PhoenixPaperWebsiteWeb.ThemePicker do
  @moduledoc """
  This showcase site's own live theme picker (`theme_picker/1`) -- not part
  of PhoenixPaper itself, but built entirely out of its design tokens and
  conventions (see AGENTS.md, "The `paperize` contract" and the plain
  `onclick`-string technique `PhoenixPaper.ThemeToggle`/`Ripple`/`Slider`
  already use for small vanilla interactions).

  Lets a visitor restyle the site live: color mode (light/dark/system), the
  `Primary`/`Secondary`/`Tertiary` brand colors (`--color-pp-primary`,
  `--color-pp-secondary`, `--color-pp-tertiary`, and their `on-*` pairs), the
  `--color-pp-surface`/`--color-pp-on-surface`/`--color-pp-surface-variant`/
  `--color-pp-outline` neutral tones, and the page's font stack -- the same
  idea as Nuxt UI's own theme picker. Every option is a plain `data-pp-*`
  attribute set on `<html>`; the actual color values live in this app's own
  `assets/css/app.css` (see its "Theme picker" section), not in
  `phoenix_paper`'s CSS -- following that file's own documented guidance to
  override `--color-pp-*` tokens from the consuming app instead of forking
  the dependency.

  Primary/Secondary/Tertiary all pick from the same 12-hue swatch table
  (`@hues`) -- one shared list, rendered three times by `@color_roles`
  (each role just pairs it with its own `data-pp-*` attribute and its own
  *current* default hue, so picking that hue is a no-op -- it's already
  what "no attribute" renders as). The site's shipped defaults are Violet
  primary / Indigo secondary / Teal tertiary / Zinc neutral / dark mode --
  each is the base, unconditional value in `app.css`'s "Theme picker"
  section (not gated behind any `data-pp-*` attribute), with the
  previously-shipped alternative (Indigo primary / Pink secondary / plain
  Neutral) demoted to a regular, explicitly-attributed option instead.

  ## Why plain `<html>` attributes, not LiveView assigns

  None of this is server state -- `<html>`/`<head>`/`<body>` live in
  `root.html.heex`, entirely outside any LiveView's own DOM, so a client-only
  attribute flip is both simpler and immune to LiveView's diffing/patching
  (see below). Each swatch's "is this the active one" ring is pure CSS too:
  every swatch carries a stable `data-pp-swatch="group:value"` marker, and
  one attribute-selector block in `app.css` matches whichever swatch
  corresponds to `<html>`'s *current* attribute value and draws the ring --
  nothing to keep in sync from JS.

  A DOM *property* (a checkbox/radio's `checked`, deliberately avoided here)
  would have been simpler to reach for, but `PhoenixPaper.ThemeToggle`'s own
  moduledoc documents exactly why that breaks: LiveView's connected-mount
  (and, for a control rendered inside `Layouts.app`/`Layouts.landing` like
  this one, every subsequent live navigation) re-renders this component from
  the server's own default markup and morphdom-patches the DOM, which can
  silently reset a property a script set earlier back to the server's
  default. Deriving the active swatch from an `<html>` attribute sidesteps
  that entirely -- `<html>` is never part of the diff.

  ## Persistence

  Choices are written to `localStorage` (key `"pp-theme"`) by the same
  `onclick` string that applies the attribute, and re-applied to `<html>` by
  this component's own colocated hook on `mounted()`. Since AGENTS.md
  forbids raw `<script>` tags in templates (colocated hooks are the sanctioned
  alternative), that restore can only happen after LiveView's JS connects --
  not before the very first paint the way a `<head>`-level script could -- so
  a hard reload can show a brief flash of the default theme before a
  previously-chosen one re-applies. Live navigation within the app (the
  common case) never hits this: the attribute already lives on `<html>` and
  is never touched by it.
  """
  use Phoenix.Component

  import PhoenixPaper.Icon, only: [pp_icon: 1]
  import PhoenixPaper.Stack, only: [pp_stack: 1]

  # Shared by all three color-role rows -- values are the swatch dot's
  # (light-mode) hex, kept in sync with each hue's actual override in
  # assets/css/app.css (including whichever hue is currently a given
  # role's *default*, which needs no override there but still needs a
  # swatch here) so every dot renders as the real current color, not a
  # lookalike.
  @hues [
    {"indigo", "Indigo", "#3f51b5"},
    {"red", "Red", "#dc2626"},
    {"orange", "Orange", "#ea580c"},
    {"amber", "Amber", "#d97706"},
    {"green", "Green", "#16a34a"},
    {"teal", "Teal", "#009688"},
    {"cyan", "Cyan", "#0891b2"},
    {"blue", "Blue", "#2563eb"},
    {"violet", "Violet", "#7c3aed"},
    {"pink", "Pink", "#ff4081"},
    {"rose", "Rose", "#e11d48"},
    {"slate", "Slate", "#475569"}
  ]

  # {data-pp-* attribute, data-pp-swatch group prefix, legend label, default hue}
  @color_roles [
    {"data-pp-accent", "accent", "Primary", "violet"},
    {"data-pp-secondary", "secondary", "Secondary", "indigo"},
    {"data-pp-tertiary", "tertiary", "Tertiary", "teal"}
  ]

  # Swatch dot hex is each tone's `outline` value, not its near-white
  # `surface-variant` -- the surface tones themselves are too close to
  # white/black to tell apart as a small dot, but outline carries each
  # tone's actual hue (slate leans blue, zinc neutral, stone warm) at a
  # lightness that reads clearly in both light and dark panels.
  @neutrals [
    {"neutral", "Neutral", "#79747e"},
    {"slate", "Slate", "#64748b"},
    {"zinc", "Zinc", "#71717a"},
    {"stone", "Stone", "#78716c"}
  ]

  @fonts [
    {"sans", "Sans", "ui-sans-serif, system-ui, sans-serif"},
    {"serif", "Serif", ~s(ui-serif, Georgia, Cambria, "Times New Roman", Times, serif)},
    {"mono", "Mono", "ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"},
    {"rounded", "Rounded", ~s(ui-rounded, "SF Pro Rounded", system-ui, sans-serif)}
  ]

  @modes [
    {"light", "Light", "hero-sun-mini"},
    {"dark", "Dark", "hero-moon-mini"},
    {"system", "System", "hero-computer-desktop-mini"}
  ]

  attr(:id, :string, default: "pp-theme-settings")
  attr(:class, :any, default: nil)

  @doc "Renders the theme picker trigger + popover panel. See the module doc."
  def theme_picker(assigns) do
    assigns =
      assigns
      |> assign(:modes, @modes)
      |> assign(:hues, @hues)
      |> assign(:color_roles, @color_roles)
      |> assign(:neutrals, @neutrals)
      |> assign(:fonts, @fonts)

    ~H"""
    <div
      id={@id}
      data-pp-component="theme-picker"
      class={["relative inline-block", @class]}
      phx-hook=".ThemeSettings"
    >
      <input type="checkbox" id={"#{@id}-toggle"} class="peer sr-only" />

      <label
        for={"#{@id}-toggle"}
        aria-label="Theme settings"
        class="relative z-40 inline-flex size-10 cursor-pointer items-center justify-center rounded-full transition-colors hover:bg-pp-on-surface/10"
      >
        <.pp_icon name="hero-swatch" />
      </label>

      <label
        for={"#{@id}-toggle"}
        aria-hidden="true"
        class="fixed inset-0 z-30 hidden peer-checked:block"
      />

      <div class="invisible absolute right-0 top-full z-40 mt-2 w-96 origin-top-right scale-95 rounded-2xl border border-pp-outline/15 bg-pp-surface text-pp-on-surface opacity-0 pp-elevation-6 transition-[opacity,transform] duration-150 peer-checked:visible peer-checked:scale-100 peer-checked:opacity-100">
        <div class="flex items-center justify-between border-b border-pp-outline/10 px-5 py-4">
          <span class="text-sm font-semibold">Theme</span>
          <button
            type="button"
            onclick={reset_js()}
            class="text-xs font-medium text-pp-primary hover:underline"
          >
            Reset
          </button>
        </div>

        <.pp_stack spacing={:lg} class="max-h-[32rem] overflow-y-auto p-5">
          <fieldset class="m-0 border-0 p-0">
            <legend class="mb-2.5 text-xs font-medium text-pp-on-surface/60">Color mode</legend>
            <div class="grid grid-cols-3 gap-2">
              <button
                :for={{value, label, icon} <- @modes}
                type="button"
                data-pp-swatch={"mode:#{value}"}
                onclick={mode_apply_js(value) <> persist_js("mode", value)}
                class="flex items-center justify-center gap-1.5 rounded-lg border border-pp-outline/30 px-2 py-1.5 text-xs font-medium transition-colors hover:bg-pp-on-surface/5"
              >
                <.pp_icon name={icon} class="size-3.5" />{label}
              </button>
            </div>
          </fieldset>

          <fieldset :for={{attr, group, label, default} <- @color_roles} class="m-0 border-0 p-0">
            <legend class="mb-2.5 text-xs font-medium text-pp-on-surface/60">{label}</legend>
            <div class="grid grid-cols-6 gap-2.5">
              <button
                :for={{value, hue_label, hex} <- @hues}
                type="button"
                data-pp-swatch={"#{group}:#{value}"}
                title={hue_label}
                aria-label={"#{hue_label} #{label} color"}
                onclick={role_apply_js(attr, value, default) <> persist_js(group, value)}
                style={"background-color: #{hex}"}
                class="size-6 shrink-0 cursor-pointer rounded-full ring-1 ring-inset ring-black/10 transition-transform hover:scale-110"
              />
            </div>
          </fieldset>

          <fieldset class="m-0 border-0 p-0">
            <legend class="mb-2.5 text-xs font-medium text-pp-on-surface/60">Neutral</legend>
            <div class="flex flex-wrap gap-2.5">
              <button
                :for={{value, label, hex} <- @neutrals}
                type="button"
                data-pp-swatch={"neutral:#{value}"}
                title={label}
                aria-label={"#{label} neutral tone"}
                onclick={neutral_apply_js(value) <> persist_js("neutral", value)}
                style={"background-color: #{hex}"}
                class="size-6 shrink-0 cursor-pointer rounded-full ring-1 ring-inset ring-black/10 transition-transform hover:scale-110"
              />
            </div>
          </fieldset>

          <fieldset class="m-0 border-0 p-0">
            <legend class="mb-2.5 text-xs font-medium text-pp-on-surface/60">Font</legend>
            <div class="flex flex-wrap gap-2">
              <button
                :for={{value, label, stack} <- @fonts}
                type="button"
                data-pp-swatch={"font:#{value}"}
                onclick={font_apply_js(value) <> persist_js("font", value)}
                style={"font-family: #{stack}"}
                class="rounded-lg border border-pp-outline/30 px-2.5 py-1.5 text-xs transition-colors hover:bg-pp-on-surface/5"
              >
                {label}
              </button>
            </div>
          </fieldset>
        </.pp_stack>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".ThemeSettings">
        export default {
          mounted() {
            try {
              const saved = JSON.parse(localStorage.getItem("pp-theme") || "{}")
              const root = document.documentElement
              if (saved.mode === "light" || saved.mode === "dark") root.setAttribute("data-theme", saved.mode)
              else if (saved.mode === "system") root.removeAttribute("data-theme")
              if (saved.accent && saved.accent !== "violet") root.setAttribute("data-pp-accent", saved.accent)
              if (saved.secondary && saved.secondary !== "indigo") root.setAttribute("data-pp-secondary", saved.secondary)
              if (saved.tertiary && saved.tertiary !== "teal") root.setAttribute("data-pp-tertiary", saved.tertiary)
              if (saved.neutral && saved.neutral !== "zinc") root.setAttribute("data-pp-neutral", saved.neutral)
              if (saved.font && saved.font !== "sans") root.setAttribute("data-pp-font", saved.font)
            } catch (e) {}

            this.checkbox = this.el.querySelector('input[type="checkbox"]')
            this.onKeydown = (e) => {
              if (e.key === "Escape" && this.checkbox.checked) this.checkbox.checked = false
            }
            document.addEventListener("keydown", this.onKeydown)
          },
          destroyed() {
            document.removeEventListener("keydown", this.onKeydown)
          }
        }
      </script>
    </div>
    """
  end

  defp mode_apply_js("system"), do: "document.documentElement.removeAttribute('data-theme');"

  defp mode_apply_js(value),
    do: "document.documentElement.setAttribute('data-theme',#{inspect(value)});"

  defp role_apply_js(attr, value, default) when value == default,
    do: "document.documentElement.removeAttribute(#{inspect(attr)});"

  defp role_apply_js(attr, value, _default),
    do: "document.documentElement.setAttribute(#{inspect(attr)},#{inspect(value)});"

  defp neutral_apply_js("zinc"),
    do: "document.documentElement.removeAttribute('data-pp-neutral');"

  defp neutral_apply_js(value),
    do: "document.documentElement.setAttribute('data-pp-neutral',#{inspect(value)});"

  defp font_apply_js("sans"), do: "document.documentElement.removeAttribute('data-pp-font');"

  defp font_apply_js(value),
    do: "document.documentElement.setAttribute('data-pp-font',#{inspect(value)});"

  defp persist_js(key, value) do
    "try{var s=JSON.parse(localStorage.getItem('pp-theme')||'{}');s[#{inspect(key)}]=#{inspect(value)};localStorage.setItem('pp-theme',JSON.stringify(s));}catch(e){}"
  end

  defp reset_js do
    "document.documentElement.setAttribute('data-theme','dark');" <>
      "document.documentElement.removeAttribute('data-pp-accent');" <>
      "document.documentElement.removeAttribute('data-pp-secondary');" <>
      "document.documentElement.removeAttribute('data-pp-tertiary');" <>
      "document.documentElement.removeAttribute('data-pp-neutral');" <>
      "document.documentElement.removeAttribute('data-pp-font');" <>
      "try{localStorage.removeItem('pp-theme');}catch(e){}"
  end
end
