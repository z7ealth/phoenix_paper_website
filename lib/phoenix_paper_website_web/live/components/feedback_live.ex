defmodule PhoenixPaperWebsiteWeb.Components.FeedbackLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Feedback")}
  end

  # The Snackbar demos' "Undo" / close button just prove the click reaches
  # the LiveView instead of crashing it -- there's no open assign to clear.
  def handle_event("dismiss", _params, socket), do: {:noreply, socket}

  # The Flash section drives PhoenixPaper.Flash against the real @flash --
  # put_flash/3 here, the ✕ on each chip clears it via LiveView's built-in
  # lv:clear-flash (no handler for that). This page opts out of the layout's
  # default flash_group so the two don't both render the same message.
  def handle_event("flash_info", _params, socket),
    do: {:noreply, put_flash(socket, :info, "Workbook saved.")}

  def handle_event("flash_error", _params, socket),
    do: {:noreply, put_flash(socket, :error, "Could not reach the guest agent.")}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_page={:feedback} flash_group={false}>
      <Layouts.flash_group flash={@flash} auto_hide_duration={6000} />
      <div class="mx-auto w-full px-4 max-w-screen-lg">
        <.page_header eyebrow="Components" title="Feedback">
          PhoenixPaper.Dialog, Progress, LoadingIndicator, Snackbar and Flash. MD3 has no alert
          banner or skeleton: reach for a snackbar or dialog, and a progress or loading
          indicator while content loads.
        </.page_header>

        <.section
          title="Dialog"
          api={[{PhoenixPaper.Dialog, :pp_dialog}]}
          description={
            ~S|MD3's dialog: 28dp corners on surface-container-high, a headline, supporting text and actions, with an optional hero icon. Always in the DOM and shown/hidden with the PhoenixPaper.Dialog.show/1 and hide/1 JS commands (like a generated core_components modal); focus is trapped, and Escape or a scrim click dismisses. variant="fullscreen" takes the whole screen; "responsive" is fullscreen on phones only.|
          }
          code={dialog_code()}
        >
          <.demo_group label="basic with a hero icon, and fullscreen">
            <.pp_button
              id="open-dialog"
              variant="tonal"
              phx-click={PhoenixPaper.Dialog.show("confirm-delete-demo")}
            >
              Delete
            </.pp_button>
            <.pp_dialog id="confirm-delete-demo" icon="hero-trash">
              <:title>Delete this item?</:title>
              This can't be undone.
              <:actions>
                <.pp_button variant="text" phx-click={PhoenixPaper.Dialog.hide("confirm-delete-demo")}>
                  Cancel
                </.pp_button>
                <.pp_button variant="text" phx-click={PhoenixPaper.Dialog.hide("confirm-delete-demo")}>
                  Delete
                </.pp_button>
              </:actions>
            </.pp_dialog>

            <.pp_button
              id="open-fullscreen"
              variant="outlined"
              phx-click={PhoenixPaper.Dialog.show("fullscreen-demo")}
            >
              New event
            </.pp_button>
            <.pp_dialog id="fullscreen-demo" variant="fullscreen">
              <:title>New event</:title>
              <div class="flex flex-col gap-4 max-w-md">
                <.pp_text_field name="event_title" label="Title" />
                <.pp_text_field name="event_place" label="Location" />
              </div>
              <:actions>
                <.pp_button phx-click={PhoenixPaper.Dialog.hide("fullscreen-demo")}>Save</.pp_button>
              </:actions>
            </.pp_dialog>
          </.demo_group>
        </.section>

        <.section
          title="Progress"
          api={[{PhoenixPaper.Progress, :pp_progress}]}
          description="MD3 progress indicators, linear or circular (an SVG arc), determinate with a value or indeterminate without one. M3 Expressive adds a wavy track, a thick (8dp) variant, and the stop indicator at the track's end."
          code={progress_code()}
        >
          <.demo_group label="Linear: determinate, indeterminate, wavy, thick" direction="column">
            <.pp_progress value={72} class="max-w-sm" label="Determinate" />
            <.pp_progress class="max-w-sm" label="Indeterminate" />
            <.pp_progress value={60} wavy class="max-w-sm" label="Wavy" />
            <.pp_progress value={45} thickness={8} class="max-w-sm" label="Thick" />
          </.demo_group>
          <.demo_group label="Circular">
            <.pp_progress
              :for={color <- ~w(primary secondary tertiary error)}
              variant="circular"
              value={65}
              color={color}
              label={color}
            />
            <.pp_progress variant="circular" label="Indeterminate" />
            <.pp_progress variant="circular" value={70} wavy size={48} label="Wavy" />
          </.demo_group>
        </.section>

        <.section
          title="Loading Indicator"
          api={[{PhoenixPaper.LoadingIndicator, :pp_loading_indicator}]}
          description="M3 Expressive's loading indicator: a shape that morphs through MD3's shape library as it spins, for waits too short for a progress bar (pull to refresh, a card loading). contained sets it on a primary-container circle for indicators over content. Animated in CSS; Safari shows a rotating soft burst unless the JS hook is on."
          code={loading_indicator_code()}
        >
          <.demo_group label="Plain, contained, colors">
            <.pp_loading_indicator />
            <.pp_loading_indicator contained />
            <.pp_loading_indicator color="tertiary" size={36} />
            <.pp_loading_indicator color="secondary" contained size={64} />
          </.demo_group>
        </.section>

        <.section
          title="Snackbar"
          api={[{PhoenixPaper.Snackbar, :pp_snackbar}]}
          description="A brief message on MD3's inverse-surface, always that color, with an optional :action and a close button (on_close). two_line fits a longer message. Dismissal is yours (a Process.send_after/3 clearing the open assign, like generated flash messages), or client-side with on_close + auto_hide_duration. It's fixed at the bottom of the viewport (centered on phones, bottom-start from sm) and enters with MD3's fade-and-expand; positioned={false} drops the fixed placement so you can place it yourself, as these demos do. For Phoenix flash messages, use Flash below."
          code={snackbar_code()}
        >
          <.demo_group label="Try it" direction="column">
            <div class="flex flex-col items-start gap-3">
              <.pp_snackbar positioned={false}>
                Changes saved
                <:action>
                  <.pp_button variant="text" phx-click="dismiss">Undo</.pp_button>
                </:action>
              </.pp_snackbar>
              <.pp_snackbar positioned={false} on_close={JS.push("dismiss")}>
                Link copied
              </.pp_snackbar>
              <.pp_snackbar positioned={false} two_line on_close={JS.push("dismiss")}>
                Your draft was saved on this device. Sign in to sync it everywhere.
                <:action>
                  <.pp_button variant="text" phx-click="dismiss">Sign in</.pp_button>
                </:action>
              </.pp_snackbar>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Flash"
          api={[{PhoenixPaper.Flash, :pp_flash_group}, {PhoenixPaper.Flash, :pp_flash}]}
          description="Phoenix's @flash rendered as stacked snackbars: the Material counterpart of a generated core_components' flash_group. Drop pp_flash_group once in the root layout. Dismiss is wired to LiveView's built-in lv:clear-flash (no handler in your LiveView); auto_hide_duration is opt-in. Monochrome and text-only by spec: every kind looks the same, an inverse-surface snackbar."
          code={flash_code()}
        >
          <.demo_group label="Trigger a real flash">
            <.pp_button phx-click="flash_info">
              <:start_icon><.pp_icon name="hero-information-circle" /></:start_icon>
              Trigger info flash
            </.pp_button>
            <.pp_button color="error" phx-click="flash_error">
              <:start_icon><.pp_icon name="hero-exclamation-circle" /></:start_icon>
              Trigger error flash
            </.pp_button>
          </.demo_group>
          <.pp_typography variant="body-medium" color="on-surface-variant" class="-mt-4 mb-8">
            This whole page renders a pp_flash_group bound to @flash instead of the default
            flash_group. The buttons above call put_flash/3; a real chip slides in at the
            top-right, auto-hides after 6s, or dismiss it with the ✕ (LiveView's built-in
            lv:clear-flash, no handler). It also sets connection_notices: stop the server and
            a "We can't find the internet" chip appears until the socket reconnects.
          </.pp_typography>

          <.demo_group label="Appearance (inline, static)" direction="column">
            <.pp_typography variant="body-medium" color="on-surface-variant">
              The same chips shown inline (each is a pp_snackbar positioned={false}) rather than fixed
              to the viewport corner:
            </.pp_typography>
            <div class="flex flex-col gap-2">
              <.pp_flash flash={%{"info" => "Workbook saved."}} kind={:info} />
              <.pp_flash flash={%{"error" => "Could not reach the guest agent."}} kind={:error} />
            </div>
          </.demo_group>
        </.section>
      </div>
    </Layouts.app>
    """
  end

  defp dialog_code do
    """
    <.pp_button phx-click={PhoenixPaper.Dialog.show("confirm-delete")}>Delete</.pp_button>

    <.pp_dialog id="confirm-delete" icon="hero-trash">
      <:title>Delete this item?</:title>
      This can't be undone.
      <:actions>
        <.pp_button variant="text" phx-click={PhoenixPaper.Dialog.hide("confirm-delete")}>Cancel</.pp_button>
        <.pp_button variant="text" phx-click={JS.push("delete") |> PhoenixPaper.Dialog.hide("confirm-delete")}>
          Delete
        </.pp_button>
      </:actions>
    </.pp_dialog>

    <%!-- Full screen on every screen, or only on phones --%>
    <.pp_dialog id="new-event" variant="responsive">...</.pp_dialog>\
    """
  end

  defp progress_code do
    """
    <.pp_progress value={72} label="Uploading" />
    <.pp_progress label="Loading" />
    <.pp_progress value={60} wavy />
    <.pp_progress value={45} thickness={8} />

    <.pp_progress variant="circular" value={65} color="tertiary" />
    <.pp_progress variant="circular" />\
    """
  end

  defp snackbar_code do
    """
    <.pp_snackbar open={@message != nil}>
      {@message}
      <:action>
        <.pp_button variant="text" phx-click="undo">Undo</.pp_button>
      </:action>
    </.pp_snackbar>

    <%!-- on_close renders a trailing close button; pair it with auto_hide_duration
          for a hook-free client-side auto-dismiss --%>
    <.pp_snackbar on_close={JS.push("dismiss")} auto_hide_duration={5000}>
      Link copied
    </.pp_snackbar>

    <%!-- two_line: a longer message above its action --%>
    <.pp_snackbar two_line>
      Your draft was saved on this device. Sign in to sync it everywhere.
      <:action><.pp_button variant="text" phx-click="sign_in">Sign in</.pp_button></:action>
    </.pp_snackbar>\
    """
  end

  defp flash_code do
    String.trim_trailing(~S'''
    <%!-- Drop pp_flash_group once, where a generated <.flash_group> goes.
          auto_hide_duration is opt-in; dismissal needs no handler (lv:clear-flash).
          connection_notices adds the generated flash_group's connection-lost chips. --%>
    <.pp_flash_group
      flash={@flash}
      auto_hide_duration={6000}
      connection_notices
      client_error_title={gettext("We can't find the internet")}
    />

    # In the LiveView: an ordinary put_flash/3 shows a chip
    def handle_event("flash_info", _params, socket),
      do: {:noreply, put_flash(socket, :info, "Workbook saved.")}

    def handle_event("flash_error", _params, socket),
      do: {:noreply, put_flash(socket, :error, "Could not reach the guest agent.")}
    ''')
  end

  defp loading_indicator_code do
    """
    <.pp_loading_indicator label="Loading messages" />
    <.pp_loading_indicator contained />
    <.pp_loading_indicator color="tertiary" size={36} />\
    """
  end
end
