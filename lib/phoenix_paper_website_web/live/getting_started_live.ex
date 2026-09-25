defmodule PhoenixPaperWebsiteWeb.GettingStartedLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Getting Started")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:getting_started}>
      <.pp_container max_width="md">
        <.page_header eyebrow="Getting Started" title="Installation">
          PhoenixPaper ships as a plain hex package (a component library, not a full
          Phoenix app). Three steps, and every component on this site is available in yours.
        </.page_header>

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
            No separate @source line is needed: since 0.2.3, phoenix_paper.css declares
            its own, so Tailwind scans PhoenixPaper's source files wherever the package
            lives (deps/ or a local path: dependency). Upgrading from an older version?
            Your existing @source line is now redundant but harmless.
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
                  Renders with PhoenixPaper's Material Design classes: color, elevation,
                  shape, typography. Your own class attribute is appended on top: it
                  reliably adds utilities, but to replace a built-in one for the same
                  property, prefix yours with Tailwind's ! modifier (!bg-red-500).
                </p>
              </.pp_card>
            </.pp_grid_item>
            <.pp_grid_item span={12} md={6}>
              <.pp_card class="h-full">
                <:title>paperize: false</:title>
                <p class="text-sm text-pp-on-surface/70">
                  Drops every built-in class. Only your own class and any DOM structure
                  needed for the component to function (like a checkbox's hidden input)
                  survive: a clean slate to skin yourself.
                </p>
              </.pp_card>
            </.pp_grid_item>
          </.pp_grid>
        </.section>

        <.section
          title="Theming and dark mode"
          description="Every color is a Tailwind v4 theme token, namespaced pp- so it never collides with daisyUI's own primary/secondary/base-100 tokens in the same app. Dark mode keys off a data-theme attribute, the same one daisyUI and Phoenix 1.8's generated app.css already use, so PhoenixPaper flips with your app's existing toggle."
        >
          <p class="text-sm text-pp-on-surface/70">
            To set your own light and dark palettes, override the --color-pp-* variables in
            your app.css after the import above. The full walkthrough, with the
            system-preference fallback and the toggle, is on the
            <.link navigate={~p"/theming"} class="text-pp-primary hover:underline">Theming</.link>
            page.
          </p>
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
        {:phoenix_paper, "~> 0.2.5"}
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
    @import "../../deps/phoenix_paper/priv/static/phoenix_paper.css";\
    """
  end
end
