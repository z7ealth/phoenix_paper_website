defmodule PhoenixPaperWebsiteWeb.Components.SurfacesLive do
  use PhoenixPaperWebsiteWeb, :live_view

  @messages [
    %{
      id: 1,
      from: "Ada Lovelace",
      subject: "Notes on the engine",
      body:
        "The engine weaves algebraic patterns the way the Jacquard loom weaves flowers and leaves."
    },
    %{
      id: 2,
      from: "Grace Hopper",
      subject: "Found a bug",
      body: "Literally a moth, taped into the logbook. First actual case of a bug being found."
    },
    %{
      id: 3,
      from: "Alan Turing",
      subject: "Can machines think?",
      body: "I propose to consider the question by replacing it with a game."
    }
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Surfaces", messages: @messages, message: nil)}
  end

  # Pane Layout's list-detail demo: which message the detail pane shows.
  def handle_event("open_message", %{"id" => id}, socket) do
    id = String.to_integer(id)
    {:noreply, assign(socket, :message, Enum.find(@messages, &(&1.id == id)))}
  end

  def handle_event("close_message", _params, socket),
    do: {:noreply, assign(socket, :message, nil)}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:surfaces}>
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Surfaces">
          PhoenixPaper.Typography, Divider, the pane layouts (ListDetail and SupportingPane),
          BottomSheet and SideSheet. MD3's base container is the Card (on the Data Display page); for any other panel, use the surface-container color roles and the rounded-pp-* corners directly.
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
          title="Pane Layout"
          api={[
            {PhoenixPaper.PaneLayout, :pp_list_detail},
            {PhoenixPaper.PaneLayout, :pp_supporting_pane}
          ]}
          description="MD3's canonical layouts, from its Layout foundations: window size classes (compact under 600dp, medium to 839dp, expanded from 840dp), 16/24dp margins, a 24dp spacer and 360dp fixed panes. pp_list_detail shows both panes on expanded windows and one at a time below, chosen with show_detail (going back is yours to render). pp_supporting_pane puts a 360dp supporting pane beside the main one, or below it on smaller windows. The panes have no surface of their own: put a Card or List inside."
          code={pane_layout_code()}
        >
          <.demo_group
            label="pp_list_detail (narrow the window to see one pane at a time)"
            direction="column"
          >
            <div
              id="list-detail-demo"
              class="overflow-hidden rounded-pp-md border border-pp-outline-variant"
            >
              <.pp_list_detail show_detail={@message != nil}>
                <:list>
                  <.pp_list>
                    <.pp_list_item
                      :for={m <- @messages}
                      id={"message-#{m.id}"}
                      phx-click="open_message"
                      phx-value-id={m.id}
                      active={@message != nil and @message.id == m.id}
                    >
                      <:leading>
                        <.pp_avatar>{initials(m.from)}</.pp_avatar>
                      </:leading>
                      {m.from}
                      <:secondary>{m.subject}</:secondary>
                    </.pp_list_item>
                  </.pp_list>
                </:list>
                <:detail>
                  <.pp_card :if={@message} id="message-detail" variant="filled" class="my-4">
                    <:title>{@message.subject}</:title>
                    <:subhead>From {@message.from}</:subhead>
                    {@message.body}
                    <:actions>
                      <.pp_button id="close-message" variant="text" phx-click="close_message">
                        Back to the list
                      </.pp_button>
                    </:actions>
                  </.pp_card>
                  <.pp_typography
                    :if={!@message}
                    variant="body-medium"
                    color="on-surface-variant"
                    class="py-6"
                  >
                    Pick a message.
                  </.pp_typography>
                </:detail>
              </.pp_list_detail>
            </div>
          </.demo_group>

          <.demo_group label="pp_supporting_pane" direction="column">
            <div
              id="supporting-pane-demo"
              class="overflow-hidden rounded-pp-md border border-pp-outline-variant"
            >
              <.pp_supporting_pane class="py-4">
                <.pp_card variant="outlined">
                  <:title>The main pane</:title>
                  Flexible: it takes whatever the supporting pane leaves.
                </.pp_card>
                <:supporting>
                  <.pp_card variant="filled">
                    <:title>Supporting</:title>
                    360dp beside the main pane from 840dp, below it before that.
                  </.pp_card>
                </:supporting>
              </.pp_supporting_pane>
            </div>
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

  defp pane_layout_code do
    """
    <.pp_list_detail show_detail={@message != nil}>
      <:list>
        <.pp_list>
          <.pp_list_item :for={m <- @messages} patch={~p"/inbox/\#{m.id}"} active={m.id == @message_id}>
            {m.subject}
          </.pp_list_item>
        </.pp_list>
      </:list>
      <:detail>
        <.pp_card :if={@message} variant="filled">
          <:title>{@message.subject}</:title>
          {@message.body}
          <:actions>
            <%!-- Below 840dp only one pane shows: going back is yours --%>
            <.pp_button variant="text" patch={~p"/inbox"}>Back</.pp_button>
          </:actions>
        </.pp_card>
      </:detail>
    </.pp_list_detail>

    <.pp_supporting_pane>
      <article>...</article>
      <:supporting>
        <.pp_list>
          <.pp_list_item :for={r <- @related} navigate={r.path}>{r.title}</.pp_list_item>
        </.pp_list>
      </:supporting>
    </.pp_supporting_pane>\
    """
  end

  defp initials(name),
    do: name |> String.split() |> Enum.map_join(&String.first/1)

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
