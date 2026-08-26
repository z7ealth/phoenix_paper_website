defmodule PhoenixPaperWebsiteWeb.Components.LayoutLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Layout")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:layout}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Layout</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Box, Container, Stack, Grid / GridItem, and Divider: Tailwind-native
          layout primitives in the spirit of MUI's Layout category. Every page on this site,
          including this one, is built out of them.
        </p>

        <.section
          title="Box"
          description="A bare div/span/pre that exists purely to hold a class: no visual style of its own, and the only component with no paperize attr at all, since there's no skin to strip."
          props={[{"tag", "div | span | pre (default: div)"}]}
          code={box_code()}
        >
          <.demo_group label="Preview">
            <.pp_box class="rounded-lg bg-pp-primary/10 p-4 text-sm text-pp-primary">
              tag="div" (default)
            </.pp_box>
            <.pp_box
              tag="span"
              class="rounded-full bg-pp-secondary/10 px-4 py-2 text-sm text-pp-secondary"
            >
              tag="span"
            </.pp_box>
            <.pp_box tag="pre" class="rounded-lg bg-pp-tertiary/10 p-4 text-xs text-pp-tertiary">
              tag="pre", whitespace preserved.
            </.pp_box>
          </.demo_group>
        </.section>

        <.section
          title="Container"
          description="A centered, width-constrained content wrapper. This very page's content sits inside one (max_width=lg); here it is again, nested, at two other widths."
          props={[
            {"max_width", "sm | md | lg | xl | 2xl | full (default: lg)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={container_code()}
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
          description="A one-dimensional flex layout: row or column, with consistent spacing between children. No divider slot to auto-interleave (a stateless component only gets one opaque inner_block); add a Divider yourself where you want one. The bordered canvas around every demo on this site is a pp_stack."
          props={[
            {"direction", "row | column (default: column)"},
            {"spacing", "a Spacing token, :none | :xs | :sm | :md | :lg | :xl | :2xl (default: :md)"},
            {"wrap", "boolean (default: false)"}
          ]}
          code={stack_code()}
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
          description="A 12-column CSS grid container, paired with GridItem for each column-spanning child. GridItem's md attribute overrides its span at the md: breakpoint and up, the only responsive breakpoint supported, since every value has to be a literal Tailwind class."
          props={[
            {"pp_grid spacing", "a Spacing token (default: :md)"},
            {"pp_grid_item span", "1-12 (default: 12)"},
            {"pp_grid_item md", "1-12, overrides span at md: and up (default: nil, no override)"}
          ]}
          code={grid_code()}
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
          title="Divider"
          description="A thin separator line, most often used between sections of a List."
          props={[
            {"inset",
             "boolean, indent past a leading icon/avatar column instead of spanning full width (default: false)"}
          ]}
          code={divider_code()}
        >
          <.demo_group label="Variants" class="flex-col items-stretch gap-4">
            <span class="text-sm">Above</span>
            <.pp_divider />
            <span class="text-sm">Below</span>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp box_code do
    """
    <.pp_box class="rounded-lg bg-pp-surface-variant p-4">A div (default).</.pp_box>
    <.pp_box tag="span" class="rounded bg-pp-surface-variant px-2 py-1">A span.</.pp_box>
    <.pp_box tag="pre" class="rounded-lg bg-pp-surface-variant p-4">A pre, whitespace preserved.</.pp_box>\
    """
  end

  defp container_code do
    """
    <.pp_container max_width="sm">
      Narrower content.
    </.pp_container>

    <.pp_container :for={width <- ~w(sm md lg xl 2xl full)} max_width={width} class="mb-2">
      {width}
    </.pp_container>\
    """
  end

  defp stack_code do
    """
    <.pp_stack direction="row" spacing={:sm}>
      <.pp_button>Save</.pp_button>
      <.pp_button variant="outlined">Cancel</.pp_button>
    </.pp_stack>

    <.pp_stack direction="column" spacing={:sm}>
      <.pp_button>Save</.pp_button>
      <.pp_button variant="outlined">Cancel</.pp_button>
    </.pp_stack>\
    """
  end

  defp grid_code do
    """
    <.pp_grid>
      <.pp_grid_item span={12} md={4}>Sidebar</.pp_grid_item>
      <.pp_grid_item span={12} md={8}>Content</.pp_grid_item>
    </.pp_grid>\
    """
  end

  defp divider_code do
    """
    <.pp_divider />
    <.pp_divider inset />\
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
