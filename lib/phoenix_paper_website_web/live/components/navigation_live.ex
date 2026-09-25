defmodule PhoenixPaperWebsiteWeb.Components.NavigationLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Navigation")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:navigation}>
      <.pp_container max_width="lg">
        <.page_header eyebrow="Components" title="Navigation">
          PhoenixPaper.AppBar, Drawer, Menu, Tabs, Breadcrumbs, and the List family.
        </.page_header>

        <.section
          title="App Bar"
          description="A horizontal app bar with a leading slot, a title, and trailing actions (renamed from Navbar to match MUI's own naming). This site's own chrome doesn't use one anymore (just a floating theme toggle instead), so here it is on its own. Default toolbar gutters are responsive (px-4 rising to px-6 at the sm breakpoint), matching MUI's Toolbar."
          props={[
            {"color", "primary | secondary | accent | surface | transparent (default: primary)"},
            {"elevation", "resting elevation, 0-24 (default: 4), ignored for color=\"transparent\""},
            {"position", "static | relative | sticky | fixed | absolute (default: static)"},
            {"variant", "regular | dense (default: regular), dense shrinks the toolbar row"},
            {"max_width",
             "sm | md | lg | xl | 2xl | full (default: full): caps and centres the toolbar content, like wrapping MUI's Toolbar in a Container. Line it up with a pp_container of the same max_width below"},
            {"disable_gutters", "boolean (default: false): drops the toolbar's horizontal padding"},
            {"paperize", "boolean (default: true)"}
          ]}
          slots={[
            {":leading", "content before the title, e.g. a pp_drawer_toggle"},
            {":actions", "content after the title, e.g. icon buttons"}
          ]}
          code={app_bar_code()}
        >
          <.demo_group label="Colors" direction="column">
            <.pp_app_bar
              :for={color <- ~w(primary secondary accent surface transparent)}
              color={color}
            >
              {color}
            </.pp_app_bar>
          </.demo_group>

          <.demo_group label="Dense variant" direction="column">
            <.pp_app_bar variant="dense">Dense toolbar row</.pp_app_bar>
          </.demo_group>

          <.demo_group label="max_width (content capped + centred)" direction="column">
            <.pp_app_bar max_width="sm" color="surface" class="border border-pp-outline/30">
              max_width="sm"
              <:actions>
                <.pp_button variant="icon" color="inherit"><.pp_icon name="hero-bell" /></.pp_button>
              </:actions>
            </.pp_app_bar>
          </.demo_group>

          <.demo_group label="With leading/actions (color=&quot;inherit&quot;)" direction="column">
            <.pp_app_bar>
              <:leading>
                <.pp_drawer_toggle for="site-drawer" />
                <span>My App</span>
              </:leading>
              <:actions>
                <.pp_button variant="icon" color="inherit" aria-label="Notifications">
                  <.pp_icon name="hero-bell" />
                </.pp_button>
              </:actions>
            </.pp_app_bar>
          </.demo_group>
          <.pp_typography variant="body2" color="muted">
            A Button's default color is the brand color (primary), whatever it sits on: on a
            primary app bar that's the exact same color as the background. Give buttons on a
            colored bar color="inherit" so they follow the bar's own text color, as above.
            The drawer toggle already does.
          </.pp_typography>
        </.section>

        <.section
          title="Drawer"
          description="A vertical navigation panel, persistent on large screens and toggled by a mobile drawer below that breakpoint: pure CSS via a hidden checkbox, no JS."
          props={[
            {"id", "required: builds the mobile toggle checkbox's id as \"\#{id}-toggle\""},
            {"color",
             "primary | secondary | accent | surface (default: surface), also restyles nested List/ListItem for contrast"},
            {"width", "sm | md | lg | xl (default: md)"},
            {"paperize", "boolean (default: true)"},
            {"pp_drawer_toggle for=",
             "a hamburger label pointing at the given drawer's id; works from anywhere on the page"}
          ]}
          slots={[{":header", "content above the drawer's own inner_block, e.g. a logo/app name"}]}
          code={drawer_code()}
        >
          <.pp_card>
            The sidebar on the left of this very page is pp_drawer holding a dense pp_list:
            the Overview links are pp_list_items using navigate, highlighted active on
            whichever page you're on (real LiveView navigation, no full page reload), and each
            component category is a pp_list_group, open on its own page, listing that page's
            components. Its mobile toggle is pure CSS: pp_drawer
            renders a visually hidden checkbox, and pp_drawer_toggle is just a label wired to
            that checkbox's id, so it can live anywhere on the page, no JavaScript required.
            color also reaches into nested List/ListItem/ListSubheader/Divider so a colored
            drawer stays readable, not just a style mismatch (see the App Bar note above;
            the same "same color on same color" trap applies to an active item's highlight).
            width picks a fixed panel width (sm/md/lg/xl), applied at both the mobile and
            desktop breakpoint together.
          </.pp_card>
        </.section>

        <.section
          title="Tabs"
          description="Tabs/Tab/TabPanel switch entirely client-side via Phoenix.LiveView.JS commands fired on click: no server round-trip, no sliding indicator animation (that needs a real layout measurement JS commands can't do)."
          props={[
            {"pp_tabs id", "required: shared with every Tab/TabPanel in the group"},
            {"pp_tabs orientation", "horizontal | vertical (default: horizontal)"},
            {"pp_tabs variant",
             "standard | scrollable | full_width (default: standard), horizontal only"},
            {"pp_tabs centered",
             "boolean (default: false): center the tabs; horizontal standard variant only"},
            {"pp_tab id / value",
             "id matches the parent Tabs; value must be unique within the group"},
            {"pp_tab default_selected", "boolean, initial selection, uncontrolled (default: false)"},
            {"pp_tab color",
             "primary | secondary | accent | error (default: primary), set per Tab, doesn't cascade"},
            {"pp_tab disabled / ripple / paperize", "same as Button"},
            {"pp_tab_panel id / value", "must match the corresponding Tab exactly"}
          ]}
          slots={[{"pp_tab :icon", "optional leading icon"}]}
          code={tabs_code()}
        >
          <.demo_group label="Basic" direction="column">
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

          <.demo_group label="Colors" direction="column">
            <.pp_tabs id="color-tabs">
              <.pp_tab id="color-tabs" value="primary" default_selected color="primary">
                Primary
              </.pp_tab>
              <.pp_tab id="color-tabs" value="secondary" color="secondary">Secondary</.pp_tab>
              <.pp_tab id="color-tabs" value="accent" color="accent">Accent</.pp_tab>
              <.pp_tab id="color-tabs" value="error" color="error">Error</.pp_tab>
            </.pp_tabs>
          </.demo_group>

          <.demo_group label="variant=&quot;full_width&quot;" direction="column">
            <.pp_tabs id="full-width-tabs" variant="full_width">
              <.pp_tab id="full-width-tabs" value="one" default_selected>One</.pp_tab>
              <.pp_tab id="full-width-tabs" value="two">Two</.pp_tab>
              <.pp_tab id="full-width-tabs" value="three">Three</.pp_tab>
            </.pp_tabs>
          </.demo_group>

          <.demo_group label="Vertical, with icons" direction="column">
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
            {"max_items", "collapse into an expandable ellipsis beyond this many items (default: 8)"},
            {"items_before_collapse / items_after_collapse",
             "collapsed slice sizes (default: 1 / 1)"},
            {"expand_text", "aria-label for the ellipsis expand control (default: \"Show path\")"},
            {"paperize", "boolean (default: true)"}
          ]}
          slots={[
            {":item href/navigate/patch",
             "makes that item a link; omit all three for the current page"},
            {":separator", "not a string: can hold an icon; defaults to \"/\""}
          ]}
          code={breadcrumbs_code()}
        >
          <.demo_group label="Basic" direction="column" class="items-start">
            <.pp_breadcrumbs>
              <:item href="#">Home</:item>
              <:item href="#">Catalog</:item>
              <:item>Current product</:item>
            </.pp_breadcrumbs>
          </.demo_group>

          <.demo_group label="Custom separator" direction="column" class="items-start">
            <.pp_breadcrumbs>
              <:separator><.pp_icon name="hero-chevron-right" class="size-4" /></:separator>
              <:item href="#">Home</:item>
              <:item href="#">Settings</:item>
              <:item>Profile</:item>
            </.pp_breadcrumbs>
          </.demo_group>

          <.demo_group
            label="max_items={3}: click the ellipsis to expand"
            direction="column"
            class="items-start"
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
          title="Menu"
          description="A trigger that reveals a small anchored popover list of actions, in the spirit of MUI's Menu/MenuItem: an overflow (...) menu, a profile menu, anything where clicking a button reveals a short list of things to do next. Built with plain Phoenix.LiveView.JS commands and phx-click-away, not a hook: closes on selecting an item, clicking outside, or Escape."
          props={[
            {"id", "required"},
            {"anchor",
             "bottom-start (default) | bottom-end | top-start | top-end, relative to the trigger"},
            {"elevation", "resting elevation, 0-24 (default: 8)"},
            {"shape", "corner radius token (default: :sm)"},
            {"paperize", "boolean (default: true)"}
          ]}
          slots={[
            {":trigger", "required: the clickable content that opens the menu"},
            {":inner_block", "required: the popover's content, typically a pp_list"}
          ]}
          code={menu_code()}
        >
          <.demo_group label="Try it">
            <.pp_menu id="demo-menu">
              <:trigger>
                <.pp_button variant="outlined">
                  Actions
                  <:end_icon><.pp_icon name="hero-chevron-down" /></:end_icon>
                </.pp_button>
              </:trigger>
              <.pp_list>
                <.pp_list_item>
                  <:leading><.pp_icon name="hero-pencil-square" /></:leading>
                  Edit
                </.pp_list_item>
                <.pp_list_item>
                  <:leading><.pp_icon name="hero-document-duplicate" /></:leading>
                  Duplicate
                </.pp_list_item>
                <.pp_divider />
                <.pp_list_item>
                  <:leading><.pp_icon name="hero-trash" /></:leading>
                  Delete
                </.pp_list_item>
              </.pp_list>
            </.pp_menu>

            <.pp_menu id="demo-menu-icon" anchor="bottom-end">
              <:trigger>
                <.pp_button variant="icon"><.pp_icon name="hero-ellipsis-vertical" /></.pp_button>
              </:trigger>
              <.pp_list>
                <.pp_list_item href="#">Profile</.pp_list_item>
                <.pp_list_item href="#">Settings</.pp_list_item>
                <.pp_list_item>Log out</.pp_list_item>
              </.pp_list>
            </.pp_menu>
          </.demo_group>
        </.section>

        <.section
          title="List"
          description="A vertical stack of list items, with optional sub-headers to group them. Renders items as links, buttons, or plain rows depending on their own attrs: a linked item ripples on click by default, just like Button. Click Home or Inbox below to see it."
          props={[
            {"pp_list", "the container, role=\"list\""},
            {"pp_list dense", "boolean (default: false): compact rows for every item inside"},
            {"pp_list nested", "boolean (default: false): indent the whole list one step"},
            {"pp_list inset",
             "boolean (default: false): line up items without a leading icon with those that have one"},
            {"pp_list_item href/navigate/patch", "makes it a link; active/disabled/ripple as usual"},
            {"pp_list_item dense", "boolean (default: false): a compact row, for one item alone"},
            {"pp_list_group",
             "a list item that expands to show a nested list (MUI's nested List + Collapse): id (required), default_open, dense. The sidebar on this page is built from these"},
            {"pp_list_subheader", "a small uppercase section label"}
          ]}
          slots={[
            {"pp_list_item :leading", "an icon or avatar"},
            {"pp_list_item :secondary", "a subtitle line below the primary one"},
            {"pp_list_item :trailing", "a trailing icon, badge, or action"},
            {"pp_list_group :leading / :label", "the group row's own icon and text"},
            {"pp_list_group :inner_block", "the nested items, indented one step"}
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

          <.demo_group label="dense + inset, with a collapsible pp_list_group">
            <.pp_paper class="w-full max-w-xs">
              <.pp_list id="list-group-demo" dense inset>
                <.pp_list_item href="#">
                  <:leading><.pp_icon name="hero-inbox" /></:leading>
                  Inbox
                </.pp_list_item>
                <.pp_list_item href="#">Drafts</.pp_list_item>
                <.pp_list_group id="list-group-demo-projects" default_open>
                  <:leading><.pp_icon name="hero-folder" /></:leading>
                  <:label>Projects</:label>
                  <.pp_list_item href="#">Website</.pp_list_item>
                  <.pp_list_item href="#">Mobile app</.pp_list_item>
                </.pp_list_group>
                <.pp_list_group id="list-group-demo-archive">
                  <:leading><.pp_icon name="hero-archive-box" /></:leading>
                  <:label>Archive</:label>
                  <.pp_list_item href="#">2025</.pp_list_item>
                  <.pp_list_item href="#">2024</.pp_list_item>
                </.pp_list_group>
              </.pp_list>
            </.pp_paper>
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
        <.pp_button variant="icon" color="inherit"><.pp_icon name="hero-bell" /></.pp_button>
      </:actions>
    </.pp_app_bar>

    <.pp_app_bar :for={color <- ~w(primary secondary accent surface transparent)} color={color} class="!static">
      {color}
      <:actions>
        <.pp_button variant="icon" color="inherit"><.pp_icon name="hero-bell" /></.pp_button>
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
      <:actions><.pp_theme_toggle /></:actions>
    </.pp_app_bar>\
    """
  end

  defp drawer_code do
    """
    <.pp_app_bar>
      <:leading><.pp_drawer_toggle for="app-drawer" /></:leading>
      My App
    </.pp_app_bar>

    <.pp_drawer id="app-drawer" color="primary" width="lg">
      <:header>My App</:header>
      <.pp_list>
        <.pp_list_item href="/" active>Home</.pp_list_item>
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

  defp menu_code do
    """
    <.pp_menu id="profile-menu" anchor="bottom-end">
      <:trigger><.pp_icon name="hero-ellipsis-vertical" /></:trigger>
      <.pp_list>
        <.pp_list_item navigate={~p"/profile"}>Profile</.pp_list_item>
        <.pp_list_item navigate={~p"/settings"}>Settings</.pp_list_item>
        <.pp_list_item phx-click="log_out">Log out</.pp_list_item>
      </.pp_list>
    </.pp_menu>\
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
    </.pp_list>

    <%!-- dense rows; inset lines "Drafts" up with the items that have icons --%>
    <.pp_list dense inset>
      <.pp_list_item navigate={~p"/inbox"}>
        <:leading><.pp_icon name="hero-inbox" /></:leading>
        Inbox
      </.pp_list_item>
      <.pp_list_item navigate={~p"/drafts"}>Drafts</.pp_list_item>
      <.pp_list_group id="nav-projects" default_open>
        <:leading><.pp_icon name="hero-folder" /></:leading>
        <:label>Projects</:label>
        <.pp_list_item navigate={~p"/projects/website"}>Website</.pp_list_item>
        <.pp_list_item navigate={~p"/projects/mobile"}>Mobile app</.pp_list_item>
      </.pp_list_group>
    </.pp_list>\
    """
  end
end
