defmodule PhoenixPaperWebsiteWeb.Components.IndexLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias PhoenixPaperWebsiteWeb.Nav

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Components", items: Nav.component_items())}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Every component, in one place">
          Pick a category to see it live: real PhoenixPaper components, not screenshots.
        </.page_header>

        <div class="grid grid-cols-12 gap-4">
          <div :for={item <- @items} class="col-span-12 md:col-span-6">
            <.pp_card id={"category-#{item.id}"} navigate={item.path} class="h-full">
              <:title>{item.label}</:title>
              <.pp_avatar class="mb-3"><.pp_icon name={item.icon} /></.pp_avatar>
              <.pp_typography variant="body-medium" color="on-surface-variant">
                {item.blurb}
              </.pp_typography>
            </.pp_card>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
