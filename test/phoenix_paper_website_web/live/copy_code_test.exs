defmodule PhoenixPaperWebsiteWeb.CopyCodeTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # Every code block (DocsComponents.code/1) gets its own copy button, wired
  # to the block it copies.
  for path <- ["/getting-started", "/theming", "/components/navigation"] do
    test "#{path}: every code block has a copy button", %{conn: conn} do
      {:ok, _view, html} = live(conn, unquote(path))
      doc = LazyHTML.from_document(html)

      blocks = doc |> LazyHTML.query("pre[phx-hook]") |> LazyHTML.attribute("id")
      assert blocks != []

      for id <- blocks do
        button = LazyHTML.query(doc, "button##{id}-copy[phx-hook][data-target=#{id}]")
        assert Enum.count(button) == 1, "no copy button for ##{id}"

        # Pinned to the block's corner: absolute, with no competing `relative`
        # (pp_button's ripple adds one, which would win and drop it below).
        classes = button |> LazyHTML.attribute("class") |> hd() |> String.split()
        assert "absolute" in classes
        refute "relative" in classes

        # Only the clipboard icon shows until a copy: the check's wrapper is
        # hidden (not the icon, whose own inline-block would win).
        assert Enum.count(
                 LazyHTML.query(button, "span.hidden > [data-pp-component=icon].hero-check")
               ) == 1
      end
    end
  end
end
