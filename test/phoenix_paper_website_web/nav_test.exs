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
        |> LazyHTML.query("main section[data-docs-section]")
        |> LazyHTML.attribute("id")

      nav_anchors = Enum.map(@item.children, &(&1.path |> String.split("#") |> List.last()))
      assert page_anchors == nav_anchors
    end
  end

  test "the rail has a destination per category; only the current one lists its components",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/navigation")

    for item <- Nav.component_items() do
      assert has_element?(view, ~s|#site-rail #nav-#{item.id}[href="#{item.path}"]|)
    end

    assert has_element?(view, ~s|#nav-navigation[aria-current="page"]|)
    refute has_element?(view, ~s|#nav-actions[aria-current="page"]|)

    navigation = Enum.find(Nav.component_items(), &(&1.id == :navigation))

    for child <- navigation.children do
      assert has_element?(view, ~s|#nav-navigation-content a[href="#{child.path}"]|)
    end

    refute has_element?(view, "#nav-actions-content")
  end
end
