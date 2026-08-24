defmodule PhoenixPaperWebsiteWeb.Components.LayoutLive do
  use PhoenixPaperWebsiteWeb, :live_view

  @tiles [
    {"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB2aWV3Qm94PSIwIDAgNDAwIDQwMCI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiBmaWxsPSIjM2Y1MWI1Ii8+Cjx0ZXh0IHg9IjIwMCIgeT0iMjE1IiBmb250LWZhbWlseT0idWktc2Fucy1zZXJpZixzeXN0ZW0tdWksc2Fucy1zZXJpZiIgZm9udC1zaXplPSI0MCIgZmlsbD0iI2ZmZmZmZiIgdGV4dC1hbmNob3I9Im1pZGRsZSI+VGlsZSAxPC90ZXh0Pgo8L3N2Zz4=",
     "Tile 1"},
    {"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB2aWV3Qm94PSIwIDAgNDAwIDQwMCI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiBmaWxsPSIjZmY0MDgxIi8+Cjx0ZXh0IHg9IjIwMCIgeT0iMjE1IiBmb250LWZhbWlseT0idWktc2Fucy1zZXJpZixzeXN0ZW0tdWksc2Fucy1zZXJpZiIgZm9udC1zaXplPSI0MCIgZmlsbD0iIzAwMDAwMCIgdGV4dC1hbmNob3I9Im1pZGRsZSI+VGlsZSAyPC90ZXh0Pgo8L3N2Zz4=",
     "Tile 2"},
    {"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB2aWV3Qm94PSIwIDAgNDAwIDQwMCI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiBmaWxsPSIjMDA5Njg4Ii8+Cjx0ZXh0IHg9IjIwMCIgeT0iMjE1IiBmb250LWZhbWlseT0idWktc2Fucy1zZXJpZixzeXN0ZW0tdWksc2Fucy1zZXJpZiIgZm9udC1zaXplPSI0MCIgZmlsbD0iI2ZmZmZmZiIgdGV4dC1hbmNob3I9Im1pZGRsZSI+VGlsZSAzPC90ZXh0Pgo8L3N2Zz4=",
     "Tile 3"},
    {"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB2aWV3Qm94PSIwIDAgNDAwIDQwMCI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiBmaWxsPSIjZDMyZjJmIi8+Cjx0ZXh0IHg9IjIwMCIgeT0iMjE1IiBmb250LWZhbWlseT0idWktc2Fucy1zZXJpZixzeXN0ZW0tdWksc2Fucy1zZXJpZiIgZm9udC1zaXplPSI0MCIgZmlsbD0iI2ZmZmZmZiIgdGV4dC1hbmNob3I9Im1pZGRsZSI+VGlsZSA0PC90ZXh0Pgo8L3N2Zz4=",
     "Tile 4"},
    {"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB2aWV3Qm94PSIwIDAgNDAwIDQwMCI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiBmaWxsPSIjNWM2YmMwIi8+Cjx0ZXh0IHg9IjIwMCIgeT0iMjE1IiBmb250LWZhbWlseT0idWktc2Fucy1zZXJpZixzeXN0ZW0tdWksc2Fucy1zZXJpZiIgZm9udC1zaXplPSI0MCIgZmlsbD0iI2ZmZmZmZiIgdGV4dC1hbmNob3I9Im1pZGRsZSI+VGlsZSA1PC90ZXh0Pgo8L3N2Zz4=",
     "Tile 5"},
    {"data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiB2aWV3Qm94PSIwIDAgNDAwIDQwMCI+CjxyZWN0IHdpZHRoPSI0MDAiIGhlaWdodD0iNDAwIiBmaWxsPSIjMjZhNjlhIi8+Cjx0ZXh0IHg9IjIwMCIgeT0iMjE1IiBmb250LWZhbWlseT0idWktc2Fucy1zZXJpZixzeXN0ZW0tdWksc2Fucy1zZXJpZiIgZm9udC1zaXplPSI0MCIgZmlsbD0iI2ZmZmZmZiIgdGV4dC1hbmNob3I9Im1pZGRsZSI+VGlsZSA2PC90ZXh0Pgo8L3N2Zz4=",
     "Tile 6"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Layout", tiles: @tiles)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:layout}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Layout</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Box, PhoenixPaper.Container, PhoenixPaper.Stack, PhoenixPaper.Grid /
          PhoenixPaper.GridItem, and PhoenixPaper.ImageList / PhoenixPaper.ImageListItem —
          Tailwind-native layout primitives in the spirit of MUI's Layout category. Every
          page on this site, including this one, is built out of them.
        </p>

        <.section
          title="Box"
          description="A bare div (or span, via tag) that exists purely to hold a class -- no visual style of its own, and the only component with no paperize attribute, since there's no skin to strip."
        >
          <.demo_group label="Preview">
            <.pp_box class="rounded-lg bg-pp-primary/10 p-4 text-sm text-pp-primary">
              pp_box tag="div" (default)
            </.pp_box>
            <.pp_box
              tag="span"
              class="rounded-full bg-pp-secondary/10 px-4 py-2 text-sm text-pp-secondary"
            >
              pp_box tag="span"
            </.pp_box>
          </.demo_group>
        </.section>

        <.section
          title="Container"
          description="A centered, width-constrained content wrapper. This very page's content sits inside one (max_width=lg) -- here it is again, nested, at two other widths."
        >
          <.demo_group label="max_width comparison" class="flex-col items-stretch">
            <div class="rounded-lg border border-dashed border-pp-outline/30 p-2">
              <.pp_container
                max_width="sm"
                class="bg-pp-primary/10 py-3 text-center text-xs text-pp-primary"
              >
                max_width="sm"
              </.pp_container>
            </div>
            <div class="rounded-lg border border-dashed border-pp-outline/30 p-2">
              <.pp_container
                max_width="xl"
                class="bg-pp-secondary/10 py-3 text-center text-xs text-pp-secondary"
              >
                max_width="xl"
              </.pp_container>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Stack"
          description="A one-dimensional flex layout -- row or column, with consistent spacing between children. The bordered canvas around every demo on this site is a pp_stack."
        >
          <.demo_group label="direction: row">
            <.pp_stack direction="row" spacing={:sm}>
              <.layout_swatch color="primary">1</.layout_swatch>
              <.layout_swatch color="secondary">2</.layout_swatch>
              <.layout_swatch color="tertiary">3</.layout_swatch>
            </.pp_stack>
          </.demo_group>

          <.demo_group label="direction: column" class="items-start">
            <.pp_stack direction="column" spacing={:sm}>
              <.layout_swatch color="primary">1</.layout_swatch>
              <.layout_swatch color="secondary">2</.layout_swatch>
              <.layout_swatch color="tertiary">3</.layout_swatch>
            </.pp_stack>
          </.demo_group>
        </.section>

        <.section
          title="Grid & GridItem"
          description="A 12-column CSS grid container, paired with GridItem for each column-spanning child. GridItem's md attribute overrides its span at the md: breakpoint and up."
        >
          <.demo_group label="Even thirds" class="flex-col items-stretch">
            <.pp_grid spacing={:sm}>
              <.pp_grid_item :for={n <- 1..3} span={4}>
                <.layout_swatch color="primary" class="w-full">{n}</.layout_swatch>
              </.pp_grid_item>
            </.pp_grid>
          </.demo_group>

          <.demo_group
            label="Stack on mobile, three columns on desktop (span=12 md=4)"
            class="flex-col items-stretch"
          >
            <.pp_grid spacing={:sm}>
              <.pp_grid_item :for={n <- 1..3} span={12} md={4}>
                <.layout_swatch color="secondary" class="w-full">{n}</.layout_swatch>
              </.pp_grid_item>
            </.pp_grid>
          </.demo_group>
        </.section>

        <.section
          title="Image List"
          description="A grid gallery of images with an optional title/subtitle overlay bar -- the standard variant (masonry/quilted/woven aren't implemented). Tiles below are generated placeholder SVGs, not real photos."
        >
          <.demo_group label="cols=3" class="flex-col items-stretch">
            <.pp_image_list cols={3} spacing={:sm}>
              <.pp_image_list_item
                :for={{src, label} <- @tiles}
                src={src}
                title={label}
                subtitle="Placeholder"
              />
            </.pp_image_list>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  attr :color, :string, values: ~w(primary secondary tertiary)
  attr :class, :any, default: nil
  slot :inner_block, required: true

  defp layout_swatch(assigns) do
    ~H"""
    <.pp_box class={[
      "flex size-16 items-center justify-center rounded-lg text-sm font-medium",
      swatch_classes(@color),
      @class
    ]}>
      {render_slot(@inner_block)}
    </.pp_box>
    """
  end

  defp swatch_classes("primary"), do: "bg-pp-primary/15 text-pp-primary"
  defp swatch_classes("secondary"), do: "bg-pp-secondary/15 text-pp-secondary"
  defp swatch_classes("tertiary"), do: "bg-pp-tertiary/15 text-pp-tertiary"
end
