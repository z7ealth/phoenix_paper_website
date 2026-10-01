defmodule PhoenixPaperWebsiteWeb.Release030Test do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias PhoenixPaperWebsiteWeb.{DocsComponents, Nav}

  test "New/Updated chips mark the release's components, on sections and in the sidebar",
       %{conn: conn} do
    for item <- Nav.component_items() do
      {:ok, view, _html} = live(conn, item.path)

      for child <- item.children do
        anchor = DocsComponents.slug(child.label)
        sidebar = ~s|#nav-#{item.id}-content a[href="#{child.path}"]|

        case child.status do
          nil ->
            refute has_element?(view, "section##{anchor} [data-pp-status]")
            refute has_element?(view, "#{sidebar} [data-pp-status]")

          status ->
            assert has_element?(view, "section##{anchor} [data-pp-status=#{status}]")
            assert has_element?(view, "#{sidebar} [data-pp-status=#{status}]")
        end
      end
    end
  end

  test "Pagination demo pages via on_change", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/navigation")

    assert has_element?(view, ~s|#pagination-demo [aria-current="page"]|, "5")
    view |> element(~s|#pagination-demo [aria-label="Go to page 6"]|) |> render_click()
    assert has_element?(view, ~s|#pagination-demo [aria-current="page"]|, "6")
  end

  test "Table Pagination demo pages a 47-row table and resets on rows-per-page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/data-display")

    assert has_element?(view, "#tp-table tbody tr", "user1@example.com")
    view |> element(~s|#tp-table [aria-label="Go to next page"]|) |> render_click()
    assert has_element?(view, "#tp-table tbody tr", "user6@example.com")
    refute has_element?(view, "#tp-table tbody tr", "user1@example.com")

    # pp_table_pagination's id names its rows-per-page menu (not the root)
    view
    |> element(~s|#tp-demo-rows-per-page-panel [phx-value-rows_per_page="10"]|)
    |> render_click()

    assert has_element?(view, "#tp-table tbody tr", "user10@example.com")
    assert has_element?(view, "#tp-table tbody tr", "user1@example.com")
  end

  test "Form demo submits and Power Select demos render", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")

    view
    |> form("#profile-form", profile: %{name: "Ada", email: "ada@example.com"})
    |> render_submit()

    assert render(view) =~ "Hi, Ada!"
    assert has_element?(view, "#country-power-select")
    assert has_element?(view, "#languages-power-select")
    assert has_element?(view, "#languages-selected", ~s(["elixir"]))
  end
end
