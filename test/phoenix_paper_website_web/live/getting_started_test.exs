defmodule PhoenixPaperWebsiteWeb.GettingStartedTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "has the setup steps: four required, two optional", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/getting-started")

    for id <-
          ~w(1-add-the-dependency 2-import-the-components 3-wire-up-the-tailwind-theme 4-add-the-js-hook 5-starter-app-and-auth-layouts-optional 6-a-loading-bar-in-your-primary-color-optional) do
      assert has_element?(view, "section##{id}")
    end

    # Step 5 holds both layouts and their usage snippets: four code blocks
    blocks =
      view
      |> render()
      |> LazyHTML.from_fragment()
      |> LazyHTML.query("section#5-starter-app-and-auth-layouts-optional pre code")

    assert Enum.count(blocks) == 4

    assert has_element?(view, "section#6-a-loading-bar-in-your-primary-color-optional pre code")
  end

  test "hooked components render the PhoenixPaper hook (required since 0.4.1, always on in 0.5.0)",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/navigation")
    assert has_element?(view, ~s|#demo-tabs-tablist[phx-hook="PhoenixPaper"]|)
  end
end
