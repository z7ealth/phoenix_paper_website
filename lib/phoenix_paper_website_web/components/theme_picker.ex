defmodule PhoenixPaperWebsiteWeb.ThemePicker do
  @moduledoc """
  This showcase site's own live theme picker (`theme_picker/1`) -- not part
  of PhoenixPaper itself, but built entirely out of its design tokens and
  conventions (see AGENTS.md, "The `paperize` contract" and the plain
  `onclick`-string technique `PhoenixPaper.ThemeToggle`/`Ripple`/`Slider`
  already use for small vanilla interactions).

  Lets a visitor restyle the site live: color mode (light/dark/system), the
  `Primary`/`Secondary`/`Accent` brand colors (`--color-pp-primary`,
  `--color-pp-secondary`, `--color-pp-accent`, and their `on-*` pairs), the
  `--color-pp-surface`/`--color-pp-on-surface`/`--color-pp-surface-variant`/
  `--color-pp-outline` surface tones (shown as "Surface"; the attribute is
  still `data-pp-neutral`) -- the same idea as Nuxt UI's own theme picker.
  Only PhoenixPaper's own tokens: there's no font option, since the library
  has no font token (components inherit the page's font). Every option is a plain `data-pp-*`
  attribute set on `<html>`; the actual color values live in this app's own
  `assets/css/app.css` (see its "Theme picker" section), not in
  `phoenix_paper`'s CSS -- following that file's own documented guidance to
  override `--color-pp-*` tokens from the consuming app instead of forking
  the dependency.

  Primary/Secondary/Accent all pick from the same 12-hue swatch table
  (`@hues`) -- one shared list, rendered three times by `@color_roles`
  (each role just pairs it with its own `data-pp-*` attribute and its own
  *current* default hue, so picking that hue is a no-op -- it's already
  what "no attribute" renders as). The site's shipped defaults are Violet
  primary / Indigo secondary / Teal accent / Zinc neutral / System mode --
  each is the base, unconditional value in `app.css`'s "Theme picker"
  section (not gated behind any `data-pp-*` attribute), with the
  previously-shipped alternative (Indigo primary / Pink secondary / plain
  Neutral) demoted to a regular, explicitly-attributed option instead.

  The third role's own attribute stayed `data-pp-tertiary` (and its swatch
  group `"tertiary"`) even after `phoenix_paper` 0.2.2 renamed its
  `tertiary` color slot to `accent`: `data-pp-accent` was already taken
  here for the *Primary* role (a pre-existing, unrelated naming choice made
  before that library rename), so reusing "accent" for this role's own
  attribute would collide with it. Only the legend label changed, to keep
  what a visitor sees in step with the library's own naming; the CSS this
  attribute sets now writes `--color-pp-accent`/`--color-pp-on-accent`
  (see `app.css`'s "Theme picker" section), matching what the components
  actually read.

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

  Only the color mode is saved: under `localStorage` `"phx:theme"`, the
  same key `PhoenixPaper.ThemeToggle` uses and `root.html.heex` restores
  before first paint, so the picker and every toggle on the site stay in
  agreement across reloads. System (the default) removes the key. The
  colors aren't saved -- a hard reload lands back on the site defaults
  (Violet primary, Indigo secondary, Teal accent, Zinc surface). Within a session, the attributes set on `<html>` survive live
  navigation between pages (it's outside any LiveView's own DOM, see
  above).
  """
  use Phoenix.Component

  import PhoenixPaper.Icon, only: [pp_icon: 1]
  import PhoenixPaper.Stack, only: [pp_stack: 1]
  import PhoenixPaper.Button, only: [pp_button: 1]

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
    {"data-pp-tertiary", "tertiary", "Accent", "teal"}
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

  # Same order and default as PhoenixPaper.ThemeToggle: System first.
  @modes [
    {"system", "System", "hero-computer-desktop-mini"},
    {"light", "Light", "hero-sun-mini"},
    {"dark", "Dark", "hero-moon-mini"}
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
                onclick={mode_apply_js(value)}
                class="flex items-center justify-center gap-1.5 rounded-lg border border-pp-outline/30 px-2 py-1.5 text-xs font-medium transition-colors hover:bg-pp-on-surface/5"
              >
                <.pp_icon name={icon} size="xs" />{label}
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
                onclick={role_apply_js(attr, value, default)}
                style={"background-color: #{hex}"}
                class="size-6 shrink-0 cursor-pointer rounded-full ring-1 ring-inset ring-black/10 transition-transform hover:scale-110"
              />
            </div>
          </fieldset>

          <fieldset class="m-0 border-0 p-0">
            <legend class="mb-2.5 text-xs font-medium text-pp-on-surface/60">Surface</legend>
            <div class="flex flex-wrap gap-2.5">
              <button
                :for={{value, label, hex} <- @neutrals}
                type="button"
                data-pp-swatch={"neutral:#{value}"}
                title={label}
                aria-label={"#{label} surface tone"}
                onclick={neutral_apply_js(value)}
                style={"background-color: #{hex}"}
                class="size-6 shrink-0 cursor-pointer rounded-full ring-1 ring-inset ring-black/10 transition-transform hover:scale-110"
              />
            </div>
          </fieldset>
        </.pp_stack>

        <div class="border-t border-pp-outline/10 p-3">
          <.pp_button id="create-theme-link" variant="text" navigate="/theme-creator" class="w-full">
            <:start_icon><.pp_icon name="hero-sparkles" size="sm" /></:start_icon>
            Create your theme
          </.pp_button>
        </div>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".ThemeSettings">
        export default {
          mounted() {
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

  # Saved under "phx:theme", the same key PhoenixPaper.ThemeToggle uses and
  # root.html.heex restores, so the picker and every toggle agree and the
  # choice survives a reload. System removes it.
  defp mode_apply_js("system"),
    do:
      "document.documentElement.removeAttribute('data-theme');" <>
        "localStorage.removeItem('phx:theme');"

  defp mode_apply_js(value),
    do:
      "document.documentElement.setAttribute('data-theme',#{inspect(value)});" <>
        "localStorage.setItem('phx:theme',#{inspect(value)});"

  defp role_apply_js(attr, value, default) when value == default,
    do: "document.documentElement.removeAttribute(#{inspect(attr)});"

  defp role_apply_js(attr, value, _default),
    do: "document.documentElement.setAttribute(#{inspect(attr)},#{inspect(value)});"

  defp neutral_apply_js("zinc"),
    do: "document.documentElement.removeAttribute('data-pp-neutral');"

  defp neutral_apply_js(value),
    do: "document.documentElement.setAttribute('data-pp-neutral',#{inspect(value)});"

  defp reset_js do
    mode_apply_js("system") <>
      "document.documentElement.removeAttribute('data-pp-accent');" <>
      "document.documentElement.removeAttribute('data-pp-secondary');" <>
      "document.documentElement.removeAttribute('data-pp-tertiary');" <>
      "document.documentElement.removeAttribute('data-pp-neutral');"
  end
end
