defmodule PhoenixPaperWebsiteWeb.Components.SurfacesLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :page_title, "Surfaces")}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:surfaces}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Surfaces">
          PhoenixPaper.Typography, Divider, BottomSheet and SideSheet. MD3's base container is the Card (on the Data Display page); for any other panel, use the surface-container color roles and the rounded-pp-* corners directly.
        </.page_header>

        <.section
          title="Typography"
          api={[{PhoenixPaper.Typography, :pp_typography}]}
          description="MD3's 15 type roles (display, headline, title, body, label in large/medium/small) plus code. variant picks the style and a sensible tag; tag overrides the element independently (an h2 that looks like title-large). emphasized is M3 Expressive's bolder variant of each role, and color sets a text color role."
          code={typography_code()}
        >
          <.demo_group label="The type scale" direction="column" spacing={:sm} class="items-start">
            <.pp_typography :for={variant <- type_roles()} variant={variant}>
              {variant}
            </.pp_typography>
          </.demo_group>
          <.demo_group label="emphasized" direction="column" spacing={:sm} class="items-start">
            <.pp_typography variant="headline-small" emphasized>
              headline-small emphasized
            </.pp_typography>
            <.pp_typography variant="title-medium" emphasized>title-medium emphasized</.pp_typography>
          </.demo_group>
          <.demo_group label="color" direction="column" spacing={:sm} class="items-start">
            <.pp_typography
              :for={color <- ~w(primary secondary tertiary error on-surface on-surface-variant)}
              color={color}
            >
              color="{color}"
            </.pp_typography>
          </.demo_group>
        </.section>

        <.section
          title="Divider"
          api={[{PhoenixPaper.Divider, :pp_divider}]}
          description="A thin outline-variant line that groups content in lists and layouts. inset indents it from the leading edge, the way MD3 separates list items that have a leading icon."
          code={divider_code()}
        >
          <.demo_group label="Full width and inset" direction="column">
            <.pp_typography variant="body-medium" tag="span">Above</.pp_typography>
            <.pp_divider />
            <.pp_typography variant="body-medium" tag="span">Between</.pp_typography>
            <.pp_divider inset />
            <.pp_typography variant="body-medium" tag="span">Below</.pp_typography>
          </.demo_group>
        </.section>

        <.section
          title="Bottom Sheet"
          api={[{PhoenixPaper.BottomSheet, :pp_bottom_sheet}]}
          description="MD3's bottom sheet. modal (default) slides up over a scrim with a drag handle, built like Dialog: always in the DOM, show/2 and hide/2 JS commands, focus trapping, Escape or a scrim click to dismiss. standard renders in place for persistent content docked to the bottom. With the JS hook it can be dragged down to dismiss."
          code={bottom_sheet_code()}
        >
          <.demo_group label="Try it">
            <.pp_button
              id="open-bottom-sheet"
              phx-click={PhoenixPaper.BottomSheet.show("share-sheet")}
            >
              <:start_icon><.pp_icon name="hero-share" size="sm" /></:start_icon>
              Share
            </.pp_button>
            <.pp_bottom_sheet id="share-sheet" label="Share">
              <.pp_list>
                <.pp_list_item phx-click={PhoenixPaper.BottomSheet.hide("share-sheet")}>
                  <:leading><.pp_icon name="hero-link" /></:leading>
                  Copy link
                </.pp_list_item>
                <.pp_list_item phx-click={PhoenixPaper.BottomSheet.hide("share-sheet")}>
                  <:leading><.pp_icon name="hero-envelope" /></:leading>
                  Email
                </.pp_list_item>
                <.pp_list_item phx-click={PhoenixPaper.BottomSheet.hide("share-sheet")}>
                  <:leading><.pp_icon name="hero-chat-bubble-left-right" /></:leading>
                  Message
                </.pp_list_item>
              </.pp_list>
            </.pp_bottom_sheet>
          </.demo_group>
        </.section>

        <.section
          title="Side Sheet"
          api={[{PhoenixPaper.SideSheet, :pp_side_sheet}]}
          description="MD3's side sheet at the end edge, for supplementary content and actions (filters, details). modal (default) slides in over a scrim with a header (optional back button, :title, close button) and :actions behind a divider; same show/hide JS and focus trapping as Dialog. standard renders in place as an aside beside your content."
          code={side_sheet_code()}
        >
          <.demo_group label="Try it">
            <.pp_button
              id="open-side-sheet"
              variant="tonal"
              phx-click={PhoenixPaper.SideSheet.show("filters-sheet")}
            >
              <:start_icon><.pp_icon name="hero-funnel" size="sm" /></:start_icon>
              Filters
            </.pp_button>
            <.pp_side_sheet id="filters-sheet">
              <:title>Filters</:title>
              <div class="flex flex-col gap-2">
                <.pp_checkbox name="sheet_unread" label="Unread only" />
                <.pp_checkbox name="sheet_attachments" label="Has attachments" />
                <.pp_switch name="sheet_starred" label="Starred" />
              </div>
              <:actions>
                <.pp_button phx-click={PhoenixPaper.SideSheet.hide("filters-sheet")}>Apply</.pp_button>
                <.pp_button
                  variant="outlined"
                  phx-click={PhoenixPaper.SideSheet.hide("filters-sheet")}
                >
                  Cancel
                </.pp_button>
              </:actions>
            </.pp_side_sheet>
          </.demo_group>
        </.section>
      </div>
    </Layouts.app>
    """
  end

  defp typography_code do
    """
    <.pp_typography variant="display-large">Display large</.pp_typography>
    <.pp_typography variant="headline-medium">Headline medium</.pp_typography>
    <.pp_typography variant="title-large">Title large</.pp_typography>
    <.pp_typography variant="body-large">Body large</.pp_typography>
    <.pp_typography variant="label-small">Label small</.pp_typography>
    <.pp_typography variant="code">mix phx.new my_app</.pp_typography>

    <%!-- tag independent of variant; Expressive emphasis; a color role --%>
    <.pp_typography variant="title-large" tag="h2" emphasized>Section</.pp_typography>
    <.pp_typography color="on-surface-variant">Muted text</.pp_typography>\
    """
  end

  defp divider_code do
    """
    <.pp_divider />
    <.pp_divider inset />\
    """
  end

  defp type_roles do
    for size <- ~w(large medium small), role <- ~w(display headline title body label) do
      "#{role}-#{size}"
    end
    |> Enum.sort_by(fn v ->
      [role, size] = String.split(v, "-")

      {Enum.find_index(~w(display headline title body label), &(&1 == role)),
       Enum.find_index(~w(large medium small), &(&1 == size))}
    end)
  end

  defp bottom_sheet_code do
    """
    <.pp_button phx-click={PhoenixPaper.BottomSheet.show("share")}>Share</.pp_button>

    <.pp_bottom_sheet id="share" label="Share">
      <.pp_list>
        <.pp_list_item phx-click="copy_link">
          <:leading><.pp_icon name="hero-link" /></:leading>
          Copy link
        </.pp_list_item>
      </.pp_list>
    </.pp_bottom_sheet>\
    """
  end

  defp side_sheet_code do
    """
    <.pp_button phx-click={PhoenixPaper.SideSheet.show("filters")}>Filters</.pp_button>

    <.pp_side_sheet id="filters">
      <:title>Filters</:title>
      <.pp_checkbox name="unread" label="Unread only" />
      <:actions>
        <.pp_button phx-click="apply_filters">Apply</.pp_button>
        <.pp_button variant="outlined" phx-click={PhoenixPaper.SideSheet.hide("filters")}>Cancel</.pp_button>
      </:actions>
    </.pp_side_sheet>\
    """
  end
end
