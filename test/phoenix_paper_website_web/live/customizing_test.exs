defmodule PhoenixPaperWebsiteWeb.CustomizingTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "renders the guide, linked from the sidebar", %{conn: conn} do
    {:ok, view, html} = live(conn, "/customizing")

    for id <- ~w(class-adds-it-doesn-t-replace adding-utilities-just-use-class
                 replacing-a-built-in-utility-the-modifier reach-for-an-attr-first
                 paperize-false-start-from-scratch styling-inside-a-component
                 site-wide-tweaks-in-app-css checklist) do
      assert has_element?(view, "section##{id}"), "missing section ##{id}"
    end

    assert has_element?(view, ~s|a[href="/customizing"][aria-current="page"]|)

    # Literal braces in prose must survive HEEx (not be read as interpolation).
    doc = LazyHTML.from_document(html)

    for sel <- ["main p:first-of-type", "#replacing-a-built-in-utility-the-modifier p"] do
      prose = doc |> LazyHTML.query(sel) |> Enum.map(&LazyHTML.text/1) |> Enum.join(" ")
      assert prose =~ "paperize={false}", "#{sel} lost its literal braces"
    end
  end

  test "the demo shows the plain class losing and ! / the attr winning", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/customizing")

    # Plain class: both backgrounds on the card (the built-in -low wins).
    assert has_element?(
             view,
             "#customizing-plain.bg-pp-surface-container-low.bg-pp-surface-container-highest"
           )

    assert has_element?(
             view,
             ~s|#customizing-important.bg-pp-surface-container-low[class~="!bg-pp-surface-container-highest"]|
           )

    assert has_element?(
             view,
             "#customizing-attr.bg-pp-surface-container-highest:not(.bg-pp-surface-container-low)"
           )
  end
end
