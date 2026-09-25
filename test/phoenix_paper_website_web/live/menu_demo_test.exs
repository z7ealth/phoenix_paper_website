defmodule PhoenixPaperWebsiteWeb.MenuDemoTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # pp_menu renders :trigger inside its own trigger button, so a button in
  # :trigger would be nested -- browsers split that, leaving the visible
  # button with no toggle and the menu impossible to open.
  test "menu triggers are single buttons with the toggle attached", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/navigation")

    for id <- ~w(demo-menu demo-menu-icon) do
      assert has_element?(view, "button##{id}-trigger[phx-click][aria-controls=#{id}-panel]")
      refute has_element?(view, "##{id}-trigger button")
      refute has_element?(view, "##{id}-trigger a")
    end
  end
end
