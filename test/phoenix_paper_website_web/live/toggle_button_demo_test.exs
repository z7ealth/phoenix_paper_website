defmodule PhoenixPaperWebsiteWeb.ToggleButtonDemoTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "standalone toggle buttons flip independently", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/actions")

    assert has_element?(view, ~s|#toggle-format-bold[aria-pressed="true"]|)
    assert has_element?(view, ~s|#toggle-format-italic[aria-pressed="false"]|)

    view |> element("#toggle-format-italic") |> render_click()
    assert has_element?(view, ~s|#toggle-format-italic[aria-pressed="true"]|)
    assert has_element?(view, ~s|#toggle-format-bold[aria-pressed="true"]|)

    view |> element("#toggle-format-bold") |> render_click()
    assert has_element?(view, ~s|#toggle-format-bold[aria-pressed="false"]|)
  end

  test "grouped toggle buttons are exclusive", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/actions")

    assert has_element?(view, ~s|#toggle-view-columns[aria-pressed="true"]|)

    view |> element("#toggle-view-grid") |> render_click()
    assert has_element?(view, ~s|#toggle-view-grid[aria-pressed="true"]|)
    assert has_element?(view, ~s|#toggle-view-columns[aria-pressed="false"]|)
  end

  test "client-side toggle buttons render with their initial state and no server event",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/actions")

    assert has_element?(view, ~s|#client-toggle-bold[aria-pressed="true"]|)
    assert has_element?(view, ~s|#client-toggle-italic[aria-pressed="false"]|)
    assert has_element?(view, ~s|#client-toggle-view-columns[aria-pressed="true"]|)
    assert has_element?(view, ~s|#client-toggle-view-grid[aria-pressed="false"]|)
  end
end
