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
  The shell for every page except the home page: a responsive
  `PhoenixPaper.NavigationRail` (starting expanded, with the logo in its
  header; a modal on small screens) plus a sticky `PhoenixPaper.TopAppBar`
  for the content column (the rail's modal toggle on the left, GitHub, Hex
  and `PhoenixPaperWebsiteWeb.ThemePicker` on the right). All real PhoenixPaper
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
        <%!-- MD3 navigation rail, responsive: expanded from md up (with the
              section headings and the current category's component links), a modal
              below md, opened from the top app bar. --%>
        <%!-- menu_button={false}: no expand/collapse button on desktop, so the
              rail stays expanded like a docs sidebar; on phones the top app
              bar's modal_only toggle opens it and the scrim closes it. --%>
        <.pp_navigation_rail id="site-rail" default_expanded menu_button={false}>
          <:header><.brand rail /></:header>
          <%= for section <- @nav_sections do %>
            <.pp_typography
              variant="title-small"
              color="on-surface-variant"
              class="px-4 pt-4 pb-2 pp-rail-collapsed:hidden"
            >
              {section.title}
            </.pp_typography>
            <%= for item <- section.items do %>
              <%= if item[:href] do %>
                <%!-- External (the Changelog on GitHub): opens in a new tab --%>
                <.pp_navigation_rail_item
                  id={"nav-#{item.id}"}
                  icon={item.icon}
                  label={item.label}
                  href={item.href}
                  target="_blank"
                  rel="noopener noreferrer"
                />
              <% else %>
                <.pp_navigation_rail_item
                  id={"nav-#{item.id}"}
                  icon={item.icon}
                  label={item.label}
                  navigate={item.path}
                  active={@current_page == item.id}
                />
                <%!-- The current category's components, one #anchor link per
                      section (see Nav.component_items/0), only while expanded --%>
                <.pp_list
                  :if={item[:children] not in [nil, []] and @current_page == item.id}
                  id={"nav-#{item.id}-content"}
                  class="ms-7 border-s border-pp-outline-variant pp-rail-collapsed:hidden"
                >
                  <.pp_list_item :for={child <- item.children} navigate={child.path}>
                    {child.label}
                    <:trailing :if={child.status}>
                      <.status_chip status={child.status} />
                    </:trailing>
                  </.pp_list_item>
                </.pp_list>
              <% end %>
            <% end %>
          <% end %>
        </.pp_navigation_rail>

        <div class="min-w-0 flex-1">
          <.pp_top_app_bar position="sticky">
            <:leading><.pp_navigation_rail_toggle for="site-rail" modal_only /></:leading>
            <:actions>
              <.github_link />
              <.hex_link />
              <.theme_picker />
            </:actions>
          </.pp_top_app_bar>

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
  link, and `PhoenixPaperWebsiteWeb.ThemePicker`, no app bar and no rail --
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
        <.hex_link />
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
  # so it never gets clipped by the rail's width.
  #
  # In the rail (`rail`), the wordmark and version hide while it's collapsed,
  # leaving just the mark.
  attr :rail, :boolean, default: false

  defp brand(assigns) do
    ~H"""
    <.link navigate={~p"/"} class="flex flex-col items-start gap-0.5">
      <span class="inline-flex items-center gap-2.5">
        <.logo_mark class="size-8 shrink-0 text-pp-primary" />
        <.pp_typography
          variant="headline-small"
          tag="span"
          emphasized
          color="on-surface"
          class={@rail && "pp-rail-collapsed:hidden"}
        >
          Phoenix<span class="text-pp-primary">Paper</span>
        </.pp_typography>
      </span>
      <.pp_typography
        variant="label-small"
        tag="span"
        color="on-surface-variant"
        class={["pl-[2.625rem] uppercase", @rail && "pp-rail-collapsed:hidden"]}
      >
        v{phoenix_paper_version()}
      </.pp_typography>
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
    <footer class="flex justify-center py-8">
      <.pp_typography variant="body-small" color="on-surface-variant">
        <span aria-hidden="true">&copy;</span> z7ealth {@year}
      </.pp_typography>
    </footer>
    """
  end

  # A link to the phoenix_paper source repo: a pp_button icon button in link
  # mode, next to PhoenixPaperWebsiteWeb.ThemePicker in the app bar/floating
  # corner.
  defp github_link(assigns) do
    ~H"""
    <.pp_icon_button
      id="github-link"
      label="PhoenixPaper on GitHub"
      href="https://github.com/z7ealth/phoenix_paper"
      target="_blank"
      rel="noopener noreferrer"
    >
      <.github_mark class="size-6" />
    </.pp_icon_button>
    """
  end

  # A link to the phoenix_paper package on hex.pm, next to github_link/1:
  # the same pp_button icon button in link mode.
  defp hex_link(assigns) do
    ~H"""
    <.pp_icon_button
      id="hex-link"
      label="PhoenixPaper on Hex"
      href="https://hex.pm/packages/phoenix_paper"
      target="_blank"
      rel="noopener noreferrer"
    >
      <.hex_mark class="size-6" />
    </.pp_icon_button>
    """
  end

  attr :class, :any, default: nil

  # Hex's hexagon mark -- inlined for the same currentColor reason as
  # github_mark/1 (heroicons has no Hex logo).
  defp hex_mark(assigns) do
    ~H"""
    <svg
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      stroke-width="2"
      stroke-linejoin="round"
      role="img"
      aria-hidden="true"
      class={@class}
    >
      <path d="M12 2.5 20.25 7.25v9.5L12 21.5l-8.25-4.75v-9.5Z" />
    </svg>
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
