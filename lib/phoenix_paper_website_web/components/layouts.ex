defmodule PhoenixPaperWebsiteWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use PhoenixPaperWebsiteWeb, :html

  alias PhoenixPaperWebsiteWeb.Nav

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  The shell for every page except the home page: a persistent
  `PhoenixPaper.Drawer` sidebar (no navbar -- just a floating theme toggle
  and, on mobile, a floating drawer toggle). Both are real PhoenixPaper
  components, and this is the showcase's own live demo of them.

  ## Examples

      <Layouts.app flash={@flash} current_page={:getting_started}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://phoenix.hexdocs.pm/scopes.html)"

  attr :current_page, :atom,
    default: nil,
    doc: "which Nav item (see PhoenixPaperWebsiteWeb.Nav) is active, for sidebar highlighting"

  slot :inner_block, required: true

  def app(assigns) do
    assigns = assign(assigns, :nav_sections, Nav.sections())

    ~H"""
    <div class="min-h-screen bg-pp-surface text-pp-on-surface">
      <div class="fixed top-4 right-4 z-30">
        <.pp_theme_toggle label={nil} />
      </div>

      <div class="flex w-full">
        <.pp_drawer id="site-drawer" class="lg:sticky lg:top-0 lg:h-screen">
          <:header>
            <.link navigate={~p"/"} class="flex items-center gap-2 font-semibold tracking-tight">
              <.pp_icon name="hero-cube" class="text-pp-primary" />
              <span>PhoenixPaper</span>
            </.link>
          </:header>
          <.pp_list class="px-2 py-4">
            <%= for section <- @nav_sections do %>
              <.pp_list_subheader>{section.title}</.pp_list_subheader>
              <%= for item <- section.items do %>
                <.pp_list_item navigate={item.path} active={@current_page == item.id}>
                  <:leading><.pp_icon name={item.icon} /></:leading>
                  {item.label}
                </.pp_list_item>
              <% end %>
            <% end %>
          </.pp_list>
        </.pp_drawer>

        <div class="min-w-0 flex-1">
          <.pp_drawer_toggle
            for="site-drawer"
            class="fixed top-4 left-4 z-40 bg-pp-surface pp-elevation-2"
          />

          <main class="pt-20 pb-10 sm:pt-24 lg:pt-10">
            {render_slot(@inner_block)}
          </main>
        </div>
      </div>
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  The bare shell for the home page only: just the floating theme toggle, no
  navbar and no drawer -- the landing page doesn't need in-app navigation
  chrome around it.

  ## Examples

      <Layouts.landing flash={@flash}>
        <h1>Content</h1>
      </Layouts.landing>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  slot :inner_block, required: true

  def landing(assigns) do
    ~H"""
    <div class="min-h-screen bg-pp-surface text-pp-on-surface">
      <div class="fixed top-4 right-4 z-30">
        <.pp_theme_toggle label={nil} />
      </div>

      {render_slot(@inner_block)}
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={
          show(".phx-client-error #client-error")
          |> JS.remove_attribute("hidden", to: ".phx-client-error #client-error")
        }
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.pp_icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={
          show(".phx-server-error #server-error")
          |> JS.remove_attribute("hidden", to: ".phx-server-error #server-error")
        }
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.pp_icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end
end
