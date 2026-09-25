defmodule PhoenixPaperWebsiteWeb.NavTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias PhoenixPaperWebsiteWeb.Nav

  # Nav.component_items/0 lists each page's section titles by hand, so a
  # renamed, added, or removed section would otherwise leave a dead submenu
  # link (or a missing one) without anyone noticing.
  for item <- Nav.component_items() do
    @item item

    test "#{item.label}: every submenu anchor exists on its page, and every section has one",
         %{conn: conn} do
      {:ok, view, html} = live(conn, @item.path)

      for child <- @item.children do
        [_path, anchor] = String.split(child.path, "#")
        assert has_element?(view, "section##{anchor}"), "no section ##{anchor} on #{@item.path}"
      end

      page_anchors =
        html
        |> LazyHTML.from_document()
        |> LazyHTML.query("main section[id]")
        |> LazyHTML.attribute("id")

      nav_anchors = Enum.map(@item.children, &(&1.path |> String.split("#") |> List.last()))
      assert page_anchors == nav_anchors
    end
  end

  test "the sidebar renders each category as a group, open only on its own page",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/navigation")

    for item <- Nav.component_items() do
      assert has_element?(view, "#nav-#{item.id}-content")

      for child <- item.children do
        assert has_element?(view, ~s|#nav-#{item.id}-content a[href="#{child.path}"]|)
      end
    end

    assert has_element?(view, "#nav-navigation-toggle[checked]")
    refute has_element?(view, "#nav-actions-toggle[checked]")
  end
end
