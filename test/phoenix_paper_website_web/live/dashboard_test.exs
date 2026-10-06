defmodule PhoenixPaperWebsiteWeb.DashboardTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the dashboard, linked from the sidebar", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dashboard")

    assert has_element?(view, ~s|a[href="/dashboard"][aria-current="page"]|)
    assert has_element?(view, "#kpis #kpi-revenue")
    assert has_element?(view, "#orders tbody tr[id^=order-]")
    assert has_element?(view, "#new-order")
    assert has_element?(view, "#new-order-dialog form#new-order-form")
  end

  test "status chips filter the orders and Clear resets them", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dashboard")

    view |> element("#filter-refunded") |> render_click()
    assert has_element?(view, "#orders tbody tr[id^=order-]", "Refunded")
    refute has_element?(view, "#orders tbody tr[id^=order-]", "Paid")

    view |> element("#clear-filters") |> render_click()
    assert has_element?(view, "#orders tbody tr[id^=order-]", "Paid")
  end

  test "pagination and the period switch work", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dashboard")

    first = view |> element("#orders tbody tr:first-child") |> render()
    view |> element(~s|#orders-pagination button[phx-value-page="2"]|) |> render_click()
    refute view |> element("#orders tbody tr:first-child") |> render() == first

    view |> element("#period-month") |> render_click()
    assert has_element?(view, "#kpis", "vs last month")
  end

  test "creating an order puts it on top of the table", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dashboard")

    view
    |> form("#new-order-form", order: %{customer: "Ada Byron", product: "Ink set", amount: "999"})
    |> render_submit()

    assert has_element?(view, "#orders tbody tr:first-child", "Ada Byron")
    assert render(view) =~ "Order #1025 created for Ada Byron."
  end

  test "the layout switch moves to full width and back, kept in the URL", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dashboard")
    refute has_element?(view, "#dashboard-panes")

    view |> element("#layout-full") |> render_click()
    assert_patch(view, "/dashboard?layout=full")
    assert has_element?(view, ~s|#dashboard-panes[data-pp-component="supporting-pane"] #orders|)
    assert has_element?(view, ~s|#dashboard-panes [data-pp-pane="supporting"] #goals|)

    view |> element("#layout-contained") |> render_click()
    assert_patch(view, "/dashboard")
    refute has_element?(view, "#dashboard-panes")
  end

  test "?layout=full opens straight in the full-width layout", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dashboard?layout=full")
    assert has_element?(view, "#dashboard-panes #orders")
  end

  test "Show code reveals the page's own LiveView source", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/dashboard")

    assert has_element?(view, "#dashboard-source details#dashboard-code > summary", "Show code")

    assert has_element?(
             view,
             "#dashboard-code pre code",
             "defmodule PhoenixPaperWebsiteWeb.DashboardLive"
           )
  end
end
