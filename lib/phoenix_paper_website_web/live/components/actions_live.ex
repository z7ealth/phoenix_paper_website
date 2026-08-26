defmodule PhoenixPaperWebsiteWeb.Components.ActionsLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Actions")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:actions}>
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Actions</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Button, PhoenixPaper.ButtonGroup, PhoenixPaper.Fab, PhoenixPaper.ToggleButton.
        </p>

        <.section
          title="Button"
          description="Five classic Material variants, each available in four colors. pp_button always renders a native button element, and ripples on click or tap by default (see the Helpers page)."
          props={[
            {"variant", "raised | flat | outlined | text | icon (default: raised)"},
            {"color", "primary | secondary | tertiary | error (default: primary)"},
            {"elevation", "override the resting elevation, 0-24 (default: nil, variant decides)"},
            {"shape", ":none | :xs | :sm | :md | :lg | :xl | :full (default: :full, a pill)"},
            {"ripple", "boolean, the ripple effect on click/tap (default: true)"},
            {"disabled", "boolean (default: false)"},
            {"loading", "boolean, spinner replaces start_icon, disables the button (default: false)"},
            {":start_icon / :end_icon", "slots: an icon before/after the label"},
            {"type", "button | submit | reset (default: button)"},
            {"paperize", "boolean (default: true)"},
            {"class", "merged on top via Tails"}
          ]}
          code={button_code()}
        >
          <.demo_group :for={variant <- ~w(raised flat outlined text icon)} label={variant}>
            <.pp_button
              :for={color <- ~w(primary secondary tertiary error)}
              variant={variant}
              color={color}
            >
              <.pp_icon :if={variant == "icon"} name="hero-star" />
              <span :if={variant != "icon"}>{color}</span>
            </.pp_button>
          </.demo_group>

          <.demo_group label="Icons and loading">
            <.pp_button variant="outlined">
              <:start_icon><.pp_icon name="hero-trash" /></:start_icon>
              Delete
            </.pp_button>
            <.pp_button>
              Send
              <:end_icon><.pp_icon name="hero-check" /></:end_icon>
            </.pp_button>
            <.pp_button loading>
              <:start_icon><.pp_icon name="hero-trash" /></:start_icon>
              Delete
            </.pp_button>
          </.demo_group>

          <.demo_group label="Disabled and paperize: false">
            <.pp_button disabled>Raised</.pp_button>
            <.pp_button variant="outlined" disabled>Outlined</.pp_button>
            <.pp_button
              paperize={false}
              class="rounded-none border-4 border-dashed border-fuchsia-500 px-3 py-1 font-mono text-fuchsia-700"
            >
              paperize: false
            </.pp_button>
          </.demo_group>
        </.section>

        <.section
          title="Button Group"
          description="Visually joins a row of buttons into one segmented control by rounding only the outer corners. No group-level color/variant that cascades to children like MUI's; set each button's own attrs."
          props={[
            {"orientation", "horizontal | vertical (default: horizontal)"},
            {"shape", "corner radius token for the group's outer corners (default: :md)"},
            {"disable_elevation",
             "boolean, zero out every child button's own elevation shadow (default: false)"},
            {"paperize", "boolean (default: true)"},
            {"class", "merged on top via Tails"}
          ]}
          code={button_group_code()}
        >
          <.demo_group label="Horizontal">
            <.pp_button_group>
              <.pp_button variant="outlined">Day</.pp_button>
              <.pp_button variant="outlined">Week</.pp_button>
              <.pp_button variant="outlined">Month</.pp_button>
            </.pp_button_group>
          </.demo_group>

          <.demo_group label="Vertical" class="items-start">
            <.pp_button_group orientation="vertical">
              <.pp_button variant="outlined">Day</.pp_button>
              <.pp_button variant="outlined">Week</.pp_button>
              <.pp_button variant="outlined">Month</.pp_button>
            </.pp_button_group>
          </.demo_group>

          <.demo_group label="disable_elevation">
            <.pp_button_group disable_elevation>
              <.pp_button>Save</.pp_button>
              <.pp_button>Cancel</.pp_button>
            </.pp_button_group>
          </.demo_group>
        </.section>

        <.section
          title="Floating Action Button"
          description="A circular, elevated, icon-only button, or an extended pill with a label, typically anchored to a screen corner."
          props={[
            {"color", "primary | secondary | tertiary | error (default: secondary)"},
            {"size", "sm | md | lg (default: md)"},
            {"extended", "boolean, labeled pill instead of a fixed circle (default: false)"},
            {"ripple", "boolean (default: true)"},
            {"disabled", "boolean (default: false)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={fab_code()}
        >
          <.demo_group label="Sizes">
            <.pp_fab :for={size <- ~w(sm md lg)} size={size}><.pp_icon name="hero-star" /></.pp_fab>
          </.demo_group>

          <.demo_group label="Colors and extended">
            <.pp_fab :for={color <- ~w(primary secondary tertiary error)} color={color}>
              <.pp_icon name="hero-star" />
            </.pp_fab>
            <.pp_fab extended color="primary">
              <.pp_icon name="hero-star" /> Create
            </.pp_fab>
          </.demo_group>
        </.section>

        <.section
          title="Toggle Button"
          description="A button with a boolean pressed state, filled when pressed. Combine several inside a Button Group for a segmented toggle."
          props={[
            {"pressed", "boolean (default: false)"},
            {"color", "primary | secondary | tertiary | error (default: primary)"},
            {"shape", "corner radius token (default: :md)"},
            {"ripple", "boolean (default: true)"},
            {"disabled", "boolean (default: false)"}
          ]}
          code={toggle_button_code()}
        >
          <.demo_group label="Standalone">
            <.pp_toggle_button pressed>Bold</.pp_toggle_button>
            <.pp_toggle_button>Italic</.pp_toggle_button>
            <.pp_toggle_button>Underline</.pp_toggle_button>
          </.demo_group>

          <.demo_group label="Colors, pressed">
            <.pp_toggle_button
              :for={color <- ~w(primary secondary tertiary error)}
              pressed
              color={color}
            >
              {color}
            </.pp_toggle_button>
          </.demo_group>

          <.demo_group label="Grouped">
            <.pp_button_group>
              <.pp_toggle_button pressed><.pp_icon name="hero-view-columns" /></.pp_toggle_button>
              <.pp_toggle_button><.pp_icon name="hero-squares-2x2" /></.pp_toggle_button>
              <.pp_toggle_button><.pp_icon name="hero-rectangle-group" /></.pp_toggle_button>
            </.pp_button_group>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp button_code do
    """
    <.pp_button color="primary">Save</.pp_button>
    <.pp_button variant="outlined" color="secondary">Outlined</.pp_button>
    <.pp_button variant="text">Text</.pp_button>
    <.pp_button ripple={false}>No ripple</.pp_button>
    <.pp_button paperize={false} class="border-4 border-dashed border-fuchsia-500 px-3 py-1 font-mono text-fuchsia-700">
      paperize: false
    </.pp_button>

    <.pp_button variant="outlined">
      <:start_icon><.pp_icon name="hero-trash" /></:start_icon>
      Delete
    </.pp_button>
    <.pp_button>
      Send
      <:end_icon><.pp_icon name="hero-check" /></:end_icon>
    </.pp_button>
    <.pp_button loading>
      <:start_icon><.pp_icon name="hero-trash" /></:start_icon>
      Delete
    </.pp_button>\
    """
  end

  defp button_group_code do
    """
    <.pp_button_group>
      <.pp_button variant="outlined">Day</.pp_button>
      <.pp_button variant="outlined">Week</.pp_button>
      <.pp_button variant="outlined">Month</.pp_button>
    </.pp_button_group>

    <.pp_button_group orientation="vertical">
      <.pp_button variant="outlined">Day</.pp_button>
      <.pp_button variant="outlined">Week</.pp_button>
      <.pp_button variant="outlined">Month</.pp_button>
    </.pp_button_group>

    <.pp_button_group disable_elevation>
      <.pp_button>Save</.pp_button>
      <.pp_button>Cancel</.pp_button>
    </.pp_button_group>\
    """
  end

  defp fab_code do
    """
    <.pp_fab :for={size <- ~w(sm md lg)} size={size}><.pp_icon name="hero-star" /></.pp_fab>
    <.pp_fab :for={color <- ~w(primary secondary tertiary error)} color={color}>
      <.pp_icon name="hero-star" />
    </.pp_fab>
    <.pp_fab extended color="primary">
      <.pp_icon name="hero-star" /> Create
    </.pp_fab>\
    """
  end

  defp toggle_button_code do
    """
    <.pp_toggle_button pressed={@bold_pressed} phx-click="toggle_bold">
      Bold
    </.pp_toggle_button>

    <.pp_toggle_button :for={color <- ~w(primary secondary tertiary error)} pressed color={color}>
      {color}
    </.pp_toggle_button>\
    """
  end
end
