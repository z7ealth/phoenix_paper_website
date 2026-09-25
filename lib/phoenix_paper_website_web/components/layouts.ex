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
  `PhoenixPaper.Drawer` sidebar (full height, stacked above the app bar,
  with the logo in its header) plus a sticky `PhoenixPaper.AppBar` for the
  content column (mobile drawer toggle on the left, a GitHub link and
  `PhoenixPaperWebsiteWeb.ThemePicker` on the right). All real PhoenixPaper
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

  attr :flash_group, :boolean,
    default: true,
    doc:
      "render the flash group -- the Feedback page opts out (flash_group={false}) to render its own pp_flash_group, with auto_hide_duration, as that section's live demo"

  slot :inner_block, required: true

  def app(assigns) do
    assigns = assign(assigns, :nav_sections, Nav.sections())

    ~H"""
    <div class="min-h-screen bg-pp-surface text-pp-on-surface">
      <div class="flex w-full">
        <.pp_drawer id="site-drawer">
          <:header>
            <.brand />
          </:header>
          <.pp_list dense>
            <%= for section <- @nav_sections do %>
              <.pp_list_subheader>{section.title}</.pp_list_subheader>
              <%= for item <- section.items do %>
                <%= cond do %>
                  <% item[:href] -> %>
                    <%!-- External (e.g. the Changelog on GitHub): a plain href.
                          pp_list_item doesn't accept target/rel, so it opens in
                          the same tab; the trailing icon marks it as external. --%>
                    <.pp_list_item id={"nav-#{item.id}"} href={item.href}>
                      <:leading><.pp_icon name={item.icon} /></:leading>
                      {item.label}
                      <:trailing><.pp_icon name="hero-arrow-top-right-on-square-mini" /></:trailing>
                    </.pp_list_item>
                  <% item[:children] in [nil, []] -> %>
                    <.pp_list_item navigate={item.path} active={@current_page == item.id}>
                      <:leading><.pp_icon name={item.icon} /></:leading>
                      {item.label}
                    </.pp_list_item>
                  <% true -> %>
                    <%!-- A component category: a collapsible group, open on its own page,
                        with one #anchor link per section on that page (see
                        Nav.component_items/0). Same-page clicks are plain anchor jumps;
                        cross-page ones are LiveView navigations that scroll to the hash
                        once the new page is mounted. --%>
                    <.pp_list_group
                      id={"nav-#{item.id}"}
                      default_open={@current_page == item.id}
                    >
                      <:leading><.pp_icon name={item.icon} /></:leading>
                      <:label>{item.label}</:label>
                      <.pp_list_item :for={child <- item.children} navigate={child.path}>
                        {child.label}
                      </.pp_list_item>
                    </.pp_list_group>
                <% end %>
              <% end %>
            <% end %>
          </.pp_list>
        </.pp_drawer>

        <div class="min-w-0 flex-1">
          <.pp_app_bar color="surface" position="sticky" elevation={0}>
            <:leading>
              <.pp_drawer_toggle for="site-drawer" />
            </:leading>
            <:actions>
              <.github_link />
              <.theme_picker />
            </:actions>
          </.pp_app_bar>

          <main class="py-10">
            {render_slot(@inner_block)}
          </main>

          <.footer />
        </div>
      </div>
    </div>

    <.flash_group :if={@flash_group} flash={@flash} />
    """
  end

  @doc """
  The bare shell for the home page only: just the floating logo, a GitHub
  link, and `PhoenixPaperWebsiteWeb.ThemePicker`, no navbar and no drawer --
  the landing page doesn't need in-app navigation chrome around it.

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
      <div class="fixed top-4 left-4 z-30">
        <.brand />
      </div>

      <div class="fixed top-4 right-4 z-30 flex items-center gap-1">
        <.github_link />
        <.theme_picker />
      </div>

      {render_slot(@inner_block)}

      <.footer />
    </div>

    <.flash_group flash={@flash} />
    """
  end

  @doc """
  The app's flash messages: `PhoenixPaper.Flash`'s `pp_flash_group` for the
  real `@flash`, plus its `connection_notices` (the client/server
  connection-lost chips), with the texts run through Gettext.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :auto_hide_duration, :integer, default: nil, doc: "see pp_flash_group"

  def flash_group(assigns) do
    ~H"""
    <.pp_flash_group
      id="flash-group"
      flash={@flash}
      connection_notices
      client_error_title={gettext("We can't find the internet")}
      server_error_title={gettext("Something went wrong!")}
      reconnecting_text={gettext("Attempting to reconnect")}
      auto_hide_duration={@auto_hide_duration}
    />
    """
  end

  # The home link + wordmark + installed-version caption, shared by the
  # sidebar header (app/1) and the landing page's floating corner
  # (landing/1). The version sits *under* the wordmark rather than beside it
  # so it never gets clipped by the drawer's width.
  defp brand(assigns) do
    ~H"""
    <.link navigate={~p"/"} class="flex flex-col items-start gap-0.5">
      <.logo_lockup size="lg" />
      <span class="pl-[2.625rem] text-[0.65rem] font-semibold uppercase tracking-wider text-pp-on-surface/45">
        v{phoenix_paper_version()}
      </span>
    </.link>
    """
  end

  # The installed phoenix_paper version, read from the loaded dep so it
  # tracks mix.exs without a second place to bump.
  defp phoenix_paper_version do
    :phoenix_paper |> Application.spec(:vsn) |> to_string()
  end

  # A centered copyright line, shown at the bottom of every page. The
  # GitHub link used to live here too -- it's now up in the app bar/floating
  # corner instead (see app/1, landing/1), alongside the theme picker.
  defp footer(assigns) do
    assigns = assign(assigns, :year, Date.utc_today().year)

    ~H"""
    <footer class="flex items-center justify-center gap-1.5 py-8 text-xs text-pp-on-surface/50">
      <span aria-hidden="true">&copy;</span>
      <span>z7ealth {@year}</span>
    </footer>
    """
  end

  # A link to the phoenix_paper source repo: a pp_button icon button in link
  # mode, next to PhoenixPaperWebsiteWeb.ThemePicker in the app bar/floating
  # corner.
  defp github_link(assigns) do
    ~H"""
    <.pp_button
      id="github-link"
      variant="icon"
      color="inherit"
      href="https://github.com/z7ealth/phoenix_paper"
      target="_blank"
      rel="noopener noreferrer"
      aria-label="PhoenixPaper on GitHub"
    >
      <.github_mark class="size-6" />
    </.pp_button>
    """
  end

  attr :class, :any, default: nil

  # GitHub's mark -- inlined so currentColor picks up the surrounding link's
  # text color/hover state, same reasoning as DocsComponents.logo_mark/1.
  defp github_mark(assigns) do
    ~H"""
    <svg viewBox="0 0 24 24" fill="currentColor" role="img" aria-hidden="true" class={@class}>
      <path d="M12 .5C5.73.5.5 5.73.5 12c0 5.09 3.29 9.4 7.86 10.93.57.1.79-.25.79-.55 0-.27-.01-1.15-.02-2.09-3.2.7-3.88-1.35-3.88-1.35-.52-1.33-1.28-1.68-1.28-1.68-1.04-.71.08-.7.08-.7 1.16.08 1.77 1.19 1.77 1.19 1.03 1.76 2.7 1.25 3.36.96.1-.75.4-1.25.73-1.54-2.56-.29-5.25-1.28-5.25-5.7 0-1.26.45-2.29 1.19-3.09-.12-.29-.52-1.47.11-3.06 0 0 .97-.31 3.18 1.18a11.02 11.02 0 0 1 5.79 0c2.2-1.49 3.17-1.18 3.17-1.18.64 1.59.24 2.77.12 3.06.74.8 1.19 1.83 1.19 3.09 0 4.43-2.7 5.4-5.27 5.69.41.36.78 1.06.78 2.15 0 1.56-.01 2.81-.01 3.19 0 .31.21.66.79.55A11.5 11.5 0 0 0 23.5 12C23.5 5.73 18.27.5 12 .5Z" />
    </svg>
    """
  end
end
