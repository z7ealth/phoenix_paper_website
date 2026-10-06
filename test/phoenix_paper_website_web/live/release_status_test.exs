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

  # 0.5.0 is MD3-only: none of the components it removed may come back
  # into the catalog.
  @removed_in_0_5 ~w(Box Container Stack Grid Paper Table Pagination Breadcrumbs Accordion
                     Collapse Alert Skeleton Avatar Backdrop Rating Autocomplete Form) ++
                    [
                      "Grid & GridItem",
                      "Image List",
                      "Table Pagination",
                      "Number Field",
                      "Transfer List",
                      "Power Select"
                    ]

  test "the catalog lists no component removed in 0.5.0" do
    titles = Enum.flat_map(Nav.component_items(), & &1.components)

    for title <- @removed_in_0_5 do
      refute title in titles, "#{title} is still listed"
    end

    refute Enum.any?(Nav.component_items(), &(&1.id == :layout))
  end

  test "Show code toggles are native details/summary disclosures", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/data-display")

    assert has_element?(view, "details#badge-code > summary", "Show code")
    assert has_element?(view, "details#badge-code pre code")
  end
end
