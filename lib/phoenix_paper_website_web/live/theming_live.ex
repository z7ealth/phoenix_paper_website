defmodule PhoenixPaperWebsiteWeb.ThemingLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias Phoenix.LiveView.JS

  # MD3 role groups shown as live swatches (DocsComponents.role_classes/1).
  @role_rows [
    {"Primary", ~w(primary primary-container)},
    {"Secondary", ~w(secondary secondary-container)},
    {"Tertiary", ~w(tertiary tertiary-container)},
    {"Error", ~w(error error-container)}
  ]
  @surface_rows ~w(surface-container-lowest surface-container-low surface-container surface-container-high surface-container-highest inverse-surface)

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Theming")
     |> assign(:role_rows, @role_rows)
     |> assign(:surface_rows, @surface_rows)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:theming}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Guide" title="Theming">
          Every color in PhoenixPaper is one CSS custom property. You set your palette by
          overriding those properties in your own app.css: once for light, once for dark.
          No build step, no JavaScript config, no forking the dependency.
        </.page_header>

        <.section
          title="Setting your colors"
          description="Add your overrides to app.css after the phoenix_paper import. Two blocks: light on :root, dark on the data-theme block the toggle switches. Every token phoenix_paper defines is listed below at its default value, so the whole set is in front of you: edit the hexes you want and delete the lines you don't (a line you drop keeps phoenix_paper's own value)."
          code={override_css()}
          code_language="css"
        >
          <.pp_typography variant="body-medium" color="on-surface-variant">
            That is the entire theming API. There is no config file and no JS: the components
            resolve
            <.pp_typography variant="code">var(--color-pp-primary)</.pp_typography>
            at paint time, so a token change takes effect on the next repaint with no rebuild.
            Do not edit
            <.pp_typography variant="code">
              deps/phoenix_paper/priv/static/phoenix_paper.css
            </.pp_typography>
            directly: your changes belong in your app so an upgrade never clobbers them.
          </.pp_typography>
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-3">
            These two blocks cover an explicit <.pp_typography variant="code">data-theme</.pp_typography>. ThemeToggle's
            default, System, has no
            <.pp_typography variant="code">data-theme</.pp_typography>
            at all (this site starts that way), so to follow the OS also add the
            <.pp_typography variant="code">@media (prefers-color-scheme: dark)</.pp_typography>
            block from Light and dark: how the switch works, below, with the same dark values.
          </.pp_typography>
        </.section>

        <.section
          title="Generate from a seed color"
          description="Rather than picking 46 colors, generate them: mix phoenix_paper.gen.theme takes one seed color and writes every role, light and dark, with phoenix_paper's port of Material's HCT color science, the same way Material Theme Builder does. Every role is a fixed tone of a tonal palette, so contrast holds for any hue. Pick a scheme for the palettes' character, pin core colors if your brand has them, then import the file after phoenix_paper.css."
          code={gen_theme_code()}
          code_language="css"
        >
          <.pp_typography variant="body-medium" color="on-surface-variant">
            Prefer to see it first? The
            <.link navigate={~p"/theme-creator"} class="text-pp-primary hover:underline">
              Theme Creator
            </.link>
            uses the same generator: pick a seed and a scheme, fine-tune any token, and copy the
            CSS.
          </.pp_typography>
        </.section>

        <.section
          title="The token model"
          description="PhoenixPaper uses Material Design 3's color roles: each is a --color-pp-* custom property the components read, and each ships as a background/foreground pair. Override a role and every component that uses it updates. The Theme Creator edits all of them with a live preview."
          props={[
            {"primary / on-primary",
             "high-emphasis actions and active states: filled buttons, selected controls, progress"},
            {"*-container / on-*-container",
             "lower-emphasis fills in that role's hue: tonal buttons, FABs (primary-container), the navigation indicator (secondary-container)"},
            {"secondary, tertiary",
             "secondary is a muted companion of primary for less prominent UI; tertiary adds a contrasting accent"},
            {"error (+ container)", "destructive actions and invalid fields"},
            {"surface, surface-container-lowest … -highest, surface-dim / -bright",
             "backgrounds, layered by color rather than shadow: cards, sheets, menus, dialogs, the app bar when scrolled"},
            {"on-surface / on-surface-variant",
             "text and icons; the variant for secondary text and inactive icons"},
            {"outline / outline-variant", "borders; the variant for dividers and subtle outlines"},
            {"inverse-surface / inverse-on-surface / inverse-primary",
             "elements that contrast with the page: snackbars, plain tooltips"},
            {"primary-fixed … on-tertiary-fixed-variant",
             "the same in light and dark, for brand moments that shouldn't flip"},
            {"shadow, scrim", "elevation shadows and the dim layer behind modals"}
          ]}
        >
          <.demo_group
            label="These read live off the current theme: flip the mode in the next section, or pick hues in the theme picker"
            direction="column"
          >
            <div :for={{label, roles} <- @role_rows} class="flex flex-wrap items-center gap-2">
              <.pp_typography variant="label-medium" class="w-24">{label}</.pp_typography>
              <div
                :for={role <- roles}
                class={["min-w-44 rounded-pp-md px-3 py-2", role_classes(role)]}
              >
                <.pp_typography variant="label-large">{role}</.pp_typography>
                <.pp_typography variant="body-small">on-{role} text</.pp_typography>
              </div>
            </div>
            <div class="flex flex-wrap items-center gap-2">
              <.pp_typography variant="label-medium" class="w-24">Surfaces</.pp_typography>
              <div
                :for={role <- @surface_rows}
                class={[
                  "rounded-pp-md border border-pp-outline-variant px-3 py-2",
                  role_classes(role)
                ]}
              >
                <.pp_typography variant="label-small">{role}</.pp_typography>
              </div>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Light and dark: how the switch works"
          description="Three CSS selectors decide which values are live. Light is the unconditional default. An explicit data-theme on the html element (or any ancestor) always wins. A prefers-color-scheme media query is the fallback used only when no explicit choice has been made."
          code={mechanism_css()}
          code_language="css"
        >
          <.demo_group label="Flip this whole page">
            <.pp_button variant="outlined" phx-click={set_mode("light")}>Light</.pp_button>
            <.pp_button variant="outlined" phx-click={set_mode("dark")}>Dark</.pp_button>
            <.pp_button variant="outlined" phx-click={set_mode("system")}>
              System (follow OS)
            </.pp_button>
          </.demo_group>
          <.pp_list id="theming-mode-rules" class="mt-2">
            <.pp_list_item>
              No attribute
              <:secondary>
                Light, unless the OS prefers dark, in which case the media-query block applies.
              </:secondary>
            </.pp_list_item>
            <.pp_list_item>
              data-theme="dark"
              <:secondary>Dark, always, whatever the OS says.</:secondary>
            </.pp_list_item>
            <.pp_list_item>
              data-theme="light"
              <:secondary>
                Light, always: the :not([data-theme="light"]) guard on the media query is what
                lets an explicit light choice override a dark OS.
              </:secondary>
            </.pp_list_item>
          </.pp_list>
        </.section>

        <.section
          title="Pairing foregrounds"
          description="Every role has an on- counterpart for text and icons drawn on top of it (on-primary on primary, on-primary-container on primary-container). When you change a background role, change its on- role too, and check the contrast: at least 4.5:1 for body text, 3:1 for large text and icons. The Theme Creator shows the ratio for every pair."
        >
          <.demo_group label="Readable pair vs. a mismatch">
            <div class="rounded-pp-sm bg-pp-primary px-4 py-3 text-pp-on-primary">
              <.pp_typography variant="title-small">on-primary on primary: correct</.pp_typography>
            </div>
            <div class="rounded-pp-sm bg-pp-primary px-4 py-3">
              <.pp_typography variant="title-small" color="tertiary">
                tertiary on primary: don't
              </.pp_typography>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Wiring the toggle"
          description="PhoenixPaper.ThemeToggle is a System / Light / Dark control, System by default: it removes data-theme, so the prefers-color-scheme fallback above picks the colors, and it only ever changes data-theme on click. Light and Dark are saved in localStorage under phx:theme; restore it in your root layout's head before first paint (a Phoenix 1.8 layout already does) and there's no flash. Point target at html (the default) for the whole page, or at a scoped selector to theme a preview pane."
          code={toggle_code()}
        >
          <.demo_group label="Try it (it shares data-theme with this site's theme picker)">
            <.pp_theme_toggle id="theming-toggle-segmented" />
          </.demo_group>
        </.section>

        <.section
          title="Checklist"
          description="Before you ship a custom theme:"
        >
          <.pp_list id="theming-checklist">
            <.pp_list_item>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              Overrides live in your app.css, after the phoenix_paper import, never in the dep.
            </.pp_list_item>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              Two blocks:
              <.pp_typography variant="code">:root</.pp_typography>
              (light) and a
              <.pp_typography variant="code">[data-theme="dark"]</.pp_typography>
              block. Add the
              <.pp_typography variant="code">@media (prefers-color-scheme: dark)</.pp_typography>
              fallback (with the
              <.pp_typography variant="code">:not([data-theme="light"])</.pp_typography>
              guard) only if the page can render with no
              <.pp_typography variant="code">data-theme</.pp_typography>
              and should follow the OS.
            </.pp_list_item>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              The page has a
              <.pp_typography variant="code">data-theme</.pp_typography>
              on first paint: hardcode one in root.html.heex, or the two-block setup shows light
              until the toggle is clicked.
            </.pp_list_item>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              Every background token you change gets its on- token changed and contrast-checked.
            </.pp_list_item>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              The toggle target matches where
              <.pp_typography variant="code">data-theme</.pp_typography>
              is read (usually
              <.pp_typography variant="code">html</.pp_typography>
              in root.html.heex).
            </.pp_list_item>
            <.pp_list_item>
              <:leading><.pp_icon name="hero-check-circle" /></:leading>
              Test both explicit choices, plus the no-attribute states on a light and a dark OS if
              you keep the fallback.
            </.pp_list_item>
          </.pp_list>
        </.section>

        <div class="flex justify-end">
          <.pp_button variant="tonal" navigate={~p"/getting-started"}>Back to Getting Started</.pp_button>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp set_mode("system"), do: JS.remove_attribute("data-theme", to: "html")
  defp set_mode(mode), do: JS.set_attribute({"data-theme", mode}, to: "html")

  defp mechanism_css do
    """
    /* phoenix_paper.css, simplified. Your overrides mirror this shape. */

    /* 1. Light: the unconditional default. */
    :root {
      --color-pp-primary: #6750a4;
      /* ... */
    }

    /* 2. Dark: an explicit choice. The toggle sets data-theme="dark". */
    [data-theme="dark"] {
      --color-pp-primary: #d0bcff;
      /* ... */
    }

    /* 3. Dark: the OS preference, used only when nothing is set yet.
          Same values as block 2. */
    @media (prefers-color-scheme: dark) {
      :root:not([data-theme="light"]) {
        --color-pp-primary: #d0bcff;
        /* ... */
      }
    }\
    """
  end

  # Generated from the installed phoenix_paper.css (see ThemeTokens), so it
  # always lists every token at its current default.
  defp override_css do
    """
    @import "tailwindcss";
    @import "../../deps/phoenix_paper/priv/static/phoenix_paper.css";

    """ <> PhoenixPaperWebsiteWeb.ThemeTokens.css(PhoenixPaperWebsiteWeb.ThemeTokens.defaults())
  end

  defp toggle_code do
    """
    <%!-- Anywhere: a top app bar action, a settings panel. Defaults to target="html". --%>
    <.pp_theme_toggle />

    <%!-- root.html.heex <head>: restore a saved Light/Dark before first paint
          (a Phoenix 1.8 root layout already ships this) --%>
    <script>
      (() => {
        const theme = localStorage.getItem("phx:theme");
        if (theme) document.documentElement.setAttribute("data-theme", theme);
      })();
    </script>

    <%!-- Scoped preview, and saving the choice server-side too --%>
    <div id="preview">
      <.pp_theme_toggle target="#preview" on_toggle={JS.push("save_theme")} />
    </div>\
    """
  end

  defp gen_theme_code do
    """
    /* In a terminal: one seed, every role (light and dark).
         mix phoenix_paper.gen.theme --seed "#0b57d0"
       Schemes: tonal_spot (default), neutral, vibrant, expressive, fidelity, monochrome.
       Pin core colors with --secondary / --tertiary / --neutral / --error:
         mix phoenix_paper.gen.theme --seed "#0b57d0" --scheme vibrant --tertiary "#a4407f"
       It writes assets/css/phoenix_paper_theme.css (--output to change it). */

    /* assets/css/app.css */
    @import "tailwindcss";
    @import "../../deps/phoenix_paper/priv/static/phoenix_paper.css";
    @import "./phoenix_paper_theme.css";\
    """
  end
end
