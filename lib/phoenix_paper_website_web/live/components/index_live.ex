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
        <.page_header eyebrow="Components" title="Every component, in one place">
          Pick a category to see it live: real PhoenixPaper components, not screenshots.
        </.page_header>

        <.pp_grid spacing={:md}>
          <.pp_grid_item :for={item <- @items} span={12} md={6}>
            <.pp_card id={"category-#{item.id}"} navigate={item.path} class="h-full">
              <:title>{item.label}</:title>
              <.pp_avatar color="primary" class="mb-3"><.pp_icon name={item.icon} /></.pp_avatar>
              <.pp_typography variant="body2" color="muted">{item.blurb}</.pp_typography>
            </.pp_card>
          </.pp_grid_item>
        </.pp_grid>
      </.pp_container>
    </Layouts.app>
    """
  end
end
