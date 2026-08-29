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
          PhoenixPaper.Button, PhoenixPaper.ButtonGroup, PhoenixPaper.Fab, PhoenixPaper.SpeedDial,
          PhoenixPaper.ToggleButton.
        </p>

        <.section
          title="Button"
          description="Five classic Material variants, each available in four colors. Ripples on click or tap by default (see the Helpers page). Passing href, navigate or patch switches it to link mode, rendering an anchor instead of a button element, keeping every variant/color/ripple: for a button that navigates, without nesting a button inside a link."
          props={[
            {"variant", "raised | flat | outlined | text | icon (default: raised)"},
            {"color", "primary | secondary | tertiary | error (default: primary)"},
            {"elevation", "override the resting elevation, 0-24 (default: nil, variant decides)"},
            {"shape", ":none | :xs | :sm | :md | :lg | :xl | :full (default: :full, a pill)"},
            {"ripple", "boolean, the ripple effect on click/tap (default: true)"},
            {"disabled",
             "boolean (default: false), also works in link mode (aria-disabled + pointer-events-none)"},
            {"loading", "boolean, spinner replaces start_icon, disables the button (default: false)"},
            {"href / navigate / patch",
             "any set renders an anchor (Phoenix.Component.link/1) instead of a button, same styling. method/download/target/rel pass through"},
            {":start_icon / :end_icon", "slots: an icon before/after the label"},
            {"type", "button | submit | reset (default: button, ignored in link mode)"},
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

          <.demo_group label="Link mode (href / navigate / patch)">
            <.pp_button href="#button" variant="text">Link (href)</.pp_button>
            <.pp_button navigate="#button">Link (navigate)</.pp_button>
            <.pp_button href="#button" disabled variant="outlined">Disabled link</.pp_button>
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
          title="Speed Dial"
          description="A FAB that fans out related actions on hover, click/tap, or keyboard focus, in the spirit of MUI's SpeedDial. Pure CSS, no JS: the same hidden-checkbox + peer-checked / group-hover trick as Drawer and Tooltip. You anchor the whole thing to a corner with a fixed class; direction then picks which way the actions open. Each action's label shows as an always-on pill (MUI's tooltipOpen look)."
          props={[
            {"id / label",
             "id wires the toggle checkbox; label is the trigger's accessible name (both required)"},
            {"direction", "up (default) | down | left | right"},
            {"color", "primary | secondary | tertiary | error (default: secondary), the trigger"},
            {"size", "sm | md | lg (default: md), the trigger"},
            {"default_open", "boolean (default: false), uncontrolled, no server wiring"},
            {":icon / :open_icon",
             "closed icon (default hero-plus, rotates 45deg when open) / a distinct icon to cross-fade to instead"},
            {":action",
             "slot, body is the icon. Attrs: label (pill text), href / navigate / patch (link mode), on_click (a JS or event name)"},
            {"ripple", "boolean (default: true), off whenever paperize is false"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={speed_dial_code()}
        >
          <.demo_group label="Hover, tap, or tab to a trigger" class="items-end">
            <div class="flex flex-wrap items-end gap-16 px-2 pt-28 pb-6">
              <.pp_speed_dial id="sd_create_demo" label="Create">
                <:action label="New workbook"><.pp_icon name="hero-document-plus" /></:action>
                <:action label="New folder"><.pp_icon name="hero-folder-plus" /></:action>
                <:action label="Import"><.pp_icon name="hero-arrow-up-tray" /></:action>
              </.pp_speed_dial>
              <.pp_speed_dial id="sd_share_demo" label="Share" direction="right" color="primary">
                <:action label="Copy link"><.pp_icon name="hero-link" /></:action>
                <:action label="Email"><.pp_icon name="hero-envelope" /></:action>
              </.pp_speed_dial>
              <.pp_speed_dial id="sd_menu_demo" label="Menu" direction="down">
                <:icon><.pp_icon name="hero-bars-3" /></:icon>
                <:open_icon><.pp_icon name="hero-x-mark" /></:open_icon>
                <:action label="Settings"><.pp_icon name="hero-cog-6-tooth" /></:action>
                <:action label="Help"><.pp_icon name="hero-question-mark-circle" /></:action>
              </.pp_speed_dial>
            </div>
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
    </.pp_button>

    <%!-- href/navigate/patch render an <a> (Phoenix.Component.link/1), so a
          "button" that navigates never nests <button> inside <a> --%>
    <.pp_button href={~p"/getting-started"} variant="text">Getting started</.pp_button>
    <.pp_button navigate={~p"/components"}>Browse components</.pp_button>\
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

  defp speed_dial_code do
    ~S'''
    <%!-- Anchor the whole thing yourself; direction fans the actions from there.
          Opens on hover, click/tap, or keyboard focus -- pure CSS, no JS. --%>
    <.pp_speed_dial id="create" label="Create" class="fixed bottom-6 right-6">
      <:action label="New workbook" navigate={~p"/workbooks/new"}>
        <.pp_icon name="hero-document-plus" />
      </:action>
      <:action label="Invite teammate" on_click={JS.push("open_invite")}>
        <.pp_icon name="hero-user-plus" />
      </:action>
    </.pp_speed_dial>

    <%!-- :open_icon cross-fades instead of rotating the :icon 45deg --%>
    <.pp_speed_dial id="menu" label="Menu" direction="down">
      <:icon><.pp_icon name="hero-bars-3" /></:icon>
      <:open_icon><.pp_icon name="hero-x-mark" /></:open_icon>
      <:action label="Share"><.pp_icon name="hero-share" /></:action>
    </.pp_speed_dial>
    '''
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
