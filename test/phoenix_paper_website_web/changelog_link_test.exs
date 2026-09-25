defmodule PhoenixPaperWebsiteWeb.ChangelogLinkTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias PhoenixPaperWebsiteWeb.Nav

  test "the sidebar links to phoenix_paper's CHANGELOG.md on GitHub", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/getting-started")

    assert has_element?(view, ~s|#nav-changelog[href="#{Nav.changelog_url()}"]|)
  end
end
