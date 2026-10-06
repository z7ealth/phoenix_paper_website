defmodule PhoenixPaperWebsiteWeb.Components.NavigationLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Navigation", page: 5, query: "", hits: [])}
  end

  @destinations ["Inbox", "Outbox", "Favorites", "Trash", "Archive", "Drafts", "Spam"]

  # Pagination demo: on_change sends the page as phx-value-page.
  def handle_event("set_page", %{"page" => page}, socket) do
    {:noreply, assign(socket, :page, String.to_integer(page))}
  end

  # Search bar demo: filter a fixed list as you type.
  def handle_event("search", %{"q" => q}, socket) do
    hits =
      if String.trim(q) == "",
        do: [],
        else:
          Enum.filter(@destinations, &String.contains?(String.downcase(&1), String.downcase(q)))

    {:noreply, assign(socket, query: q, hits: hits)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:navigation}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Navigation">
          PhoenixPaper.TopAppBar, NavigationRail, NavigationBar, Toolbar, Tabs, Breadcrumbs,
          Pagination, Menu, SearchBar and the List family.
        </.page_header>

        <.section
          title="Top App Bar"
          description="MD3 top app bars are surface-colored: the bar sits on surface and turns surface-container once content scrolls under it (a CSS scroll-driven animation; scrolled forces it). small and center_aligned are 64dp; medium and large are the Expressive flexible layouts, with the title below the icons, and subtitle adds a second line. Icon buttons inside need no color."
          api={[{PhoenixPaper.TopAppBar, :pp_top_app_bar}]}
          code={top_app_bar_code()}
        >
          <.demo_group label="variant" direction="column">
            <.pp_top_app_bar
              :for={variant <- ~w(small center_aligned medium large)}
              variant={variant}
              subtitle={if variant in ~w(medium large), do: "With a subtitle"}
              class="rounded-pp-md border border-pp-outline-variant"
            >
              <:leading><.pp_icon_button icon="hero-arrow-left" label="Back" /></:leading>
              {variant}
              <:actions>
                <.pp_icon_button icon="hero-magnifying-glass" label="Search" />
                <.pp_icon_button icon="hero-ellipsis-vertical" label="More" />
              </:actions>
            </.pp_top_app_bar>
          </.demo_group>
        </.section>

        <.section
          title="Navigation Rail"
          description="M3 Expressive's navigation rail, which replaces the navigation drawer: collapsed (96dp, icons over labels) or expanded (280dp, icons beside labels), animating on the Expressive spring. responsive (the default, used by this site's own sidebar) is a modal over a scrim below md and a collapsed rail that its menu button expands from md up. Pure CSS. The :fab slot morphs into an extended FAB when expanded."
          api={[
            {PhoenixPaper.NavigationRail, :pp_navigation_rail},
            {PhoenixPaper.NavigationRail, :pp_navigation_rail_item},
            {PhoenixPaper.NavigationRail, :pp_navigation_rail_toggle}
          ]}
          code={navigation_rail_code()}
        >
          <.demo_group label="collapsed and expanded (sized down for the demo with !static !h-80)">
            <div class="block bg-pp-surface text-pp-on-surface rounded-pp-md border border-pp-outline-variant overflow-hidden">
              <.pp_navigation_rail id="rail-demo-collapsed" variant="collapsed" class="!static !h-80">
                <:fab icon="hero-pencil" label="Compose" />
                <.pp_navigation_rail_item
                  icon="hero-inbox"
                  active_icon="hero-inbox-solid"
                  label="Inbox"
                  href="#navigation-rail"
                  active
                  badge={4}
                />
                <.pp_navigation_rail_item
                  icon="hero-paper-airplane"
                  label="Sent"
                  href="#navigation-rail"
                />
                <.pp_navigation_rail_item icon="hero-trash" label="Trash" href="#navigation-rail" />
              </.pp_navigation_rail>
            </div>
            <div class="block bg-pp-surface text-pp-on-surface rounded-pp-md border border-pp-outline-variant overflow-hidden">
              <.pp_navigation_rail id="rail-demo-expanded" variant="expanded" class="!static !h-80">
                <:fab icon="hero-pencil" label="Compose" />
                <.pp_navigation_rail_item
                  icon="hero-inbox"
                  active_icon="hero-inbox-solid"
                  label="Inbox"
                  href="#navigation-rail"
                  active
                  badge={4}
                />
                <.pp_navigation_rail_item
                  icon="hero-paper-airplane"
                  label="Sent"
                  href="#navigation-rail"
                />
                <.pp_navigation_rail_item icon="hero-trash" label="Trash" href="#navigation-rail" />
              </.pp_navigation_rail>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Navigation Bar"
          description={
            ~S|The Expressive flexible bottom bar for 3–5 top-level destinations on small screens: 64dp on surface-container, each item an icon in a secondary-container indicator with its label under it (vertical) or beside it (horizontal); responsive switches at sm. position="fixed" pins it to the viewport bottom. Pair it with a navigation rail on larger screens.|
          }
          api={[
            {PhoenixPaper.NavigationBar, :pp_navigation_bar},
            {PhoenixPaper.NavigationBar, :pp_navigation_bar_item}
          ]}
          code={navigation_bar_code()}
        >
          <.demo_group label="item_layout" direction="column">
            <.pp_navigation_bar
              :for={layout <- ~w(vertical horizontal)}
              item_layout={layout}
              class="rounded-pp-md"
            >
              <.pp_navigation_bar_item
                icon="hero-home"
                active_icon="hero-home-solid"
                label="Home"
                href="#navigation-bar"
                active
              />
              <.pp_navigation_bar_item
                icon="hero-magnifying-glass"
                label="Search"
                href="#navigation-bar"
              />
              <.pp_navigation_bar_item
                icon="hero-bell"
                label="Alerts"
                href="#navigation-bar"
                badge={3}
              />
            </.pp_navigation_bar>
          </.demo_group>
        </.section>

        <.section
          title="Toolbar"
          description={
            ~S|An M3 Expressive toolbar, MD3's replacement for the bottom app bar: a row (or column) of actions for the current page. docked is a full-width 64dp bar; floating is a rounded pill sized to its items, optionally paired with a FAB. vibrant puts it on primary-container; give icon buttons color="inherit" there.|
          }
          api={[{PhoenixPaper.Toolbar, :pp_toolbar}]}
          code={toolbar_code()}
        >
          <.demo_group label="docked, and floating vibrant with a FAB" direction="column">
            <.pp_toolbar class="rounded-pp-md">
              <.pp_icon_button icon="hero-archive-box" label="Archive" />
              <.pp_icon_button icon="hero-trash" label="Delete" />
              <.pp_icon_button icon="hero-envelope" label="Mark unread" />
              <.pp_icon_button icon="hero-tag" label="Label" />
            </.pp_toolbar>
            <div class="flex justify-center">
              <.pp_toolbar variant="floating" color="vibrant">
                <.pp_icon_button icon="hero-bold" label="Bold" color="inherit" />
                <.pp_icon_button icon="hero-italic" label="Italic" color="inherit" />
                <.pp_icon_button icon="hero-underline" label="Underline" color="inherit" />
                <:fab><.pp_fab icon="hero-check" label="Done" color="secondary-container" /></:fab>
              </.pp_toolbar>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Tabs"
          description={
            ~S|Tabs, Tab and TabPanel switch client-side via Phoenix.LiveView.JS commands, no round trip. primary tabs have an indicator under the label and content; secondary tabs a thinner full-width one. layout="scrollable" scrolls a long row. They follow the ARIA keyboard model: only the selected tab is a Tab stop, and Left/Right (mirrored in RTL), Home and End move between tabs, skipping disabled ones. With the JS hook (Getting Started, step 4) the indicator slides between tabs.|
          }
          api={[
            {PhoenixPaper.Tabs, :pp_tabs},
            {PhoenixPaper.Tab, :pp_tab},
            {PhoenixPaper.TabPanel, :pp_tab_panel}
          ]}
          code={tabs_code()}
        >
          <.demo_group label="primary, with icons and a badge" direction="column">
            <.pp_tabs id="demo-tabs">
              <.pp_tab id="demo-tabs" value="flights" default_selected>
                <:icon><.pp_icon name="hero-paper-airplane" /></:icon>
                Flights
              </.pp_tab>
              <.pp_tab id="demo-tabs" value="trips" badge={2}>
                <:icon><.pp_icon name="hero-map" /></:icon>
                Trips
              </.pp_tab>
              <.pp_tab id="demo-tabs" value="explore">
                <:icon><.pp_icon name="hero-globe-americas" /></:icon>
                Explore
              </.pp_tab>
            </.pp_tabs>
            <.pp_tab_panel id="demo-tabs" value="flights" default_selected class="p-4">
              Upcoming flights.
            </.pp_tab_panel>
            <.pp_tab_panel id="demo-tabs" value="trips" class="p-4">Your trips.</.pp_tab_panel>
            <.pp_tab_panel id="demo-tabs" value="explore" class="p-4">Somewhere new.</.pp_tab_panel>
          </.demo_group>

          <.demo_group label="secondary" direction="column">
            <.pp_tabs id="secondary-tabs" variant="secondary">
              <.pp_tab id="secondary-tabs" value="overview" default_selected>Overview</.pp_tab>
              <.pp_tab id="secondary-tabs" value="specs">Specifications</.pp_tab>
            </.pp_tabs>
            <.pp_tab_panel id="secondary-tabs" value="overview" default_selected class="p-4">
              Overview content.
            </.pp_tab_panel>
            <.pp_tab_panel id="secondary-tabs" value="specs" class="p-4">Spec sheet.</.pp_tab_panel>
          </.demo_group>
        </.section>

        <.section
          title="Breadcrumbs"
          api={[{PhoenixPaper.Breadcrumbs, :pp_breadcrumbs}]}
          description="A trail of :items built from MD3 parts: each linked item is a compact text button in primary, the current page (the item left without a link) is plain on-surface text with aria-current, and chevrons separate them. Long trails wrap instead of collapsing."
          code={breadcrumbs_code()}
        >
          <.demo_group label="Links and the current page">
            <.pp_breadcrumbs id="breadcrumbs-demo">
              <:item navigate={~p"/"}>Home</:item>
              <:item navigate={~p"/components"}>Components</:item>
              <:item>Navigation</:item>
            </.pp_breadcrumbs>
          </.demo_group>
        </.section>

        <.section
          title="Pagination"
          api={[{PhoenixPaper.Pagination, :pp_pagination}]}
          description="Page navigation from MD3 standard icon buttons: previous and next around the first and last page, the current page and one on each side, the rest collapsed into an ellipsis (so the control keeps its width as you page). The current page takes secondary-container and aria-current. Pages are 1-based; give path a function for links (patch by default), or on_change an event name."
          code={pagination_code()}
        >
          <.demo_group label={"Events (on_change): page #{@page} of 12"}>
            <.pp_pagination id="pagination-demo" page={@page} count={12} on_change="set_page" />
          </.demo_group>
          <.demo_group label="disabled">
            <.pp_pagination page={1} count={3} on_change="set_page" disabled />
          </.demo_group>
        </.section>

        <.section
          title="Menu"
          description={
            ~S|A trigger that opens an anchored list of actions; closes on selecting an item, clicking outside, or Escape (JS commands and phx-click-away, no hook). The trigger is an icon button (trigger_icon + trigger_label) or your own :trigger content with trigger_variant. Items are pp_menu_item/1: a leading icon, supporting and trailing text, selected. color="vibrant" is the tertiary-container Expressive menu. pp_submenu/1 cascades a submenu beside an item (hover, focus or tap). With the JS hook and an id, menus and submenus flip to the other side when they'd overflow the viewport.|
          }
          api={[
            {PhoenixPaper.Menu, :pp_menu},
            {PhoenixPaper.Menu, :pp_menu_item},
            {PhoenixPaper.Menu, :pp_submenu}
          ]}
          code={menu_code()}
        >
          <.demo_group label="Try it">
            <.pp_menu id="demo-menu" trigger_variant="outlined">
              <:trigger>Actions <.pp_icon name="hero-chevron-down" size="sm" /></:trigger>
              <.pp_menu_item icon="hero-pencil-square" trailing_text="⌘E">Edit</.pp_menu_item>
              <.pp_menu_item icon="hero-document-duplicate" trailing_text="⌘D">
                Duplicate
              </.pp_menu_item>
              <.pp_divider />
              <.pp_menu_item icon="hero-trash">Delete</.pp_menu_item>
            </.pp_menu>

            <.pp_menu
              id="demo-menu-icon"
              anchor="bottom-end"
              trigger_icon="hero-ellipsis-vertical"
              trigger_label="More"
            >
              <.pp_menu_item href="#menu" supporting_text="Your public profile">
                Profile
              </.pp_menu_item>
              <.pp_menu_item href="#menu" selected>Settings</.pp_menu_item>
              <.pp_submenu id="demo-menu-share" label="Share" icon="hero-share" side="start">
                <.pp_menu_item icon="hero-envelope">Email</.pp_menu_item>
                <.pp_menu_item icon="hero-link">Copy link</.pp_menu_item>
              </.pp_submenu>
              <.pp_menu_item>Log out</.pp_menu_item>
            </.pp_menu>

            <.pp_menu
              id="demo-menu-vibrant"
              color="vibrant"
              trigger_icon="hero-sparkles"
              trigger_label="Vibrant menu"
            >
              <.pp_menu_item icon="hero-sun">Light</.pp_menu_item>
              <.pp_menu_item icon="hero-moon">Dark</.pp_menu_item>
            </.pp_menu>
          </.demo_group>
        </.section>

        <.section
          title="Search Bar"
          description="A 56dp rounded surface-container-high bar with a leading search icon (or your :leading), the input and a :trailing slot. Given :results, it opens into MD3's search view while it has focus: docked under the bar (view=&quot;docked&quot;, default), full screen (&quot;fullscreen&quot;, with a back button), or full screen only below sm (&quot;responsive&quot;). Pure CSS (:focus-within), so render the results from your LiveView as the query changes. Type below."
          api={[{PhoenixPaper.SearchBar, :pp_search_bar}]}
          code={search_bar_code()}
        >
          <.demo_group label="Try it (docked search view)">
            <form id="search-demo" phx-change="search" phx-submit="search" class="w-full max-w-md">
              <.pp_search_bar name="q" value={@query} placeholder="Search folders" phx-debounce="150">
                <:trailing>
                  <.pp_avatar>AL</.pp_avatar>
                </:trailing>
                <:results>
                  <.pp_list>
                    <.pp_list_item :for={hit <- @hits} href="#search-bar">
                      <:leading><.pp_icon name="hero-folder" /></:leading>
                      {hit}
                    </.pp_list_item>
                    <.pp_list_item :if={@hits == []} disabled>
                      {if @query == "", do: "Type to search", else: "No folders match"}
                    </.pp_list_item>
                  </.pp_list>
                </:results>
              </.pp_search_bar>
            </form>
          </.demo_group>

          <.demo_group label={
            ~S|view="responsive": full screen below sm (narrow the window and focus it)|
          }>
            <div class="w-full max-w-md">
              <.pp_search_bar id="search-responsive" name="q2" placeholder="Search" view="responsive">
                <:results>
                  <.pp_list>
                    <.pp_list_item :for={d <- ~w(Inbox Drafts Archive)} href="#search-bar">
                      {d}
                    </.pp_list_item>
                  </.pp_list>
                </:results>
              </.pp_search_bar>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="List"
          description="MD3 list rows: one line (56dp), or two with :secondary (72dp), in body-large. Items render as links, buttons or plain rows depending on their attrs; the active item is secondary-container. :leading holds an icon or a pp_avatar, :trailing a count, icon or action. For a heading over a group, use a title-small pp_typography; to show and hide a group, render its items conditionally."
          api={[
            {PhoenixPaper.List, :pp_list},
            {PhoenixPaper.ListItem, :pp_list_item}
          ]}
          code={list_code()}
        >
          <.demo_group label="Icons with a heading, and avatars with two lines" class="items-start">
            <div class="block bg-pp-surface text-pp-on-surface rounded-pp-md border border-pp-outline-variant w-full max-w-xs overflow-hidden">
              <.pp_list>
                <.pp_typography
                  variant="title-small"
                  color="on-surface-variant"
                  class="px-4 pt-2 pb-1"
                >
                  Main
                </.pp_typography>
                <.pp_list_item href="#list" active>
                  <:leading><.pp_icon name="hero-home" /></:leading>
                  Home
                  <:secondary>Overview</:secondary>
                </.pp_list_item>
                <.pp_list_item href="#list">
                  <:leading><.pp_icon name="hero-inbox" /></:leading>
                  Inbox
                  <:trailing>
                    <.pp_typography variant="label-medium">3</.pp_typography>
                  </:trailing>
                </.pp_list_item>
                <.pp_divider />
                <.pp_list_item disabled>
                  <:leading><.pp_icon name="hero-credit-card" /></:leading>
                  Billing
                  <:secondary>Coming soon</:secondary>
                </.pp_list_item>
              </.pp_list>
            </div>
            <div class="block bg-pp-surface text-pp-on-surface rounded-pp-md border border-pp-outline-variant w-full max-w-xs overflow-hidden">
              <.pp_list id="list-avatars-demo">
                <.pp_list_item
                  :for={{initials, name, line} <- list_people()}
                  href="#list"
                >
                  <:leading>
                    <.pp_avatar>
                      {initials}
                    </.pp_avatar>
                  </:leading>
                  {name}
                  <:secondary>{line}</:secondary>
                </.pp_list_item>
              </.pp_list>
            </div>
          </.demo_group>
        </.section>
      </div>
    </Layouts.app>
    """
  end

  defp top_app_bar_code do
    """
    <.pp_top_app_bar position="sticky">
      <:leading><.pp_navigation_rail_toggle for="app-rail" modal_only /></:leading>
      Inbox
      <:actions>
        <.pp_icon_button icon="hero-magnifying-glass" label="Search" />
        <.pp_icon_button icon="hero-ellipsis-vertical" label="More" />
      </:actions>
    </.pp_top_app_bar>

    <.pp_top_app_bar variant="large" subtitle="12 unread">
      <:leading><.pp_icon_button icon="hero-arrow-left" label="Back" /></:leading>
      Inbox
    </.pp_top_app_bar>\
    """
  end

  defp navigation_rail_code do
    """
    <%!-- responsive (default): modal below md, collapsible rail from md --%>
    <.pp_navigation_rail id="app-rail">
      <:fab icon="hero-pencil" label="Compose" navigate={~p"/compose"} />
      <.pp_navigation_rail_item
        icon="hero-inbox"
        active_icon="hero-inbox-solid"
        label="Inbox"
        navigate={~p"/"}
        active
        badge={4}
      />
      <.pp_navigation_rail_item icon="hero-paper-airplane" label="Sent" navigate={~p"/sent"} />
    </.pp_navigation_rail>

    <%!-- In the top app bar, so small screens can open the modal rail --%>
    <.pp_navigation_rail_toggle for="app-rail" modal_only />\
    """
  end

  defp navigation_bar_code do
    """
    <.pp_navigation_bar position="fixed" class="md:hidden">
      <.pp_navigation_bar_item icon="hero-home" active_icon="hero-home-solid" label="Home" navigate={~p"/"} active />
      <.pp_navigation_bar_item icon="hero-magnifying-glass" label="Search" navigate={~p"/search"} />
      <.pp_navigation_bar_item icon="hero-bell" label="Alerts" navigate={~p"/alerts"} badge={3} />
    </.pp_navigation_bar>\
    """
  end

  defp toolbar_code do
    """
    <.pp_toolbar position="fixed">
      <.pp_icon_button icon="hero-archive-box" label="Archive" />
      <.pp_icon_button icon="hero-trash" label="Delete" />
    </.pp_toolbar>

    <.pp_toolbar variant="floating" color="vibrant" position="fixed" class="bottom-4 inset-x-0 mx-auto">
      <.pp_icon_button icon="hero-bold" label="Bold" color="inherit" />
      <.pp_icon_button icon="hero-italic" label="Italic" color="inherit" />
      <:fab><.pp_fab icon="hero-check" label="Done" color="secondary-container" /></:fab>
    </.pp_toolbar>\
    """
  end

  defp tabs_code do
    """
    <.pp_tabs id="trip-tabs">
      <.pp_tab id="trip-tabs" value="flights" default_selected>
        <:icon><.pp_icon name="hero-paper-airplane" /></:icon>
        Flights
      </.pp_tab>
      <.pp_tab id="trip-tabs" value="trips" badge={2}>Trips</.pp_tab>
    </.pp_tabs>
    <.pp_tab_panel id="trip-tabs" value="flights" default_selected>Upcoming flights.</.pp_tab_panel>
    <.pp_tab_panel id="trip-tabs" value="trips">Your trips.</.pp_tab_panel>

    <.pp_tabs id="spec-tabs" variant="secondary" layout="scrollable">...</.pp_tabs>\
    """
  end

  defp menu_code do
    """
    <%!-- Your own trigger content, styled with trigger_variant --%>
    <.pp_menu id="actions-menu" trigger_variant="outlined">
      <:trigger>Actions <.pp_icon name="hero-chevron-down" size="sm" /></:trigger>
      <.pp_menu_item icon="hero-pencil-square" trailing_text="⌘E" phx-click="edit">Edit</.pp_menu_item>
      <.pp_divider />
      <.pp_menu_item icon="hero-trash" phx-click="delete">Delete</.pp_menu_item>
    </.pp_menu>

    <%!-- An icon-button trigger: trigger_icon + trigger_label --%>
    <.pp_menu id="profile-menu" anchor="bottom-end" trigger_icon="hero-ellipsis-vertical" trigger_label="More">
      <.pp_menu_item navigate={~p"/users/settings"}>Settings</.pp_menu_item>
      <%!-- A cascading submenu --%>
      <.pp_submenu id="profile-menu-share" label="Share" icon="hero-share">
        <.pp_menu_item phx-click="share_email">Email</.pp_menu_item>
        <.pp_menu_item phx-click="share_link">Copy link</.pp_menu_item>
      </.pp_submenu>
      <.pp_menu_item href={~p"/users/log-out"} method="delete">Log out</.pp_menu_item>
    </.pp_menu>\
    """
  end

  defp search_bar_code do
    """
    <form phx-change="search" phx-submit="search">
      <.pp_search_bar name="q" value={@query} placeholder="Search folders" phx-debounce="150">
        <:trailing><.pp_avatar>AL</.pp_avatar></:trailing>
        <:results>
          <.pp_list>
            <.pp_list_item :for={hit <- @hits} navigate={hit.path}>{hit.title}</.pp_list_item>
          </.pp_list>
        </:results>
      </.pp_search_bar>
    </form>

    # In the LiveView:
    def handle_event("search", %{"q" => q}, socket),
      do: {:noreply, assign(socket, query: q, hits: MyApp.Search.run(q))}\
    """
  end

  defp breadcrumbs_code do
    """
    <.pp_breadcrumbs>
      <:item navigate={~p"/"}>Home</:item>
      <:item navigate={~p"/catalog"}>Catalog</:item>
      <:item>Current product</:item>
    </.pp_breadcrumbs>\
    """
  end

  defp pagination_code do
    String.trim_trailing(~S'''
    <%!-- Links: the page lives in the URL and handle_params/3 loads it --%>
    <.pp_pagination page={@page} count={@total_pages} path={&~p"/users?page=#{&1}"} />

    <%!-- Events: each button sends phx-value-page --%>
    <.pp_pagination page={@page} count={@total_pages} on_change="paginate" />

    # In the LiveView
    def handle_event("paginate", %{"page" => page}, socket),
      do: {:noreply, assign(socket, :page, String.to_integer(page))}
    ''')
  end

  defp list_code do
    """
    <.pp_list>
      <.pp_typography variant="title-small" color="on-surface-variant" class="px-4 pt-2 pb-1">
        Main
      </.pp_typography>
      <.pp_list_item navigate={~p"/"} active>
        <:leading><.pp_icon name="hero-home" /></:leading>
        Home
        <:secondary>Overview</:secondary>
      </.pp_list_item>
      <.pp_list_item navigate={~p"/inbox"}>
        <:leading><.pp_icon name="hero-inbox" /></:leading>
        Inbox
        <:trailing><.pp_typography variant="label-medium">3</.pp_typography></:trailing>
      </.pp_list_item>
    </.pp_list>

    <%!-- pp_avatar in :leading: an image, falling back to initials --%>
    <.pp_list>
      <.pp_list_item :for={user <- @users} navigate={~p"/users/\#{user.id}"}>
        <:leading><.pp_avatar src={user.avatar_url}>{user.initials}</.pp_avatar></:leading>
        {user.name}
        <:secondary>{user.email}</:secondary>
      </.pp_list_item>
    </.pp_list>\
    """
  end

  defp list_people do
    [
      {"AL", "Ada Lovelace", "ada@example.com"},
      {"GH", "Grace Hopper", "grace@example.com"},
      {"AT", "Alan Turing", "alan@example.com"}
    ]
  end
end
