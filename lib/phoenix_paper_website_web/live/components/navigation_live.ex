defmodule PhoenixPaperWebsiteWeb.Components.NavigationLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Navigation")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:navigation}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Navigation</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.AppBar, Drawer, Tabs, Breadcrumbs, and the List family.
        </p>

        <.section
          title="App Bar"
          description="A horizontal app bar with a leading slot, a title, and trailing actions (renamed from Navbar to match MUI's own naming). This site's own chrome doesn't use one anymore (just a floating theme toggle instead), so here it is on its own. Default toolbar gutters are responsive (px-4 rising to px-6 at the sm breakpoint), matching MUI's Toolbar."
          props={[
            {"color", "primary | secondary | tertiary | surface | transparent (default: primary)"},
            {"elevation", "resting elevation, 0-24 (default: 4), ignored for color=\"transparent\""},
            {"position", "static | relative | sticky | fixed | absolute (default: static)"},
            {"variant", "regular | dense (default: regular), dense shrinks the toolbar row"},
            {"max_width",
             "sm | md | lg | xl | 2xl | full (default: full): caps and centres the toolbar content, like wrapping MUI's Toolbar in a Container. Line it up with a pp_container of the same max_width below"},
            {"disable_gutters", "boolean (default: false): drops the toolbar's horizontal padding"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={app_bar_code()}
        >
          <.demo_group label="Colors" class="flex-col items-stretch">
            <.pp_app_bar
              :for={color <- ~w(primary secondary tertiary surface transparent)}
              color={color}
            >
              {color}
            </.pp_app_bar>
          </.demo_group>

          <.demo_group label="Dense variant" class="flex-col items-stretch">
            <.pp_app_bar variant="dense">Dense toolbar row</.pp_app_bar>
          </.demo_group>

          <.demo_group label="max_width (content capped + centred)" class="flex-col items-stretch">
            <.pp_app_bar max_width="sm" color="surface" class="border border-pp-outline/30">
              max_width="sm"
              <:actions>
                <.pp_button variant="icon"><.pp_icon name="hero-bell" /></.pp_button>
              </:actions>
            </.pp_app_bar>
          </.demo_group>

          <.demo_group label="With leading/actions (correct contrast)" class="flex-col items-stretch">
            <.pp_app_bar>
              <:leading>
                <.pp_drawer_toggle
                  for="site-drawer"
                  class="text-pp-on-primary hover:bg-pp-on-primary/10"
                />
                <span>My App</span>
              </:leading>
              <:actions>
                <.pp_button
                  variant="icon"
                  class="text-pp-on-primary hover:bg-pp-on-primary/10 focus-visible:outline-pp-on-primary"
                >
                  <.pp_icon name="hero-bell" />
                </.pp_button>
              </:actions>
            </.pp_app_bar>
          </.demo_group>
          <p class="text-sm text-pp-on-surface/60">
            Pitfall: a Button's text/icon color is always the brand color (text-pp-primary by
            default) regardless of what it's sitting on: drop one onto a same-colored app bar
            with no override and it's not just low contrast, it's the exact same color as the
            background. The demo above overrides with text-pp-on-primary explicitly.
          </p>
        </.section>

        <.section
          title="Drawer"
          description="A vertical navigation panel, persistent on large screens and toggled by a mobile drawer below that breakpoint: pure CSS via a hidden checkbox, no JS."
          props={[
            {"id", "required: builds the mobile toggle checkbox's id as \"\#{id}-toggle\""},
            {"color",
             "primary | secondary | tertiary | surface (default: surface), also restyles nested List/ListItem for contrast"},
            {"paperize", "boolean (default: true)"},
            {"pp_drawer_toggle for=",
             "a hamburger label pointing at the given drawer's id; works from anywhere on the page"}
          ]}
          code={drawer_code()}
        >
          <.pp_paper
            elevation={0}
            class="border border-pp-outline/15 p-6 text-sm text-pp-on-surface/70"
          >
            The sidebar on the left of this very page is pp_drawer: every link in it is a
            pp_list_item using navigate, highlighted active on whichever page you're on (real
            LiveView navigation, no full page reload). Its mobile toggle is pure CSS: pp_drawer
            renders a visually hidden checkbox, and pp_drawer_toggle is just a label wired to
            that checkbox's id, so it can live anywhere on the page, no JavaScript required.
            color also reaches into nested List/ListItem/ListSubheader/Divider so a colored
            drawer stays readable, not just a style mismatch (see the App Bar pitfall above;
            the same "same color on same color" trap applies to an active item's highlight).
          </.pp_paper>
        </.section>

        <.section
          title="Tabs"
          description="Tabs/Tab/TabPanel switch entirely client-side via Phoenix.LiveView.JS commands fired on click: no server round-trip, no sliding indicator animation (that needs a real layout measurement JS commands can't do)."
          props={[
            {"pp_tabs id", "required: shared with every Tab/TabPanel in the group"},
            {"pp_tabs orientation", "horizontal | vertical (default: horizontal)"},
            {"pp_tabs variant",
             "standard | scrollable | full_width (default: standard), horizontal only"},
            {"pp_tab id / value",
             "id matches the parent Tabs; value must be unique within the group"},
            {"pp_tab default_selected", "boolean, initial selection, uncontrolled (default: false)"},
            {"pp_tab color",
             "primary | secondary | tertiary | error (default: primary), set per Tab, doesn't cascade"},
            {"pp_tab :icon", "optional leading icon slot"},
            {"pp_tab disabled / ripple / paperize", "same as Button"},
            {"pp_tab_panel id / value", "must match the corresponding Tab exactly"}
          ]}
          code={tabs_code()}
        >
          <.demo_group label="Basic" class="flex-col items-stretch">
            <.pp_tabs id="demo-tabs">
              <.pp_tab id="demo-tabs" value="one" default_selected>One</.pp_tab>
              <.pp_tab id="demo-tabs" value="two">Two</.pp_tab>
              <.pp_tab id="demo-tabs" value="three" disabled>Three (disabled)</.pp_tab>
            </.pp_tabs>
            <.pp_tab_panel id="demo-tabs" value="one" default_selected class="p-4 text-sm">
              Content one.
            </.pp_tab_panel>
            <.pp_tab_panel id="demo-tabs" value="two" class="p-4 text-sm">Content two.</.pp_tab_panel>
            <.pp_tab_panel id="demo-tabs" value="three" class="p-4 text-sm">
              Content three.
            </.pp_tab_panel>
          </.demo_group>

          <.demo_group label="Colors" class="flex-col items-stretch">
            <.pp_tabs id="color-tabs">
              <.pp_tab id="color-tabs" value="primary" default_selected color="primary">
                Primary
              </.pp_tab>
              <.pp_tab id="color-tabs" value="secondary" color="secondary">Secondary</.pp_tab>
              <.pp_tab id="color-tabs" value="tertiary" color="tertiary">Tertiary</.pp_tab>
              <.pp_tab id="color-tabs" value="error" color="error">Error</.pp_tab>
            </.pp_tabs>
          </.demo_group>

          <.demo_group label="variant=&quot;full_width&quot;" class="flex-col items-stretch">
            <.pp_tabs id="full-width-tabs" variant="full_width">
              <.pp_tab id="full-width-tabs" value="one" default_selected>One</.pp_tab>
              <.pp_tab id="full-width-tabs" value="two">Two</.pp_tab>
              <.pp_tab id="full-width-tabs" value="three">Three</.pp_tab>
            </.pp_tabs>
          </.demo_group>

          <.demo_group label="Vertical, with icons" class="flex-col items-stretch">
            <.pp_tabs id="vertical-tabs" orientation="vertical" class="max-w-xs">
              <.pp_tab
                id="vertical-tabs"
                value="a"
                orientation="vertical"
                color="secondary"
                default_selected
              >
                <:icon><.pp_icon name="hero-home" /></:icon>
                Home
              </.pp_tab>
              <.pp_tab id="vertical-tabs" value="b" orientation="vertical" color="secondary">
                <:icon><.pp_icon name="hero-user" /></:icon>
                Profile
              </.pp_tab>
            </.pp_tabs>
          </.demo_group>
        </.section>

        <.section
          title="Breadcrumbs"
          description="A breadcrumb trail with a separator auto-inserted between :item slots. An item renders as a link when it has href/navigate/patch, or plain current-page text otherwise: whichever item you leave without a link is the current page, same convention as ListItem."
          props={[
            {"pp_breadcrumbs :item href/navigate/patch",
             "makes that item a link; omit all three for the current page"},
            {"pp_breadcrumbs :separator",
             "a slot, not a string: can hold an icon; defaults to \"/\""},
            {"max_items", "collapse into an expandable ellipsis beyond this many items (default: 8)"},
            {"items_before_collapse / items_after_collapse",
             "collapsed slice sizes (default: 1 / 1)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={breadcrumbs_code()}
        >
          <.demo_group label="Basic" class="flex-col items-start">
            <.pp_breadcrumbs>
              <:item href="#">Home</:item>
              <:item href="#">Catalog</:item>
              <:item>Current product</:item>
            </.pp_breadcrumbs>
          </.demo_group>

          <.demo_group label="Custom separator" class="flex-col items-start">
            <.pp_breadcrumbs>
              <:separator><.pp_icon name="hero-chevron-right" class="size-4" /></:separator>
              <:item href="#">Home</:item>
              <:item href="#">Settings</:item>
              <:item>Profile</:item>
            </.pp_breadcrumbs>
          </.demo_group>

          <.demo_group
            label="max_items={3}: click the ellipsis to expand"
            class="flex-col items-start"
          >
            <.pp_breadcrumbs max_items={3}>
              <:item href="#">One</:item>
              <:item href="#">Two</:item>
              <:item href="#">Three</:item>
              <:item href="#">Four</:item>
              <:item>Five</:item>
            </.pp_breadcrumbs>
          </.demo_group>
        </.section>

        <.section
          title="List"
          description="A vertical stack of list items, with optional sub-headers to group them. Renders items as links, buttons, or plain rows depending on their own attrs: a linked item ripples on click by default, just like Button. Click Home or Inbox below to see it."
          props={[
            {"pp_list", "the container, role=\"list\""},
            {"pp_list_item href/navigate/patch", "makes it a link; active/disabled/ripple as usual"},
            {"pp_list_item :leading / :secondary / :trailing",
             "optional slots for an icon, a subtitle line, a badge"},
            {"pp_list_subheader", "a small uppercase section label"}
          ]}
          code={list_code()}
        >
          <.demo_group label="Preview">
            <.pp_box class="w-full max-w-xs overflow-hidden rounded-xl border border-pp-outline/15 pp-elevation-1">
              <.pp_list class="bg-pp-surface py-2">
                <.pp_list_subheader>Main</.pp_list_subheader>
                <.pp_list_item href="#" active>
                  <:leading><.pp_icon name="hero-home" /></:leading>
                  Home
                  <:secondary>Overview</:secondary>
                </.pp_list_item>
                <.pp_list_item href="#">
                  <:leading><.pp_icon name="hero-inbox" /></:leading>
                  Inbox
                  <:secondary>3 unread</:secondary>
                  <:trailing>
                    <span class="rounded-full bg-pp-primary/10 px-2 py-0.5 text-xs font-medium text-pp-primary">
                      3
                    </span>
                  </:trailing>
                </.pp_list_item>

                <.pp_divider />

                <.pp_list_subheader>Account</.pp_list_subheader>
                <.pp_list_item href="#">
                  <:leading><.pp_icon name="hero-adjustments-horizontal" /></:leading>
                  Settings
                </.pp_list_item>
                <.pp_list_item disabled>
                  <:leading><.pp_icon name="hero-shield-check" /></:leading>
                  Billing
                  <:secondary>Coming soon</:secondary>
                </.pp_list_item>
              </.pp_list>
            </.pp_box>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp app_bar_code do
    """
    <.pp_app_bar position="sticky">
      <:leading><.pp_drawer_toggle for="app-drawer" /></:leading>
      My App
      <:actions>
        <.pp_button variant="icon"><.pp_icon name="hero-bell" /></.pp_button>
      </:actions>
    </.pp_app_bar>

    <.pp_app_bar :for={color <- ~w(primary secondary tertiary surface transparent)} color={color} class="!static">
      {color}
      <:actions>
        <.pp_button variant="icon"><.pp_icon name="hero-bell" /></.pp_button>
      </:actions>
    </.pp_app_bar>

    <.pp_app_bar variant="dense" class="!static">
      Dense variant
    </.pp_app_bar>

    <%!-- max_width caps + centres the toolbar row the way wrapping MUI's
          Toolbar in a <Container> would. Line it up with a pp_container of
          the same max_width in the page body. disable_gutters drops the
          toolbar's own horizontal padding. --%>
    <.pp_app_bar position="sticky" max_width="xl">
      My App
      <:actions><.pp_theme_toggle label={nil} /></:actions>
    </.pp_app_bar>\
    """
  end

  defp drawer_code do
    """
    <.pp_app_bar>
      <:leading><.pp_drawer_toggle for="app-drawer" /></:leading>
      My App
    </.pp_app_bar>

    <.pp_drawer id="app-drawer" color="primary">
      <:header>My App</:header>
      <.pp_list>
        <.pp_list_item href="/" active={@current_path == "/"}>Home</.pp_list_item>
      </.pp_list>
    </.pp_drawer>\
    """
  end

  defp tabs_code do
    """
    <.pp_tabs id="demo-tabs">
      <.pp_tab id="demo-tabs" value="one" default_selected>One</.pp_tab>
      <.pp_tab id="demo-tabs" value="two">Two</.pp_tab>
      <.pp_tab id="demo-tabs" value="three" disabled>Three (disabled)</.pp_tab>
    </.pp_tabs>

    <.pp_tab_panel id="demo-tabs" value="one" default_selected>Content one.</.pp_tab_panel>
    <.pp_tab_panel id="demo-tabs" value="two">Content two.</.pp_tab_panel>
    <.pp_tab_panel id="demo-tabs" value="three">Content three.</.pp_tab_panel>

    <%!-- with icons, secondary color, vertical orientation --%>
    <.pp_tabs id="vertical-tabs" orientation="vertical">
      <.pp_tab id="vertical-tabs" value="a" orientation="vertical" color="secondary" default_selected>
        <:icon><.pp_icon name="hero-home" /></:icon>
        Home
      </.pp_tab>
      <.pp_tab id="vertical-tabs" value="b" orientation="vertical" color="secondary">
        <:icon><.pp_icon name="hero-user" /></:icon>
        Profile
      </.pp_tab>
    </.pp_tabs>\
    """
  end

  defp breadcrumbs_code do
    """
    <.pp_breadcrumbs>
      <:item navigate="/">Home</:item>
      <:item navigate="/catalog">Catalog</:item>
      <:item>Current product</:item>
    </.pp_breadcrumbs>

    <%!-- custom separator slot, e.g. an icon --%>
    <.pp_breadcrumbs>
      <:separator><.pp_icon name="hero-chevron-right" class="size-4" /></:separator>
      <:item navigate="/">Home</:item>
      <:item navigate="/settings">Settings</:item>
      <:item>Profile</:item>
    </.pp_breadcrumbs>

    <%!-- beyond max_items, collapses with a clickable ellipsis (pure CSS) --%>
    <.pp_breadcrumbs max_items={3}>
      <:item navigate="/one">One</:item>
      <:item navigate="/two">Two</:item>
      <:item navigate="/three">Three</:item>
      <:item navigate="/four">Four</:item>
      <:item>Five</:item>
    </.pp_breadcrumbs>\
    """
  end

  defp list_code do
    """
    <.pp_list>
      <.pp_list_subheader>Main</.pp_list_subheader>
      <.pp_list_item navigate={~p"/"}>Home</.pp_list_item>
      <.pp_list_item navigate={~p"/inbox"}>Inbox</.pp_list_item>
      <.pp_divider />
      <.pp_list_subheader>Account</.pp_list_subheader>
      <.pp_list_item navigate={~p"/settings"}>Settings</.pp_list_item>
    </.pp_list>\
    """
  end
end
