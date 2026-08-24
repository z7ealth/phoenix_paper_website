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
          PhoenixPaper.Navbar, PhoenixPaper.Drawer, and the PhoenixPaper.List family.
        </p>

        <.section
          title="Navbar"
          description="A horizontal app bar with a leading slot, a title, and trailing actions. This site's own chrome doesn't use one anymore -- just a floating theme toggle instead -- so here it is on its own."
        >
          <.demo_group label="Preview">
            <.pp_box class="w-full overflow-hidden rounded-xl border border-pp-outline/15">
              <.pp_navbar color="surface" elevation={0} class="border-b border-pp-outline/10">
                <:leading>
                  <.pp_drawer_toggle for="site-drawer" />
                  <span class="font-medium">My App</span>
                </:leading>
                <:actions>
                  <.pp_button variant="icon" color="primary">
                    <.pp_icon name="hero-bell" />
                  </.pp_button>
                </:actions>
              </.pp_navbar>
            </.pp_box>
          </.demo_group>
          <p class="text-sm text-pp-on-surface/60">
            That's a real, working pp_drawer_toggle in the leading slot -- on a narrow
            screen it opens this very page's sidebar.
          </p>
        </.section>

        <.section
          title="Drawer"
          description="A vertical navigation panel, persistent on large screens and toggled by a mobile drawer below that breakpoint. Compose it with List / ListItem for its contents."
        >
          <div class="rounded-xl border border-pp-outline/15 bg-pp-surface-variant/30 p-6 text-sm text-pp-on-surface/70">
            The sidebar on the left of this very page is pp_drawer — every link in it is a
            pp_list_item using navigate, highlighted active on whichever page you're on
            (real LiveView navigation, no full page reload). Its mobile toggle is pure
            CSS: pp_drawer renders a visually hidden checkbox, and pp_drawer_toggle is
            just a label wired to that checkbox's id, so it can live anywhere on the
            page — no JavaScript required.
          </div>
        </.section>

        <.section
          title="List"
          description="A vertical stack of list items, with optional sub-headers and dividers to group them. Renders items as links, buttons, or plain rows depending on their own attrs — a linked item ripples on click by default, just like Button. Click Home or Inbox below to see it."
        >
          <.demo_group label="Preview">
            <.pp_box class="w-full max-w-xs overflow-hidden rounded-xl border border-pp-outline/15 pp-elevation-1">
              <.pp_list class="bg-pp-surface py-2">
                <.pp_list_subheader>Main</.pp_list_subheader>
                <.pp_list_item href="#" active>
                  <:leading><.pp_icon name="hero-home" /></:leading>
                  Home
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

        <.section
          title="Divider"
          description="A thin separator line, optionally inset past a leading icon column instead of spanning full width."
        >
          <.demo_group label="Variants" class="flex-col items-stretch gap-4">
            <.pp_divider />
            <.pp_divider inset />
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end
end
