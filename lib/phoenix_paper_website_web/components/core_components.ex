defmodule PhoenixPaperWebsiteWeb.CoreComponents do
  @moduledoc """
  Core UI components that don't belong to PhoenixPaper itself: flash
  notices and a page header.

  `flash/1` composes real PhoenixPaper components (`PhoenixPaper.Snackbar`
  for fixed-corner positioning, `PhoenixPaper.Alert` for the colored
  severity content, `PhoenixPaper.Icon` for the close glyph) rather than
  the generator's original raw daisyUI `toast`/`alert` markup -- this site
  is a PhoenixPaper showcase, so its own chrome is built from the same
  components it's demonstrating wherever one cleanly fits.

  The generator's other default components (`button/1`, `input/1`,
  `table/1`, `list/1`) were removed entirely: `pp_button`, `pp_input`/
  `pp_select`/`pp_checkbox`/etc., and `pp_table` are their direct
  PhoenixPaper equivalents, and this app never called the daisyUI versions.
  """
  use Phoenix.Component
  use Gettext, backend: PhoenixPaperWebsiteWeb.Gettext

  alias Phoenix.LiveView.JS

  import PhoenixPaper.Alert, only: [pp_alert: 1]
  import PhoenixPaper.Snackbar, only: [pp_snackbar: 1]
  import PhoenixPaper.Icon, only: [pp_icon: 1]

  @doc """
  Renders flash notices.

  ## Examples

      <.flash kind={:info} flash={@flash} />
      <.flash
        id="welcome-back"
        kind={:info}
        phx-mounted={show("#welcome-back") |> JS.remove_attribute("hidden")}
        hidden
      >
        Welcome Back!
      </.flash>
  """
  attr :id, :string, doc: "the optional id of flash container"
  attr :flash, :map, default: %{}, doc: "the map of flash messages to display"
  attr :title, :string, default: nil
  attr :kind, :atom, values: [:info, :error], doc: "used for styling and flash lookup"
  attr :rest, :global, doc: "the arbitrary HTML attributes to add to the flash container"

  slot :inner_block, doc: "the optional inner block that renders the flash message"

  def flash(assigns) do
    assigns = assign_new(assigns, :id, fn -> "flash-#{assigns.kind}" end)

    ~H"""
    <.pp_snackbar
      :if={msg = render_slot(@inner_block) || Phoenix.Flash.get(@flash, @kind)}
      id={@id}
      paperize={false}
      class="fixed top-4 right-4 z-50 w-80 sm:w-96"
      phx-click={JS.push("lv:clear-flash", value: %{key: @kind}) |> hide("##{@id}")}
      {@rest}
    >
      <.pp_alert severity={Atom.to_string(@kind)} variant="filled">
        <:title :if={@title}>{@title}</:title>
        {msg}
        <:action>
          <button
            type="button"
            class="group self-start cursor-pointer"
            aria-label={gettext("close")}
          >
            <.pp_icon name="hero-x-mark" class="size-5 opacity-70 group-hover:opacity-100" />
          </button>
        </:action>
      </.pp_alert>
    </.pp_snackbar>
    """
  end

  @doc """
  Renders a header with title.
  """
  slot :inner_block, required: true
  slot :subtitle
  slot :actions

  def header(assigns) do
    ~H"""
    <header class={[@actions != [] && "flex items-center justify-between gap-6", "pb-4"]}>
      <div>
        <h1 class="text-lg font-semibold leading-8">
          {render_slot(@inner_block)}
        </h1>
        <p :if={@subtitle != []} class="text-sm text-base-content/70">
          {render_slot(@subtitle)}
        </p>
      </div>
      <div class="flex-none">{render_slot(@actions)}</div>
    </header>
    """
  end

  ## JS Commands

  def show(js \\ %JS{}, selector) do
    JS.show(js,
      to: selector,
      time: 300,
      transition:
        {"transition-all ease-out duration-300",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
         "opacity-100 translate-y-0 sm:scale-100"}
    )
  end

  def hide(js \\ %JS{}, selector) do
    JS.hide(js,
      to: selector,
      time: 200,
      transition:
        {"transition-all ease-in duration-200", "opacity-100 translate-y-0 sm:scale-100",
         "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"}
    )
  end
end
