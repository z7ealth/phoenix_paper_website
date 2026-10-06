defmodule PhoenixPaperWebsiteWeb.GettingStartedLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Getting Started")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:getting_started}>
      <div class="mx-auto w-full px-4 max-w-screen-md">
        <.page_header eyebrow="Getting Started" title="Installation">
          PhoenixPaper ships as a plain hex package (a component library, not a full
          Phoenix app). Four steps, and every component on this site is available in yours;
          two optional ones add starter layouts and a loading bar in your theme's color.
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
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-3">
            No separate @source line is needed: since 0.2.3, phoenix_paper.css declares
            its own, so Tailwind scans PhoenixPaper's source files wherever the package
            lives (deps/ or a local path: dependency). Upgrading from an older version?
            Your existing @source line is now redundant but harmless.
          </.pp_typography>
        </.section>

        <.section
          title="4. Add the JS hook"
          description={
            ~S|Register phoenix_paper's LiveView hook in your LiveSocket. Hooked components (tabs, top app bars, menus, tooltips, bottom sheets, carousels, loading indicators, the time picker) render phx-hook="PhoenixPaper" whenever they have an id, so without it LiveView logs an unknown-hook error. It adds what CSS can't do everywhere: the sliding tab indicator, edge flipping for menus and tooltips, drag-to-dismiss bottom sheets, dragging the time picker's hand, the scrolled top app bar and carousel masking in Firefox, and the loading indicator's morph in Safari. Without LiveView connected (a controller-rendered page, the first paint) they keep their CSS behavior.|
          }
        >
          <.code text={hook_js_snippet()} language="javascript" />
        </.section>

        <.section
          title="5. Starter app and auth layouts (Optional)"
          description="Replace the generated Layouts.app in lib/my_app_web/components/layouts.ex with a PhoenixPaper shell, the same structure as this site's own. An MD3 navigation rail (responsive, with no JavaScript: a rail you can expand or collapse on larger screens, a modal over a scrim on phones), a sticky top app bar with the rail's menu button, a System/Light/Dark theme toggle and an overflow menu, and pp_flash_group for flash messages. The rail and app bar only show once a user is signed in (mix phx.gen.auth's @current_scope), so the log in and register pages stay bare."
        >
          <.code text={layout_snippet()} />
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-3">
            Then pass the current page from each LiveView so its sidebar item is highlighted:
          </.pp_typography>
          <.code text={layout_usage_snippet()} />
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-3">
            pp_theme_toggle starts on System (it follows the OS) and saves a Light or Dark choice
            in localStorage under phx:theme, which a Phoenix 1.8 root layout already restores
            before first paint. pp_flash_group replaces the generated flash_group, connection
            notices included.
          </.pp_typography>

          <.pp_typography variant="title-large" class="mt-8">
            An auth layout for sign-in pages
          </.pp_typography>
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-1">
            If you use mix phx.gen.auth, give its sign-in pages their own layout: no rail, no
            app bar, just a card centered on the page holding the form. Add it next to app/1 in
            the same Layouts module:
          </.pp_typography>
          <.code text={auth_layout_snippet()} />
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-3">
            Then switch the signed-out auth LiveViews to it. In each of these, replace
            Layouts.app (opening and closing tag) with Layouts.auth:
          </.pp_typography>
          <.code text={auth_usage_snippet()} />
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-3">
            Leave user_live/settings.ex on Layouts.app: only signed-in users reach it, so it
            keeps the rail and app bar. The login page is also where signed-in users land to
            re-authenticate before a sensitive action; with Layouts.auth it stays a bare card
            then too.
          </.pp_typography>
        </.section>

        <.section
          title="6. A loading bar in your primary color (Optional)"
          description="Phoenix shows a thin topbar at the top of the page during LiveView navigation, in a hardcoded blue. Point it at --color-pp-primary instead: read the token at every navigation, so the bar also follows your light/dark palettes and any theme switching, with no rebuild."
        >
          <.code text={topbar_snippet()} language="javascript" />
          <.pp_typography variant="body-medium" color="on-surface-variant" class="mt-3">
            This site does exactly this: switch the primary color in the theme picker, then
            navigate to another page to watch the bar change.
          </.pp_typography>
        </.section>

        <.section
          title="The paperize contract"
          description="Every PhoenixPaper component takes a boolean paperize attribute, true by default."
        >
          <div class="grid grid-cols-12 gap-4">
            <div class="col-span-12 md:col-span-6">
              <.pp_card class="h-full">
                <:title>paperize: true (default)</:title>
                <.pp_typography variant="body-medium" color="on-surface-variant">
                  Renders with PhoenixPaper's Material Design classes: color, elevation,
                  shape, typography. Your own class attribute is appended on top: it
                  reliably adds utilities, but to replace a built-in one for the same
                  property, prefix yours with Tailwind's ! modifier (!bg-red-500).
                </.pp_typography>
              </.pp_card>
            </div>
            <div class="col-span-12 md:col-span-6">
              <.pp_card class="h-full">
                <:title>paperize: false</:title>
                <.pp_typography variant="body-medium" color="on-surface-variant">
                  Drops every built-in class. Only your own class and any DOM structure
                  needed for the component to function (like a checkbox's hidden input)
                  survive: a clean slate to skin yourself.
                </.pp_typography>
              </.pp_card>
            </div>
          </div>
        </.section>

        <.section
          title="Theming and dark mode"
          description="Every color is a Tailwind v4 theme token, namespaced pp- so it never collides with daisyUI's own primary/secondary/base-100 tokens in the same app. Dark mode keys off a data-theme attribute, the same one daisyUI and Phoenix 1.8's generated app.css already use, so PhoenixPaper flips with your app's existing toggle."
        >
          <.pp_typography variant="body-medium" color="on-surface-variant">
            To set your own light and dark palettes, override the --color-pp-* variables in
            your app.css after the import above. The full walkthrough, with the
            system-preference fallback and the toggle, is on the
            <.link navigate={~p"/theming"} class="text-pp-primary hover:underline">Theming</.link>
            page.
          </.pp_typography>
        </.section>

        <div class="flex justify-end">
          <.pp_button navigate={~p"/components"}>Browse the components</.pp_button>
        </div>
      </div>
    </Layouts.app>
    """
  end

  defp deps_snippet do
    """
    # mix.exs
    defp deps do
      [
        {:phoenix_paper, "~> 0.5.1"}
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
    attr :current_page, :atom, default: nil, doc: "highlights the matching rail item"
    slot :inner_block, required: true

    def app(assigns) do
      assigns = assign(assigns, :signed_in?, !!(assigns.current_scope && assigns.current_scope.user))

      ~H"""
      <div class="flex min-h-screen">
        <%!-- Responsive, no JS: a rail you can expand/collapse from md up, a modal
              over a scrim below md, opened by the toggle in the top app bar --%>
        <.pp_navigation_rail :if={@signed_in?} id="app-rail" default_expanded>
          <:header>
            <%!-- The Phoenix logo every generated app ships, with the version under it --%>
            <.link navigate={~p"/"} class="flex flex-col items-start gap-1">
              <img src={~p"/images/logo.svg"} width="36" alt="Phoenix" />
              <.pp_typography variant="body-small" class="pp-rail-collapsed:hidden">
                v{Application.spec(:phoenix, :vsn)}
              </.pp_typography>
            </.link>
          </:header>
          <.pp_navigation_rail_item
            icon="hero-home"
            active_icon="hero-home-solid"
            label="Home"
            navigate={~p"/"}
            active={@current_page == :home}
          />
          <.pp_navigation_rail_item
            icon="hero-cog-6-tooth"
            active_icon="hero-cog-6-tooth-solid"
            label="Settings"
            navigate={~p"/users/settings"}
            active={@current_page == :user_settings}
          />
          <%!-- A labeled group, the heading only while expanded; placeholder
                items, add navigate={...} to link them --%>
          <.pp_typography
            variant="title-small"
            color="on-surface-variant"
            class="px-4 pt-4 pb-2 pp-rail-collapsed:hidden"
          >
            Projects
          </.pp_typography>
          <.pp_navigation_rail_item icon="hero-globe-alt" label="Website" />
          <.pp_navigation_rail_item icon="hero-device-phone-mobile" label="Mobile app" />
        </.pp_navigation_rail>

        <div class="min-w-0 flex-1">
          <.pp_top_app_bar :if={@signed_in?} position="sticky">
            <%!-- Opens the modal rail on small screens --%>
            <:leading><.pp_navigation_rail_toggle for="app-rail" modal_only /></:leading>
            <:actions>
              <.pp_theme_toggle />
              <%!-- An overflow menu: an icon-button trigger and menu items --%>
              <.pp_menu
                id="profile-menu"
                anchor="bottom-end"
                trigger_icon="hero-ellipsis-vertical"
                trigger_label="Account"
              >
                <.pp_menu_item icon="hero-user" navigate={~p"/profile"}>Profile</.pp_menu_item>
                <.pp_menu_item icon="hero-cog-6-tooth" navigate={~p"/users/settings"}>
                  Settings
                </.pp_menu_item>
                <%!-- mix phx.gen.auth's log-out route is a DELETE --%>
                <.pp_menu_item icon="hero-arrow-right-on-rectangle" href={~p"/users/log-out"} method="delete">
                  Log out
                </.pp_menu_item>
              </.pp_menu>
            </:actions>
          </.pp_top_app_bar>

          <main class="py-10">
            <div class="mx-auto w-full px-4 max-w-screen-lg">
              {render_slot(@inner_block)}
            </div>
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
      <.pp_typography variant="headline-medium">Settings</.pp_typography>
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
        <.pp_card class="w-full max-w-md">
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

  defp hook_js_snippet do
    """
    // assets/js/app.js: register phoenix_paper's hooks next to your own
    import PhoenixPaperHooks from "phoenix_paper"

    const liveSocket = new LiveSocket("/live", Socket, {
      hooks: {...PhoenixPaperHooks, ...colocatedHooks},
      // ...
    })\
    """
  end
end
