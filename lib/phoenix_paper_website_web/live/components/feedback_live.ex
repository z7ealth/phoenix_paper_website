defmodule PhoenixPaperWebsiteWeb.Components.FeedbackLive do
  use PhoenixPaperWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Feedback", show_backdrop: false)}
  end

  def handle_event("toggle_backdrop", _params, socket) do
    {:noreply, update(socket, :show_backdrop, &(!&1))}
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
      <.pp_flash_group flash={@flash} auto_hide_duration={6000} />
      <.pp_container max_width="lg">
        <p class="mb-3 text-xs font-medium uppercase tracking-wide text-pp-primary">Components</p>
        <h1 class="mb-4 text-3xl font-semibold tracking-tight">Feedback</h1>
        <p class="mb-12 max-w-2xl text-pp-on-surface/70">
          PhoenixPaper.Alert, Backdrop, Dialog, Progress, Skeleton, Snackbar, Flash.
        </p>

        <.section
          title="Alert"
          description="A colored, icon-led message for status feedback. severity is a distinct color axis from every other component's color: success/info/warning/error status colors, not primary/secondary/tertiary/error brand colors."
          props={[
            {"severity",
             "success | info | warning | error (default: info), picks the color and icon"},
            {"variant", "standard (tinted) | outlined | filled (default: standard)"},
            {":title / :action", "optional slots: a bold line above the message, a trailing action"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={alert_code()}
        >
          <.demo_group label="Try it" class="flex-col items-stretch">
            <.pp_alert severity="success">Changes saved.</.pp_alert>
            <.pp_alert severity="info">A new update is available.</.pp_alert>
            <.pp_alert severity="warning" variant="outlined">Check your input.</.pp_alert>
            <.pp_alert severity="error" variant="filled">
              <:title>Error</:title>
              Could not save your changes.
              <:action>
                <.pp_button variant="text" class="!text-pp-on-error">Retry</.pp_button>
              </:action>
            </.pp_alert>
          </.demo_group>
        </.section>

        <.section
          title="Backdrop"
          description="A full-screen dimming overlay (most often behind a full-page loading spinner, or the piece Dialog composes for its own overlay). Stateless: open just toggles rendering it at all."
          props={[
            {"open", "boolean (default: true)"},
            {":inner_block", "optional content centered over the dim (e.g. a spinner)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={backdrop_code()}
        >
          <.demo_group label="Try it">
            <.pp_button phx-click="toggle_backdrop">Show backdrop</.pp_button>
            <.pp_backdrop open={@show_backdrop} phx-click="toggle_backdrop">
              <.pp_progress variant="circular" color="secondary" />
            </.pp_backdrop>
          </.demo_group>
        </.section>

        <.section
          title="Dialog"
          description="A modal, built the same way mix phx.new's generated core_components.ex builds its modal/1: always in the DOM, shown/hidden via Phoenix.LiveView.JS commands, not a server-tracked assign. PhoenixPaper.Dialog.show/1 and .hide/1 return JS commands to wire to whatever should open/close it."
          props={[
            {"id", "required: targeted by show/1 and hide/1"},
            {"on_cancel", "a JS command run (in addition to hiding) on backdrop click/Escape"},
            {":title / :actions", "optional slots"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={dialog_code()}
        >
          <.demo_group label="Try it">
            <.pp_button phx-click={PhoenixPaper.Dialog.show("confirm-delete-demo")}>
              Delete
            </.pp_button>
            <.pp_dialog id="confirm-delete-demo">
              <:title>Delete this item?</:title>
              This can't be undone.
              <:actions>
                <.pp_button variant="text" phx-click={PhoenixPaper.Dialog.hide("confirm-delete-demo")}>
                  Cancel
                </.pp_button>
                <.pp_button color="error" phx-click={PhoenixPaper.Dialog.hide("confirm-delete-demo")}>
                  Delete
                </.pp_button>
              </:actions>
            </.pp_dialog>
          </.demo_group>
        </.section>

        <.section
          title="Progress"
          description="linear or circular, combined into one component since they share the same value/color contract. value nil renders the indeterminate/animated form."
          props={[
            {"variant", "linear | circular (default: linear)"},
            {"value", "0-100, nil for indeterminate (default: nil)"},
            {"color", "primary | secondary | tertiary | error (default: primary)"},
            {"size", "circular only, diameter in pixels (default: 40)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={progress_code()}
        >
          <.demo_group label="Linear" class="flex-col items-stretch">
            <div class="max-w-sm">
              <p class="mb-2 text-xs text-pp-on-surface/60">Determinate (72%)</p>
              <.pp_progress value={72} />
            </div>
            <div class="max-w-sm">
              <p class="mb-2 text-xs text-pp-on-surface/60">Indeterminate</p>
              <.pp_progress />
            </div>
          </.demo_group>

          <.demo_group label="Circular">
            <div
              :for={color <- ~w(primary secondary tertiary error)}
              class="flex flex-col items-center gap-2"
            >
              <.pp_progress variant="circular" value={65} color={color} />
              <span class="text-xs text-pp-on-surface/60">{color}</span>
            </div>
            <div class="flex flex-col items-center gap-2">
              <.pp_progress variant="circular" />
              <span class="text-xs text-pp-on-surface/60">indeterminate</span>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Skeleton"
          description="A placeholder loading shape (text, circular, rectangular, or rounded) with a pulsing (default) or shimmering animation while real content loads."
          props={[
            {"variant", "text | circular | rectangular | rounded (default: text)"},
            {"width / height", "an integer (px) or a CSS length string, e.g. \"100%\""},
            {"animation", "pulse | wave | none (default: pulse)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={skeleton_code()}
        >
          <.demo_group label="Try it" class="flex-col items-stretch">
            <div class="flex max-w-sm flex-col gap-3">
              <div class="flex items-center gap-3">
                <.pp_skeleton variant="circular" width={40} height={40} />
                <div class="flex-1">
                  <.pp_skeleton />
                  <.pp_skeleton width="60%" />
                </div>
              </div>
              <.pp_skeleton variant="rectangular" height={80} />
              <.pp_skeleton variant="rounded" height={80} animation="wave" />
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Snackbar"
          description="A brief toast on an inverted-surface chip. Server-owned dismissal (a Process.send_after/3 clearing the open assign, the same mechanism generated flash messages use) is still the default, but on_close + auto_hide_duration add a hook-free client-side auto-dismiss for the no-round-trip case. No exit transition, only entrance. For Phoenix flash messages, use Flash below."
          props={[
            {"open", "boolean (default: true)"},
            {"anchor_origin",
             "bottom-left (default) | bottom-center | bottom-right | top-left | top-center | top-right"},
            {"transition", "grow (default) | fade | slide | none, mount-in animation only"},
            {"on_close", "a JS: renders a trailing ✕ button running it (MUI's close-IconButton)"},
            {"auto_hide_duration",
             "ms after which the snackbar triggers on_close itself (needs on_close; client-side)"},
            {"positioned",
             "boolean (default: true): keep the fixed viewport anchoring, or drop it to place the chip yourself"},
            {":action", "optional slot (e.g. an \"Undo\" button)"},
            {"elevation", "resting elevation, 0-24 (default: 6)"},
            {"paperize", "boolean (default: true)"}
          ]}
          code={snackbar_code()}
        >
          <.demo_group label="Try it" class="flex-col items-stretch">
            <div class="relative h-32 rounded-lg border border-pp-outline/20">
              <.pp_snackbar class="!absolute !inset-x-4 !bottom-4">
                Changes saved
                <:action>
                  <.pp_button variant="text" class="!text-pp-surface" phx-click="dismiss">Undo</.pp_button>
                </:action>
              </.pp_snackbar>
              <.pp_snackbar
                anchor_origin="top-right"
                transition="slide"
                on_close={JS.push("dismiss")}
                class="!absolute !top-4 !right-4"
              >
                Link copied
              </.pp_snackbar>
            </div>
          </.demo_group>
        </.section>

        <.section
          title="Flash"
          description="Phoenix's @flash rendered as stacked snackbars: the Material counterpart of a generated core_components' flash_group. Drop pp_flash_group once in the root layout. Dismiss is wired to LiveView's built-in lv:clear-flash (no handler in your LiveView); auto_hide_duration is opt-in. Monochrome by spec: the kind picks a leading icon, not a color."
          props={[
            {"flash", "the @flash map"},
            {"kinds", "flash keys to render, in stacking order (default: [:info, :error])"},
            {"anchor_origin",
             "corner/edge of the viewport the stack sits at (default: bottom-right)"},
            {"auto_hide_duration",
             "ms after which each chip clears itself via lv:clear-flash (opt-in)"},
            {"transition", "grow | fade | slide (default) | none"},
            {"paperize", "boolean (default: true)"}
          ]}
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
          <p class="-mt-4 mb-8 text-sm text-pp-on-surface/60">
            This whole page renders a pp_flash_group bound to @flash instead of the default
            flash_group. The buttons above call put_flash/3; a real chip slides in at the
            bottom-right, auto-hides after 6s, or dismiss it with the ✕ (LiveView's built-in
            lv:clear-flash, no handler).
          </p>

          <.demo_group label="Appearance (inline, static)" class="flex-col items-stretch">
            <p class="text-sm text-pp-on-surface/60">
              The same chips shown inline (each is a pp_snackbar positioned={false}) rather than fixed
              to the viewport corner:
            </p>
            <div class="flex flex-col gap-2">
              <.pp_flash flash={%{"info" => "Workbook saved."}} kind={:info} />
              <.pp_flash flash={%{"error" => "Could not reach the guest agent."}} kind={:error} />
            </div>
          </.demo_group>
        </.section>
      </.pp_container>
    </Layouts.app>
    """
  end

  defp alert_code do
    """
    <.pp_alert severity="success">Changes saved.</.pp_alert>
    <.pp_alert severity="info">A new update is available.</.pp_alert>
    <.pp_alert severity="warning" variant="outlined">Check your input.</.pp_alert>
    <.pp_alert severity="error" variant="filled">
      <:title>Error</:title>
      Could not save your changes.
      <:action><.pp_button variant="text">Retry</.pp_button></:action>
    </.pp_alert>\
    """
  end

  defp backdrop_code do
    """
    <.pp_button phx-click="toggle_backdrop">Show backdrop</.pp_button>

    <.pp_backdrop open={@show_backdrop} phx-click="toggle_backdrop">
      <.pp_progress variant="circular" color="secondary" />
    </.pp_backdrop>\
    """
  end

  defp dialog_code do
    """
    <.pp_button phx-click={PhoenixPaper.Dialog.show("confirm-delete")}>
      Delete
    </.pp_button>

    <.pp_dialog id="confirm-delete">
      <:title>Delete this item?</:title>
      This can't be undone.
      <:actions>
        <.pp_button variant="text" phx-click={PhoenixPaper.Dialog.hide("confirm-delete")}>
          Cancel
        </.pp_button>
        <.pp_button color="error" phx-click={PhoenixPaper.Dialog.hide("confirm-delete")}>
          Delete
        </.pp_button>
      </:actions>
    </.pp_dialog>\
    """
  end

  defp progress_code do
    """
    <.pp_progress value={72} />
    <.pp_progress />
    <.pp_progress variant="circular" value={72} />
    <.pp_progress variant="circular" />\
    """
  end

  defp skeleton_code do
    """
    <.pp_skeleton variant="circular" width={40} height={40} />
    <.pp_skeleton />
    <.pp_skeleton width="60%" />
    <.pp_skeleton variant="rectangular" height={100} />
    <.pp_skeleton variant="rounded" height={100} animation="wave" />\
    """
  end

  defp snackbar_code do
    """
    <.pp_snackbar>
      Changes saved
      <:action>
        <.pp_button variant="text" class="!text-pp-surface" phx-click="dismiss">Undo</.pp_button>
      </:action>
    </.pp_snackbar>

    <%!-- on_close renders a trailing ✕; pair with auto_hide_duration for a
          hook-free client-side auto-dismiss (a no-op CSS animation whose
          animationend clicks the ✕) --%>
    <.pp_snackbar anchor_origin="top-right" transition="slide" on_close={JS.push("dismiss")} auto_hide_duration={5000}>
      Link copied
    </.pp_snackbar>\
    """
  end

  defp flash_code do
    ~S'''
    # Drop pp_flash_group once, where a generated <.flash_group> goes.
    # auto_hide_duration is opt-in; dismissal needs no handler (lv:clear-flash).
    <.pp_flash_group flash={@flash} auto_hide_duration={6000} />

    # ...then anywhere, an ordinary put_flash/3 shows a chip:
    def handle_event("flash_info", _params, socket),
      do: {:noreply, put_flash(socket, :info, "Workbook saved.")}

    def handle_event("flash_error", _params, socket),
      do: {:noreply, put_flash(socket, :error, "Could not reach the guest agent.")}
    '''
  end
end
