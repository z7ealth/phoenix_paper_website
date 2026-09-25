defmodule PhoenixPaperWebsiteWeb.HeaderLinksTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # Both shells: Layouts.app (component pages) and Layouts.landing (home).
  for path <- ["/", "/getting-started"] do
    test "#{path} links to GitHub and Hex in new tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, unquote(path))

      assert has_element?(
               view,
               ~s|#github-link[href="https://github.com/z7ealth/phoenix_paper"][target="_blank"]|
             )

      assert has_element?(
               view,
               ~s|#hex-link[href="https://hex.pm/packages/phoenix_paper"][target="_blank"][rel="noopener noreferrer"]|
             )
    end
  end
end
