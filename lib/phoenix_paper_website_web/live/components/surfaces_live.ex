defmodule PhoenixPaperWebsiteWeb.Components.SurfacesLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias PhoenixPaper.{Elevation, Shape}

  @elevation_levels [0, 1, 2, 4, 6, 8, 12, 16, 24]
  @shape_tokens [:none, :xs, :sm, :md, :lg, :xl, :full]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Surfaces")
     |> assign(:elevation_levels, @elevation_levels)
     |> assign(:shape_tokens, @shape_tokens)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:surfaces}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Surfaces</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Card, plus the Elevation and Shape helpers every component in this
          library builds on.
        </p>

        <.section
          title="Card"
          description="A surface container with optional title and actions slots."
        >
          <.demo_group label="Basic" class="items-start">
            <.pp_card class="w-72">
              <:title>Account</:title>
              You have no pending invoices this month.
              <:actions>
                <.pp_button variant="text">Dismiss</.pp_button>
                <.pp_button variant="text" color="primary">Review</.pp_button>
              </:actions>
            </.pp_card>

            <.pp_card class="w-72" elevation={8}>
              <:title>Elevation 8</:title>
              Higher elevation reads as "closer" to the viewer — useful for a card that
              floats above the rest of the page, like a menu or a picker.
            </.pp_card>

            <.pp_card class="w-72" shape={:none}>
              <:title>Square corners</:title>
              The shape attribute accepts the same token scale as Button and ToggleButton.
            </.pp_card>
          </.demo_group>
        </.section>

        <.section
          title="Elevation"
          description="PhoenixPaper.Elevation maps a Material dp level (0-24) to a pp-elevation-N class backed by a two-layer box-shadow."
        >
          <.demo_group label="Scale" class="items-end">
            <.pp_box :for={level <- @elevation_levels} class="flex flex-col items-center gap-2">
              <div class={[
                "flex size-16 items-center justify-center rounded-lg bg-pp-surface text-xs font-medium text-pp-on-surface/60",
                Elevation.class(level)
              ]}>
                {level}
              </div>
            </.pp_box>
          </.demo_group>
        </.section>

        <.section
          title="Shape"
          description="PhoenixPaper.Shape maps a token to a literal rounded-* class, so components share one consistent corner-radius scale."
        >
          <.demo_group label="Scale" class="items-end">
            <.pp_box :for={token <- @shape_tokens} class="flex flex-col items-center gap-2">
              <div class={[
                "flex size-16 items-center justify-center bg-pp-primary/15 text-xs font-medium text-pp-primary",
                Shape.class(token)
              ]}>
                {token}
              </div>
            </.pp_box>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end
end
