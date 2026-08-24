defmodule PhoenixPaperWebsiteWeb.Components.ButtonsLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Buttons")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:buttons}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Buttons</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Button, PhoenixPaper.ButtonGroup, PhoenixPaper.ToggleButton, and
          PhoenixPaper.Fab.
        </p>

        <.section
          title="Button"
          description="Five classic Material variants, each available in four colors. pp_button always renders a native button element, and ripples on click or tap by default."
        >
          <.demo_group label="Variants">
            <.pp_button variant="raised">Raised</.pp_button>
            <.pp_button variant="flat">Flat</.pp_button>
            <.pp_button variant="outlined">Outlined</.pp_button>
            <.pp_button variant="text">Text</.pp_button>
            <.pp_button variant="icon"><.pp_icon name="hero-bell" /></.pp_button>
          </.demo_group>

          <.demo_group label="Colors">
            <.pp_button color="primary">Primary</.pp_button>
            <.pp_button color="secondary">Secondary</.pp_button>
            <.pp_button color="tertiary">Tertiary</.pp_button>
            <.pp_button color="error">Error</.pp_button>
          </.demo_group>

          <.demo_group label="Shape">
            <.pp_button shape={:full}>Full</.pp_button>
            <.pp_button shape={:lg}>Large</.pp_button>
            <.pp_button shape={:sm}>Small</.pp_button>
            <.pp_button shape={:none}>None</.pp_button>
          </.demo_group>

          <.demo_group label="Disabled">
            <.pp_button disabled>Raised</.pp_button>
            <.pp_button variant="outlined" disabled>Outlined</.pp_button>
            <.pp_button variant="text" disabled>Text</.pp_button>
          </.demo_group>
        </.section>

        <.section
          title="Ripple"
          description="Click or tap any button on this page — a circle expands from that point and fades out. Button, Fab, ToggleButton, and a linked ListItem all get it by default, and it's a boolean ripple attribute away from being turned off."
        >
          <.demo_group label="ripple: true (default) vs. ripple: false">
            <.pp_button>Try me</.pp_button>
            <.pp_button ripple={false}>No ripple</.pp_button>
          </.demo_group>
          <p class="text-sm text-pp-on-surface/60">
            Still no JS hook or bundler — same philosophy as NumberField's stepper buttons,
            just a small vanilla onclick snippet that spawns and animates a span with plain
            inline styles.
          </p>
        </.section>

        <.section
          title="Button Group"
          description="Visually joins a row of buttons into one segmented control by rounding only the group's outer corners."
        >
          <.demo_group label="Segmented control">
            <.pp_button_group>
              <.pp_button variant="outlined">Day</.pp_button>
              <.pp_button variant="outlined">Week</.pp_button>
              <.pp_button variant="outlined">Month</.pp_button>
            </.pp_button_group>
          </.demo_group>
        </.section>

        <.section
          title="Toggle Button"
          description="A button with a boolean pressed state, filled when pressed. Combine several inside a Button Group for a segmented toggle."
        >
          <.demo_group label="Standalone">
            <.pp_toggle_button pressed>Bold</.pp_toggle_button>
            <.pp_toggle_button>Italic</.pp_toggle_button>
            <.pp_toggle_button>Underline</.pp_toggle_button>
          </.demo_group>

          <.demo_group label="Grouped">
            <.pp_button_group>
              <.pp_toggle_button pressed><.pp_icon name="hero-view-columns" /></.pp_toggle_button>
              <.pp_toggle_button><.pp_icon name="hero-squares-2x2" /></.pp_toggle_button>
              <.pp_toggle_button><.pp_icon name="hero-rectangle-group" /></.pp_toggle_button>
            </.pp_button_group>
          </.demo_group>
        </.section>

        <.section
          title="Floating Action Button"
          description="A circular, elevated, icon-only button, or an extended pill with a label — typically anchored to a screen corner."
        >
          <.demo_group label="Sizes">
            <.pp_fab size="sm"><.pp_icon name="hero-sparkles" /></.pp_fab>
            <.pp_fab size="md"><.pp_icon name="hero-sparkles" /></.pp_fab>
            <.pp_fab size="lg"><.pp_icon name="hero-sparkles" /></.pp_fab>
          </.demo_group>

          <.demo_group label="Colors and extended">
            <.pp_fab color="primary"><.pp_icon name="hero-sparkles" /></.pp_fab>
            <.pp_fab color="tertiary"><.pp_icon name="hero-sparkles" /></.pp_fab>
            <.pp_fab color="error"><.pp_icon name="hero-sparkles" /></.pp_fab>
            <.pp_fab extended>
              <.pp_icon name="hero-sparkles" /> Create
            </.pp_fab>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end
end
