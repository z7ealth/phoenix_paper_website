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
          Phoenix app). Three steps, and every component on this site is available in yours;
          two optional ones give you starter app and sign-in layouts and a loading bar in your
          theme's color.
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
          <.code text={css_snippet()} language="css" />
          <p class="mt-3 text-sm text-pp-on-surface/60">
            No separate @source line is needed: since 0.2.3, phoenix_paper.css declares
            its own, so Tailwind scans PhoenixPaper's source files wherever the package
            lives (deps/ or a local path: dependency). Upgrading from an older version?
            Your existing @source line is now redundant but harmless.
          </p>
        </.section>

        <.section
          title="4. Starter app and auth layouts (Optional)"
          description="Replace the generated Layouts.app in lib/my_app_web/components/layouts.ex with a PhoenixPaper shell, the same structure as this site's own. A responsive drawer with a dense list (and a collapsible group): always visible on large screens, a slide-in panel opened by the app bar's menu button on smaller ones, with no JavaScript. Plus a sticky app bar with the drawer toggle, a System/Light/Dark theme toggle and an overflow menu, and pp_flash_group for flash messages. The drawer and app bar only show once a user is signed in (mix phx.gen.auth's @current_scope), so the log in and register pages stay bare."
        >
          <.code text={layout_snippet()} />
          <.pp_typography variant="body2" color="muted" class="mt-3">
            Then pass the current page from each LiveView so its sidebar item is highlighted:
          </.pp_typography>
          <.code text={layout_usage_snippet()} />
          <.pp_typography variant="body2" color="muted" class="mt-3">
            pp_theme_toggle starts on System (it follows the OS) and saves a Light or Dark choice
            in localStorage under phx:theme, which a Phoenix 1.8 root layout already restores
            before first paint. pp_flash_group replaces the generated flash_group, connection
            notices included.
          </.pp_typography>

          <.pp_typography variant="h6" class="mt-8">An auth layout for sign-in pages</.pp_typography>
          <.pp_typography variant="body2" color="muted" class="mt-1">
            If you use mix phx.gen.auth, give its sign-in pages their own layout: no drawer, no
            app bar, just a card centered on the page holding the form. Add it next to app/1 in
            the same Layouts module:
          </.pp_typography>
          <.code text={auth_layout_snippet()} />
          <.pp_typography variant="body2" color="muted" class="mt-3">
            Then switch the signed-out auth LiveViews to it. In each of these, replace
            Layouts.app (opening and closing tag) with Layouts.auth:
          </.pp_typography>
          <.code text={auth_usage_snippet()} />
          <.pp_typography variant="body2" color="muted" class="mt-3">
            Leave user_live/settings.ex on Layouts.app: only signed-in users reach it, so it
            keeps the drawer and app bar. The login page is also where signed-in users land to
            re-authenticate before a sensitive action; with Layouts.auth it stays a bare card
            then too.
          </.pp_typography>
        </.section>

        <.section
          title="5. A loading bar in your primary color (Optional)"
          description="Phoenix shows a thin topbar at the top of the page during LiveView navigation, in a hardcoded blue. Point it at --color-pp-primary instead: read the token at every navigation, so the bar also follows your light/dark palettes and any theme switching, with no rebuild."
        >
          <.code text={topbar_snippet()} language="javascript" />
          <.pp_typography variant="body2" color="muted" class="mt-3">
            This site does exactly this: switch the primary color in the theme picker, then
            navigate to another page to watch the bar change.
          </.pp_typography>
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
    # mix.exs
    defp deps do
      [
        {:phoenix_paper, "~> 0.3.0"}
      ]
    end\
    """
  end

  defp html_helpers_snippet do
    """
    # lib/my_app_web.ex
    defp html_helpers do
      quote do
        use PhoenixPaper.Components
        # ...
      end
    end\
    """
  end

  defp layout_snippet do
    String.trim_trailing(~S'''
    # lib/my_app_web/components/layouts.ex, inside defmodule MyAppWeb.Layouts
    attr :flash, :map, required: true
    attr :current_scope, :map, default: nil, doc: "from mix phx.gen.auth: nil when signed out"
    attr :current_page, :atom, default: nil, doc: "highlights the matching sidebar item"
    slot :inner_block, required: true

    def app(assigns) do
      assigns = assign(assigns, :signed_in?, !!(assigns.current_scope && assigns.current_scope.user))

      ~H"""
      <div class="flex min-h-screen">
        <%!-- Responsive, no JS: a persistent sidebar from lg up, a slide-in
              panel below that, opened by pp_drawer_toggle in the app bar --%>
        <.pp_drawer :if={@signed_in?} id="app-drawer">
          <:header>
            <%!-- The Phoenix logo every generated app ships, with the Phoenix version under it --%>
            <.link navigate={~p"/"} class="flex flex-col items-start gap-1">
              <img src={~p"/images/logo.svg"} width="36" alt="Phoenix" />
              <.pp_typography variant="caption">v{Application.spec(:phoenix, :vsn)}</.pp_typography>
            </.link>
          </:header>
          <.pp_list dense>
            <.pp_list_subheader>Main</.pp_list_subheader>
            <.pp_list_item navigate={~p"/"} active={@current_page == :home}>
              <:leading><.pp_icon name="hero-home" /></:leading>
              Home
            </.pp_list_item>
            <.pp_list_item navigate={~p"/users/settings"} active={@current_page == :user_settings}>
              <:leading><.pp_icon name="hero-cog-6-tooth" /></:leading>
              Settings
            </.pp_list_item>
            <%!-- A collapsible group; placeholder items, add navigate={...} to link them --%>
            <.pp_list_group id="nav-projects">
              <:leading><.pp_icon name="hero-folder" /></:leading>
              <:label>Projects</:label>
              <.pp_list_item>Website</.pp_list_item>
              <.pp_list_item>Mobile app</.pp_list_item>
            </.pp_list_group>
          </.pp_list>
        </.pp_drawer>

        <div class="min-w-0 flex-1">
          <.pp_app_bar :if={@signed_in?} color="surface" position="sticky">
            <%!-- The drawer's menu button: only shows below lg --%>
            <:leading><.pp_drawer_toggle for="app-drawer" /></:leading>
            <:actions>
              <.pp_theme_toggle />
              <%!-- Default trigger_variant="icon": an overflow menu --%>
              <.pp_menu id="profile-menu" anchor="bottom-end">
                <:trigger><.pp_icon name="hero-ellipsis-vertical" /></:trigger>
                <.pp_list>
                  <.pp_list_item navigate={~p"/profile"}>Profile</.pp_list_item>
                  <.pp_list_item navigate={~p"/users/settings"}>Settings</.pp_list_item>
                  <%!-- mix phx.gen.auth's log-out route is a DELETE --%>
                  <.pp_list_item href={~p"/users/log-out"} method="delete">Log out</.pp_list_item>
                </.pp_list>
              </.pp_menu>
            </:actions>
          </.pp_app_bar>

          <main class="py-10">
            <.pp_container max_width="lg">
              {render_slot(@inner_block)}
            </.pp_container>
          </main>
        </div>
      </div>

      <.pp_flash_group flash={@flash} connection_notices />
      """
    end
    ''')
  end

  defp layout_usage_snippet do
    """
    <%!-- lib/my_app_web/live/user_live/settings.ex, in render/1 --%>
    <Layouts.app flash={@flash} current_scope={@current_scope} current_page={:user_settings}>
      <.pp_typography variant="h4">Settings</.pp_typography>
    </Layouts.app>\
    """
  end

  defp auth_layout_snippet do
    String.trim_trailing(~S'''
    # lib/my_app_web/components/layouts.ex, inside defmodule MyAppWeb.Layouts, next to app/1
    attr :flash, :map, required: true
    attr :current_scope, :map, default: nil
    slot :inner_block, required: true

    def auth(assigns) do
      ~H"""
      <main class="flex min-h-screen items-center justify-center p-4">
        <.pp_card padding={:lg} class="w-full max-w-md">
          {render_slot(@inner_block)}
        </.pp_card>
      </main>

      <%!-- Floats over the page; login errors arrive as flash messages --%>
      <.pp_flash_group flash={@flash} connection_notices />
      """
    end
    ''')
  end

  defp auth_usage_snippet do
    """
    <%!-- lib/my_app_web/live/user_live/login.ex
          lib/my_app_web/live/user_live/registration.ex
          lib/my_app_web/live/user_live/confirmation.ex --%>

    <%!-- Before --%>
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      ...
    </Layouts.app>

    <%!-- After --%>
    <Layouts.auth flash={@flash} current_scope={@current_scope}>
      ...
    </Layouts.auth>\
    """
  end

  defp topbar_snippet do
    """
    // assets/js/app.js: replace the generated topbar.config and
    // "phx:page-loading-start" lines with these
    const primaryColor = () =>
      getComputedStyle(document.documentElement).getPropertyValue("--color-pp-primary").trim() || "#29d"

    topbar.config({barColors: {0: primaryColor()}, shadowColor: "rgba(0, 0, 0, .3)"})
    window.addEventListener("phx:page-loading-start", _info => {
      // Re-read on every navigation so the bar follows theme changes
      topbar.config({barColors: {0: primaryColor()}})
      topbar.show(300)
    })
    window.addEventListener("phx:page-loading-stop", _info => topbar.hide())\
    """
  end

  defp css_snippet do
    """
    /* assets/css/app.css */
    @import "tailwindcss";
    @import "../../deps/phoenix_paper/priv/static/phoenix_paper.css";\
    """
  end
end
