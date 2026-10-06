defmodule PhoenixPaperWebsiteWeb.Components.ActionsLive do
  use PhoenixPaperWebsiteWeb, :live_view

  alias Phoenix.LiveView.JS

  @formats ~w(bold italic underline)
  @views [
    {"columns", "hero-view-columns", "Columns"},
    {"grid", "hero-squares-2x2", "Grid"},
    {"group", "hero-rectangle-group", "Grouped"}
  ]

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Actions")
     |> assign(:formats, MapSet.new(["bold"]))
     |> assign(:view, "columns")}
  end

  # Controlled toggle buttons: their selected state lives in these assigns.
  def handle_event("toggle_format", %{"format" => format}, socket) when format in @formats do
    formats =
      if MapSet.member?(socket.assigns.formats, format),
        do: MapSet.delete(socket.assigns.formats, format),
        else: MapSet.put(socket.assigns.formats, format)

    {:noreply, assign(socket, :formats, formats)}
  end

  def handle_event("set_view", %{"view" => view}, socket) do
    view = if view in Enum.map(@views, &elem(&1, 0)), do: view, else: socket.assigns.view
    {:noreply, assign(socket, :view, view)}
  end

  def handle_event("demo_action", %{"action" => action}, socket) do
    {:noreply, put_flash(socket, :info, "#{action} clicked")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:actions}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Actions">
          PhoenixPaper.Button, IconButton, SplitButton, ButtonGroup, Fab and FabMenu: the MD3
          (and M3 Expressive) action components.
        </.page_header>

        <.section
          title="Button"
          description="MD3's five button styles (filled, tonal, elevated, outlined, text) in the Expressive sizes xs–xl and round or square shapes; pressing morphs the corners on the Expressive spring. href, navigate or patch renders a link instead of a button element. Toggle buttons are built in: selected={...} makes a controlled toggle (aria-pressed from your assigns plus phx-click), toggle flips it on the client, and group makes a client-side set exclusive."
          api={[{PhoenixPaper.Button, :pp_button}]}
          code={button_code()}
        >
          <.demo_group label="variant">
            <.pp_button :for={variant <- ~w(filled tonal elevated outlined text)} variant={variant}>
              {variant}
            </.pp_button>
          </.demo_group>

          <.demo_group label="color">
            <.pp_button :for={color <- ~w(primary secondary tertiary error)} color={color}>
              {color}
            </.pp_button>
          </.demo_group>

          <.demo_group label="size (round), and square">
            <.pp_button :for={size <- ~w(xs sm md lg xl)} size={size}>{size}</.pp_button>
            <.pp_button shape="square" variant="tonal">square</.pp_button>
          </.demo_group>

          <.demo_group label="Icons, loading, link">
            <.pp_button variant="outlined">
              <:start_icon><.pp_icon name="hero-trash" size="sm" /></:start_icon>
              Delete
            </.pp_button>
            <.pp_button variant="tonal">
              Next
              <:end_icon><.pp_icon name="hero-arrow-right" size="sm" /></:end_icon>
            </.pp_button>
            <.pp_button loading>Saving</.pp_button>
            <.pp_button variant="text" navigate={~p"/getting-started"}>Getting started</.pp_button>
          </.demo_group>

          <.demo_group label="Toggle, controlled (any combination)">
            <.pp_button
              :for={format <- ~w(bold italic underline)}
              id={"toggle-format-#{format}"}
              variant="outlined"
              selected={format in @formats}
              phx-click="toggle_format"
              phx-value-format={format}
            >
              {String.capitalize(format)}
            </.pp_button>
          </.demo_group>

          <.demo_group label="Toggle, client-side (toggle)">
            <.pp_button id="client-toggle-bold" variant="tonal" toggle selected>Bold</.pp_button>
            <.pp_button id="client-toggle-italic" variant="tonal" toggle selected={false}>
              Italic
            </.pp_button>
            <.pp_button id="client-toggle-underline" variant="tonal" toggle selected={false}>
              Underline
            </.pp_button>
          </.demo_group>
        </.section>

        <.section
          title="Icon Button"
          description="An icon-only button: standard (no container), filled, tonal or outlined, in the Expressive sizes, narrow/default/wide widths and round/square shapes. label is required: it's the accessible name and the native tooltip. Like Button it toggles (selected / toggle / group), and selected_icon swaps the glyph, MD3's outlined → filled pair."
          api={[{PhoenixPaper.IconButton, :pp_icon_button}]}
          code={icon_button_code()}
        >
          <.demo_group label="variant">
            <.pp_icon_button
              :for={variant <- ~w(standard filled tonal outlined)}
              variant={variant}
              icon="hero-heart"
              label={variant}
            />
          </.demo_group>

          <.demo_group label="size and width">
            <.pp_icon_button
              :for={size <- ~w(xs sm md lg)}
              size={size}
              variant="tonal"
              icon="hero-star"
              label={"size #{size}"}
            />
            <.pp_icon_button
              :for={width <- ~w(narrow default wide)}
              width={width}
              variant="filled"
              icon="hero-plus"
              label={"width #{width}"}
            />
          </.demo_group>

          <.demo_group label="Toggle with selected_icon (click)">
            <.pp_icon_button
              id="icon-toggle-star"
              icon="hero-star"
              selected_icon="hero-star-solid"
              label="Star"
              toggle
              selected={false}
            />
            <.pp_icon_button
              id="icon-toggle-bookmark"
              icon="hero-bookmark"
              selected_icon="hero-bookmark-solid"
              label="Bookmark"
              variant="tonal"
              toggle
              selected
            />
          </.demo_group>
        </.section>

        <.section
          title="Split Button"
          description="A primary action joined to a trailing button that opens a menu of related actions (M3 Expressive). The halves sit 2dp apart; opening the menu morphs the trailing half into a circle and flips its chevron. phx-click and other global attrs go on the leading button; the menu holds pp_menu_item/1s."
          api={[{PhoenixPaper.SplitButton, :pp_split_button}]}
          code={split_button_code()}
        >
          <.demo_group label="Try it">
            <.pp_split_button id="split-send" phx-click="demo_action" phx-value-action="Send">
              Send
              <:menu>
                <.pp_menu_item icon="hero-clock" phx-click="demo_action" phx-value-action="Schedule">
                  Schedule send
                </.pp_menu_item>
                <.pp_menu_item icon="hero-document" phx-click="demo_action" phx-value-action="Draft">
                  Save draft
                </.pp_menu_item>
              </:menu>
            </.pp_split_button>
            <.pp_split_button id="split-tonal" variant="tonal">
              <:start_icon><.pp_icon name="hero-arrow-down-tray" size="sm" /></:start_icon>
              Export
              <:menu>
                <.pp_menu_item>As PDF</.pp_menu_item>
                <.pp_menu_item>As CSV</.pp_menu_item>
              </:menu>
            </.pp_split_button>
          </.demo_group>
        </.section>

        <.section
          title="Button Group"
          description="Groups related buttons (M3 Expressive). standard keeps them as separate buttons in a row; connected joins them into one segmented control with shared inner corners. Give the buttons a toggle group for a single-select control, like the exclusive view switch below."
          api={[{PhoenixPaper.ButtonGroup, :pp_button_group}]}
          code={button_group_code()}
        >
          <.demo_group label="standard">
            <.pp_button_group>
              <.pp_button variant="tonal">Day</.pp_button>
              <.pp_button variant="tonal">Week</.pp_button>
              <.pp_button variant="tonal">Month</.pp_button>
            </.pp_button_group>
          </.demo_group>

          <.demo_group label="connected, controlled single-select (click)">
            <.pp_button_group variant="connected">
              <.pp_button
                :for={{view, icon, label} <- views()}
                id={"toggle-view-#{view}"}
                variant="tonal"
                selected={@view == view}
                phx-click="set_view"
                phx-value-view={view}
              >
                <:start_icon><.pp_icon name={icon} size="sm" /></:start_icon>
                {label}
              </.pp_button>
            </.pp_button_group>
          </.demo_group>

          <.demo_group label="connected, client-side single-select (group)">
            <.pp_button_group variant="connected">
              <.pp_button
                :for={{view, _icon, label} <- views()}
                id={"client-toggle-view-#{view}"}
                variant="outlined"
                group="client-view-demo"
                selected={view == "columns"}
              >
                {label}
              </.pp_button>
            </.pp_button_group>
          </.demo_group>
        </.section>

        <.section
          title="Floating Action Button"
          description={
            ~S|The screen's primary action: an icon on a primary-container square (MD3 FABs are 16dp-corner squares, not circles), in default, medium and large sizes. icon and label are attrs: label is the accessible name, and shown beside the icon with extended. Anchor one to a corner with position="fixed" plus offsets in class.|
          }
          api={[{PhoenixPaper.Fab, :pp_fab}]}
          code={fab_code()}
        >
          <.demo_group label="size">
            <.pp_fab
              :for={size <- ~w(default medium large)}
              size={size}
              icon="hero-pencil"
              label={"Compose (#{size})"}
            />
          </.demo_group>
          <.demo_group label="color">
            <.pp_fab
              :for={color <- ~w(primary-container secondary-container tertiary-container surface)}
              color={color}
              icon="hero-plus"
              label={color}
            />
          </.demo_group>
          <.demo_group label="extended, lowered">
            <.pp_fab extended icon="hero-pencil" label="Compose" />
            <.pp_fab lowered icon="hero-plus" label="Add (lowered)" />
          </.demo_group>
        </.section>

        <.section
          title="FAB Menu"
          description="A FAB that opens a short stack of related actions, M3 Expressive's replacement for the speed dial. Tapping it morphs the FAB into a round close button and the items rise above it as labeled pills; the close button, clicking outside, or Escape closes it. Pure CSS. Items link (href/navigate/patch) or fire on_click (a JS)."
          api={[{PhoenixPaper.FabMenu, :pp_fab_menu}]}
          code={fab_menu_code()}
        >
          <.demo_group label="Try it">
            <div class="flex h-72 w-full items-end justify-end">
              <.pp_fab_menu id="fab-menu-demo" label="Create">
                <:item
                  icon="hero-document"
                  label="Document"
                  on_click={JS.push("demo_action", value: %{action: "Document"})}
                />
                <:item
                  icon="hero-table-cells"
                  label="Spreadsheet"
                  on_click={JS.push("demo_action", value: %{action: "Spreadsheet"})}
                />
                <:item
                  icon="hero-photo"
                  label="Photo"
                  on_click={JS.push("demo_action", value: %{action: "Photo"})}
                />
              </.pp_fab_menu>
            </div>
          </.demo_group>
        </.section>
      </div>
    </Layouts.app>
    """
  end

  defp views, do: @views

  defp button_code do
    """
    <.pp_button :for={variant <- ~w(filled tonal elevated outlined text)} variant={variant}>
      {variant}
    </.pp_button>

    <.pp_button :for={size <- ~w(xs sm md lg xl)} size={size}>{size}</.pp_button>
    <.pp_button shape="square" variant="tonal">square</.pp_button>

    <.pp_button variant="outlined">
      <:start_icon><.pp_icon name="hero-trash" size="sm" /></:start_icon>
      Delete
    </.pp_button>
    <.pp_button loading>Saving</.pp_button>
    <.pp_button variant="text" navigate={~p"/getting-started"}>Getting started</.pp_button>

    <%!-- Controlled toggle: selected from your assigns, plus phx-click --%>
    <.pp_button
      variant="outlined"
      selected={"bold" in @formats}
      phx-click="toggle_format"
      phx-value-format="bold"
    >
      Bold
    </.pp_button>

    <%!-- Client-side toggle: no assigns, selected is the initial state --%>
    <.pp_button variant="tonal" toggle selected={false}>Italic</.pp_button>

    # In the LiveView (controlled example):
    def handle_event("toggle_format", %{"format" => format}, socket) do
      formats = socket.assigns.formats
      formats = if format in formats, do: MapSet.delete(formats, format), else: MapSet.put(formats, format)
      {:noreply, assign(socket, :formats, formats)}
    end\
    """
  end

  defp icon_button_code do
    """
    <.pp_icon_button :for={variant <- ~w(standard filled tonal outlined)} variant={variant} icon="hero-heart" label={variant} />

    <.pp_icon_button size="lg" variant="tonal" icon="hero-star" label="Star" />
    <.pp_icon_button width="wide" variant="filled" icon="hero-plus" label="Add" />

    <%!-- A toggle that swaps to the filled glyph when selected --%>
    <.pp_icon_button icon="hero-star" selected_icon="hero-star-solid" label="Star" toggle selected={false} />\
    """
  end

  defp split_button_code do
    """
    <.pp_split_button id="send" phx-click="send">
      Send
      <:menu>
        <.pp_menu_item icon="hero-clock" phx-click="schedule">Schedule send</.pp_menu_item>
        <.pp_menu_item icon="hero-document" phx-click="save_draft">Save draft</.pp_menu_item>
      </:menu>
    </.pp_split_button>\
    """
  end

  defp button_group_code do
    """
    <.pp_button_group>
      <.pp_button variant="tonal">Day</.pp_button>
      <.pp_button variant="tonal">Week</.pp_button>
      <.pp_button variant="tonal">Month</.pp_button>
    </.pp_button_group>

    <%!-- A single-select segmented control, client-side --%>
    <.pp_button_group variant="connected">
      <.pp_button variant="outlined" group="view" selected>Columns</.pp_button>
      <.pp_button variant="outlined" group="view" selected={false}>Grid</.pp_button>
      <.pp_button variant="outlined" group="view" selected={false}>Grouped</.pp_button>
    </.pp_button_group>\
    """
  end

  defp fab_code do
    """
    <.pp_fab icon="hero-pencil" label="Compose" />
    <.pp_fab size="large" color="tertiary-container" icon="hero-plus" label="Add" />
    <.pp_fab extended icon="hero-pencil" label="Compose" />

    <%!-- Anchored to the screen corner --%>
    <.pp_fab position="fixed" class="bottom-6 right-6" icon="hero-plus" label="Add" />\
    """
  end

  defp fab_menu_code do
    """
    <.pp_fab_menu id="create" label="Create" position="fixed" class="bottom-4 right-4">
      <:item icon="hero-document" label="Document" navigate={~p"/docs/new"} />
      <:item icon="hero-table-cells" label="Spreadsheet" on_click={JS.push("new_sheet")} />
      <:item icon="hero-photo" label="Photo" on_click={JS.push("upload")} />
    </.pp_fab_menu>\
    """
  end
end
