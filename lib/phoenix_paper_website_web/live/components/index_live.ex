defmodule PhoenixPaperWebsiteWeb.Components.IndexLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias PhoenixPaperWebsiteWeb.Nav

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Components", items: Nav.component_items())}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Every component, in one place</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          Pick a category to see it live: real PhoenixPaper components, not screenshots.
        </p>

        <.pp_grid spacing={:md}>
          <.pp_grid_item :for={item <- @items} span={12} md={6}>
            <.link
              navigate={item.path}
              class="group flex h-full items-start gap-4 rounded-xl border border-pp-outline/15 bg-pp-surface-variant/30 p-6 transition-colors hover:border-pp-primary/40 hover:bg-pp-primary/5"
            >
              <.pp_box class="flex size-10 shrink-0 items-center justify-center rounded-full bg-pp-primary/10 text-pp-primary">
                <.pp_icon name={item.icon} />
              </.pp_box>
              <.pp_box class="min-w-0">
                <h2 class="flex items-center gap-1 font-medium text-pp-on-surface">
                  {item.label}
                  <.pp_icon
                    name="hero-arrow-right"
                    class="size-4 -translate-x-1 opacity-0 transition-all group-hover:translate-x-0 group-hover:opacity-100"
                  />
                </h2>
                <p class="text-sm text-pp-on-surface/60">{item.blurb}</p>
              </.pp_box>
            </.link>
          </.pp_grid_item>
        </.pp_grid>
      </.pp_container>
    </Layouts.app>
    """
  end
end
