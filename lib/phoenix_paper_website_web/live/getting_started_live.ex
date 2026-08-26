defmodule PhoenixPaperWebsiteWeb.GettingStartedLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Getting Started")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:getting_started}>
      <.pp_container max_width="md">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">
          Getting Started
        </p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Installation</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper ships as a plain hex package — a component library, not a full
          Phoenix app. Three steps, and every component on this site is available in yours.
        </p>

        <.section title="1. Add the dependency" description="In your app's mix.exs:">
          <.code text={deps_snippet()} />
        </.section>

        <.section
          title="2. Import the components"
          description="Next to your app's existing core_components import, in lib/my_app_web.ex:"
        >
          <.code text={html_helpers_snippet()} />
        </.section>

        <.section
          title="3. Wire up the Tailwind theme"
          description="After the tailwindcss import, in assets/css/app.css:"
        >
          <.code text={css_snippet()} />
          <p class="mt-3 text-sm text-pp-on-surface/60">
            The @source line matters — without it Tailwind never scans PhoenixPaper's
            source files, and every class its components emit gets purged from the
            build.
          </p>
        </.section>

        <.section
          title="The paperize contract"
          description="Every PhoenixPaper component takes a boolean paperize attribute, true by default."
        >
          <.pp_grid spacing={:md}>
            <.pp_grid_item span={12} md={6}>
              <.pp_card class="h-full">
                <:title>paperize: true (default)</:title>
                <p class="text-sm text-pp-on-surface/70">
                  Renders with PhoenixPaper's Material Design classes — color, elevation,
                  shape, typography. Your own class attribute still merges on top, last
                  conflicting utility wins.
                </p>
              </.pp_card>
            </.pp_grid_item>
            <.pp_grid_item span={12} md={6}>
              <.pp_card class="h-full">
                <:title>paperize: false</:title>
                <p class="text-sm text-pp-on-surface/70">
                  Drops every built-in class. Only your own class and any DOM structure
                  needed for the component to function (like a checkbox's hidden input)
                  survive — a clean slate to skin yourself.
                </p>
              </.pp_card>
            </.pp_grid_item>
          </.pp_grid>
        </.section>

        <.section
          title="Theming and dark mode"
          description="Every color is a Tailwind v4 theme token, namespaced pp- so it never collides with daisyUI's own primary/secondary/base-100 tokens in the same app."
        >
          <ul class="list-disc space-y-2 pl-5 text-sm text-pp-on-surface/70">
            <li>
              Dark mode keys off the data-theme="dark" attribute — the same one daisyUI
              and Phoenix 1.8's generated app.css already use, so PhoenixPaper flips with
              your app's existing toggle. This site's own light/dark switch, in the top
              right corner, is exactly that toggle.
            </li>
            <li>
              A second bundled palette (teal / amber) is opt-in via
              data-pp-theme="teal" on any ancestor element.
            </li>
            <li>
              For a fully custom palette, don't fork the CSS file — override the
              --color-pp-* variables from your own stylesheet after importing
              phoenix_paper.css.
            </li>
          </ul>
        </.section>

        <.section
          title="What's on the roadmap"
          description="This showcase covers nearly every component PhoenixPaper ships today. One classic Material building block isn't implemented yet:"
        >
          <.pp_stack direction="row" spacing={:sm} wrap>
            <.pp_chip :for={item <- ["Menu"]} variant="outlined">{item}</.pp_chip>
          </.pp_stack>
        </.section>

        <.pp_box class="flex justify-end">
          <.link_button href={~p"/components"}>Browse the components</.link_button>
        </.pp_box>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp deps_snippet do
    """
    defp deps do
      [
        {:phoenix_paper, "~> 0.1.0"}
      ]
    end\
    """
  end

  defp html_helpers_snippet do
    """
    defp html_helpers do
      quote do
        use PhoenixPaper.Components
        # ...
      end
    end\
    """
  end

  defp css_snippet do
    """
    @import "tailwindcss";
    @import "../../deps/phoenix_paper/priv/static/phoenix_paper.css";
    @source "../../deps/phoenix_paper/lib";\
    """
  end
end
