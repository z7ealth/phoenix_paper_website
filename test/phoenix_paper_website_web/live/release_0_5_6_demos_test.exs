defmodule PhoenixPaperWebsiteWeb.Release056DemosTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # three_line items are the 88dp, top-aligned rows.
  @three_line ~s|[data-pp-component="list-item"][class~="min-h-[88px]"]|

  test "List demo shows three-line items", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/navigation")

    assert has_element?(view, "#list-three-line-demo #{@three_line}", "Automatic backups")
  end

  test "Theming's long-text lists use three-line items", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/theming")

    assert has_element?(view, "#theming-mode-rules #{@three_line}")
    assert has_element?(view, "#theming-checklist #{@three_line}")
  end
end
