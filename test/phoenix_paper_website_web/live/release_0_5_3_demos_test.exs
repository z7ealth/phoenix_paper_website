defmodule PhoenixPaperWebsiteWeb.Release053DemosTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "Card demos show equal-height cards and a list in a card", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/data-display")

    assert has_element?(view, "#card-fill-demo .h-full .flex.flex-col .mt-auto", "Open")
    assert has_element?(view, ~s|#card-list-demo [data-pp-component="list-item"]|, "Laptop")
  end

  test "Theming documents gen.theme --palette", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/theming")

    assert has_element?(view, "pre code", "--palette catppuccin.json")
  end
end
