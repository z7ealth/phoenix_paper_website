defmodule PhoenixPaperWebsiteWeb.ThemingLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias Phoenix.LiveView.JS

  # Full literal class strings (not interpolated) so Tailwind's source
  # scanner actually generates each utility.
  @brand_swatches [
    {"pp-primary", "bg-pp-primary text-pp-on-primary"},
    {"pp-secondary", "bg-pp-secondary text-pp-on-secondary"},
    {"pp-accent", "bg-pp-accent text-pp-on-accent"},
    {"pp-error", "bg-pp-error text-pp-on-error"}
  ]

  @status_swatches [
    {"pp-success", "bg-pp-success text-pp-on-success"},
    {"pp-warning", "bg-pp-warning text-pp-on-warning"},
    {"pp-info", "bg-pp-info text-pp-on-info"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Theming")
     |> assign(:brand_swatches, @brand_swatches)
     |> assign(:status_swatches, @status_swatches)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:theming}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Guide</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Theming</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          Every color in PhoenixPaper is one CSS custom property. You set your palette by
          overriding those properties in your own app.css: once for light, once for dark.
          No build step, no JavaScript config, no forking the dependency.
        </p>

        <.section
          title="The token model"
          description="A small, fixed set of role-based tokens, not a full color scale. Each is a --color-pp-* custom property that the components read; each ships as a background/foreground pair. Override a token and every component that uses it updates at once."
          props={[
            {"--color-pp-primary",
             "the main brand / action color: raised buttons, links, active states, focus rings"},
            {"--color-pp-secondary", "a second accent for less prominent actions and highlights"},
            {"--color-pp-accent", "a third accent, used sparingly (e.g. the landing hero gradient)"},
            {"--color-pp-error", "destructive actions and invalid form fields"},
            {"--color-pp-surface",
             "the background of the page and of every Paper / Card / Dialog / AppBar"},
            {"--color-pp-surface-variant",
             "a slightly offset fill: filled text fields, table stripes, hover states"},
            {"--color-pp-outline", "borders, dividers, disabled text"},
            {"--color-pp-success / -warning / -info",
             "Alert and Snackbar severities (error above doubles as the error severity)"},
            {"--color-pp-on-*",
             "the readable foreground for each color: text and icons placed on it. Every token ships as an on- pair"}
          ]}
        >
          <.demo_group
            label="These read live off the current theme, flip the mode in the next section to watch them change"
            class="flex-col items-stretch"
          >
            <div class="space-y-4">
              <div>
                <p class="mb-2 text-xs font-medium text-pp-on-surface/60">Brand / action</p>
                <div class="flex flex-wrap gap-2">
                  <div
                    :for={{name, classes} <- @brand_swatches}
                    class={["flex min-w-32 flex-col gap-0.5 rounded-lg px-3 py-2 text-xs", classes]}
                  >
                    <span class="font-semibold">{name}</span>
                    <span class="opacity-80">on-{name} text</span>
                  </div>
                </div>
              </div>

              <div>
                <p class="mb-2 text-xs font-medium text-pp-on-surface/60">Surface / neutral</p>
                <div class="flex flex-wrap gap-2">
                  <div class="flex min-w-32 flex-col gap-0.5 rounded-lg border border-pp-outline/30 bg-pp-surface px-3 py-2 text-xs text-pp-on-surface">
                    <span class="font-semibold">pp-surface</span>
                    <span class="opacity-70">on-pp-surface text</span>
                  </div>
                  <div class="flex min-w-32 flex-col gap-0.5 rounded-lg bg-pp-surface-variant px-3 py-2 text-xs text-pp-on-surface">
                    <span class="font-semibold">pp-surface-variant</span>
                    <span class="opacity-70">on-pp-surface text</span>
                  </div>
                  <div class="flex min-w-32 items-center rounded-lg border-2 border-pp-outline px-3 py-2 text-xs text-pp-on-surface/70">
                    pp-outline border
                  </div>
                </div>
              </div>

              <div>
                <p class="mb-2 text-xs font-medium text-pp-on-surface/60">Status</p>
                <div class="flex flex-wrap gap-2">
                  <div
                    :for={{name, classes} <- @status_swatches}
                    class={["flex min-w-32 flex-col gap-0.5 rounded-lg px-3 py-2 text-xs", classes]}
                  >
                    <span class="font-semibold">{name}</span>
                    <span class="opacity-80">on-{name} text</span>
                  </div>
                </div>
              </div>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Light and dark: how the switch works"
          description="Three CSS selectors decide which values are live. Light is the unconditional default. An explicit data-theme on the html element (or any ancestor) always wins. A prefers-color-scheme media query is the fallback used only when no explicit choice has been made."
          code={mechanism_css()}
        >
          <.demo_group label="Flip this whole page">
            <.pp_button variant="outlined" phx-click={set_mode("light")}>Light</.pp_button>
            <.pp_button variant="outlined" phx-click={set_mode("dark")}>Dark</.pp_button>
            <.pp_button variant="outlined" phx-click={set_mode("system")}>
              System (follow OS)
            </.pp_button>
          </.demo_group>
          <ul class="mt-2 list-disc space-y-1.5 pl-5 text-sm text-pp-on-surface/70">
            <li>
              <span class="font-medium text-pp-on-surface">No attribute</span>
              &rarr; light, unless the OS prefers dark, in which case the media-query block applies.
            </li>
            <li>
              <span class="font-medium text-pp-on-surface">data-theme="dark"</span>
              &rarr; dark, always, whatever the OS says.
            </li>
            <li>
              <span class="font-medium text-pp-on-surface">data-theme="light"</span>
              &rarr; light, always: the :not([data-theme="light"]) guard on the media query is what
              lets an explicit light choice override a dark OS.
            </li>
          </ul>
        </.section>

        <.section
          title="Setting your colors"
          description="Add your overrides to app.css after the phoenix_paper import. Two blocks: light on :root, dark on the data-theme block the toggle switches. Every token phoenix_paper defines is listed below at its default value, so the whole set is in front of you: edit the hexes you want and delete the lines you don't (a line you drop keeps phoenix_paper's own value)."
          code={override_css()}
        >
          <p class="text-sm text-pp-on-surface/70">
            That is the entire theming API. There is no config file and no JS: the components
            resolve <code class="text-xs text-pp-primary">var(--color-pp-primary)</code>
            at paint time, so a token change takes effect on the next repaint with no rebuild.
            Do not edit
            <code class="text-xs text-pp-primary">deps/phoenix_paper/priv/static/phoenix_paper.css</code>
            directly: your changes belong in your app so an upgrade never clobbers them.
          </p>
          <p class="mt-3 text-sm text-pp-on-surface/70">
            These two blocks assume the page always has an explicit <code class="text-xs text-pp-primary">data-theme</code>: hardcode one in
            root.html.heex (this site uses <code class="text-xs text-pp-primary">data-theme="dark"</code>),
            or let the toggle set it. If the page can render with no
            <code class="text-xs text-pp-primary">data-theme</code>
            at all and you want it to follow the OS until the first click, also add the
            <code class="text-xs text-pp-primary">@media (prefers-color-scheme: dark)</code>
            block from the section above, with the same dark values.
          </p>
        </.section>

        <.section
          title="Pairing foregrounds"
          description="Every brand/status token has an on- counterpart for text and icons drawn on top of it. When you change a background token, change its on- token too, and check the contrast: aim for at least 4.5:1 for body text, 3:1 for large text and icons. The components only ever use on-primary on primary, on-surface on surface, and so on, so a bad pair shows up everywhere that color appears."
        >
          <.demo_group label="Readable pair vs. a mismatch">
            <div class="rounded-lg bg-pp-primary px-4 py-3 text-sm font-medium text-pp-on-primary">
              on-primary on primary &mdash; correct
            </div>
            <div class="rounded-lg bg-pp-primary px-4 py-3 text-sm font-medium text-pp-accent">
              accent on primary &mdash; don't
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Wiring the toggle"
          description="PhoenixPaper.ThemeToggle is a light/dark switch that only ever sets data-theme on click, never on mount, so the CSS fallback above owns the first paint and there is no flash. Point target at html (the default) for the whole page, or at a scoped selector to theme a preview pane. It does not persist across a full reload on its own: use on_toggle to push the choice to the server, or add a small hook that writes localStorage."
          code={toggle_code()}
        >
          <.demo_group label="This is the same component as the switch in this page's top-right corner">
            <.pp_theme_toggle />
            <.pp_theme_toggle label={nil} />
          </.demo_group>
        </.section>

        <.section
          title="The alternate bundled palette"
          description="phoenix_paper.css ships one non-default palette, a teal and amber scheme, behind a data-pp-theme attribute set to teal on any ancestor. It is a shortcut for a common look; a real custom theme still means overriding the tokens as above. Your own overrides and this attribute compose: set both and your --color-pp-* rules win by source order."
          code={alt_palette_css()}
        >
          <.demo_group label="Try it (also flips back)">
            <.pp_button
              variant="outlined"
              phx-click={JS.set_attribute({"data-pp-theme", "teal"}, to: "html")}
            >
              Teal palette
            </.pp_button>
            <.pp_button
              variant="outlined"
              phx-click={JS.remove_attribute("data-pp-theme", to: "html")}
            >
              Default
            </.pp_button>
          </.demo_group>
        </.section>

        <.section
          title="Checklist"
          description="Before you ship a custom theme:"
        >
          <ul class="list-disc space-y-2 pl-5 text-sm text-pp-on-surface/70">
            <li>Overrides live in your app.css, after the phoenix_paper import, never in the dep.</li>
            <li>
              Two blocks: <code class="text-xs text-pp-primary">:root</code>
              (light) and a <code class="text-xs text-pp-primary">[data-theme="dark"]</code>
              block. Add the
              <code class="text-xs text-pp-primary">@media (prefers-color-scheme: dark)</code>
              fallback (with the
              <code class="text-xs text-pp-primary">:not([data-theme="light"])</code>
              guard) only if the page can render with no
              <code class="text-xs text-pp-primary">data-theme</code>
              and should follow the OS.
            </li>
            <li>
              The page has a <code class="text-xs text-pp-primary">data-theme</code>
              on first paint: hardcode one in root.html.heex, or the two-block setup shows light
              until the toggle is clicked.
            </li>
            <li>
              Every background token you change gets its on- token changed and contrast-checked.
            </li>
            <li>
              The toggle target matches where <code class="text-xs text-pp-primary">data-theme</code>
              is read (usually <code class="text-xs text-pp-primary">html</code>
              in root.html.heex).
            </li>
            <li>
              Test both explicit choices, plus the no-attribute states on a light and a dark OS if
              you keep the fallback.
            </li>
          </ul>
        </.section>

        <.pp_box class="flex justify-end">
          <.link_button href={~p"/getting-started"}>Back to Getting Started</.link_button>
        </.pp_box>
      </.pp_container>
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
      --color-pp-primary: #3f51b5;
      /* ... */
    }

    /* 2. Dark: an explicit choice. The toggle sets data-theme="dark". */
    [data-theme="dark"] {
      --color-pp-primary: #7986cb;
      /* ... */
    }

    /* 3. Dark: the OS preference, used only when nothing is set yet.
          Same values as block 2. */
    @media (prefers-color-scheme: dark) {
      :root:not([data-theme="light"]) {
        --color-pp-primary: #7986cb;
        /* ... */
      }
    }\
    """
  end

  defp override_css do
    """
    @import "tailwindcss";
    @import "../../deps/phoenix_paper/priv/static/phoenix_paper.css";
    @source "../../deps/phoenix_paper/lib";

    /* Every --color-pp-* token phoenix_paper defines, at its default value.
       Change the hexes you want; delete the lines you don't. */

    /* ---- Light (default) ---- */
    :root {
      --color-pp-primary: #3f51b5;
      --color-pp-on-primary: #ffffff;
      --color-pp-secondary: #ff4081;
      --color-pp-on-secondary: #000000;
      --color-pp-accent: #009688;
      --color-pp-on-accent: #ffffff;
      --color-pp-error: #d32f2f;
      --color-pp-on-error: #ffffff;

      --color-pp-surface: #ffffff;
      --color-pp-on-surface: #1f1f1f;
      --color-pp-surface-variant: #f5f5f5;
      --color-pp-outline: #79747e;

      --color-pp-success: #2e7d32;
      --color-pp-on-success: #ffffff;
      --color-pp-warning: #ed6c02;
      --color-pp-on-warning: #ffffff;
      --color-pp-info: #0288d1;
      --color-pp-on-info: #ffffff;
    }

    /* ---- Dark (the toggle sets data-theme="dark") ---- */
    [data-theme="dark"] {
      --color-pp-primary: #7986cb;
      --color-pp-on-primary: #0a0e1f;
      --color-pp-secondary: #ff80ab;
      --color-pp-on-secondary: #1a0511;
      --color-pp-accent: #4db6ac;
      --color-pp-on-accent: #04211d;
      --color-pp-error: #ef9a9a;
      --color-pp-on-error: #370505;

      --color-pp-surface: #121212;
      --color-pp-on-surface: #e6e6e6;
      --color-pp-surface-variant: #1e1e1e;
      --color-pp-outline: #938f99;

      --color-pp-success: #81c995;
      --color-pp-on-success: #0a2e0f;
      --color-pp-warning: #ffb74d;
      --color-pp-on-warning: #2b1500;
      --color-pp-info: #81d4fa;
      --color-pp-on-info: #01324a;
    }\
    """
  end

  defp toggle_code do
    """
    <%!-- Anywhere: an AppBar action, a settings panel. Defaults to target="html". --%>
    <.pp_theme_toggle />

    <%!-- Scoped preview + persistence --%>
    <.pp_theme_toggle
      label="Dark mode"
      default_checked={@dark_mode?}
      target="#preview"
      on_toggle={JS.push("save_theme_preference")}
    />\
    """
  end

  defp alt_palette_css do
    """
    <%!-- root.html.heex, or any ancestor element --%>
    <html data-pp-theme="teal">

    /* It only redefines the brand tokens; surface/outline stay as-is.
       Composes with your own :root / [data-theme="dark"] overrides. */
    """
  end
end
