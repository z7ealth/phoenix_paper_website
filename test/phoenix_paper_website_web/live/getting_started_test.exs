defmodule PhoenixPaperWebsiteWeb.GettingStartedTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "has the setup steps, including the optional layouts and loading bar", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/getting-started")

    for id <-
          ~w(1-add-the-dependency 2-import-the-components 3-wire-up-the-tailwind-theme 4-starter-app-and-auth-layouts-optional 5-a-loading-bar-in-your-primary-color-optional) do
      assert has_element?(view, "section##{id}")
    end

    # Step 4 holds both layouts and their usage snippets: four code blocks
    blocks =
      view
      |> render()
      |> LazyHTML.from_fragment()
      |> LazyHTML.query("section#4-starter-app-and-auth-layouts-optional pre code")

    assert Enum.count(blocks) == 4

    assert has_element?(view, "section#5-a-loading-bar-in-your-primary-color-optional pre code")
  end
end
