defmodule PhoenixPaperWebsiteWeb.ReleaseStatusTest do
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

  # 0.5.0 is MD3-only: none of the components it removed (and 0.5.2 didn't
  # bring back) may come back into the catalog.
  @removed_in_0_5 ~w(Box Container Stack Grid Paper Accordion Collapse Alert Skeleton
                     Backdrop Rating Form) ++
                    ["Grid & GridItem", "Image List", "Transfer List", "Power Select"]

  test "the catalog lists no component removed in 0.5.0" do
    titles = Enum.flat_map(Nav.component_items(), & &1.components)

    for title <- @removed_in_0_5 do
      refute title in titles, "#{title} is still listed"
    end

    refute Enum.any?(Nav.component_items(), &(&1.id == :layout))
  end

  test "Pagination demo pages via on_change", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/navigation")

    assert has_element?(view, ~s|#pagination-demo [aria-current="page"]|, "5")
    view |> element(~s|#pagination-demo [aria-label="Go to page 6"]|) |> render_click()
    assert has_element?(view, ~s|#pagination-demo [aria-current="page"]|, "6")
  end

  test "Table Pagination demo pages 47 rows and resets on rows per page", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/data-display")

    assert has_element?(view, "#tp-table tbody tr", "user1@example.com")
    view |> element(~s|#tp-pagination button[phx-value-page="2"]|) |> render_click()
    assert has_element?(view, "#tp-table tbody tr", "user6@example.com")
    refute has_element?(view, "#tp-table tbody tr", "user1@example.com")

    view |> element(~s|#tp-pagination [phx-value-rows_per_page="10"]|) |> render_click()
    assert has_element?(view, "#tp-table tbody tr", "user10@example.com")
    assert has_element?(view, "#tp-table tbody tr", "user1@example.com")
  end

  test "Table demo's sortable header flips the row order", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/data-display")

    assert has_element?(view, "#table-demo tbody tr:first-child", "Cupcake")
    view |> element("#table-demo thead [phx-click=sort]") |> render_click()
    assert has_element?(view, "#table-demo tbody tr:first-child", "Ice cream sandwich")
  end

  test "Autocomplete demo renders as a combobox", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")
    assert has_element?(view, ~s|#country-autocomplete [role="combobox"]|)
  end

  test "Show code toggles are native details/summary disclosures", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/data-display")

    assert has_element?(view, "details#badge-code > summary", "Show code")
    assert has_element?(view, "details#badge-code pre code")
  end
end
