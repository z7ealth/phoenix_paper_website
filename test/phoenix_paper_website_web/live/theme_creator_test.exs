defmodule PhoenixPaperWebsiteWeb.ThemeCreatorTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias PhoenixPaperWebsiteWeb.ThemeTokens

  test "tokens come from phoenix_paper.css, with a contrast check" do
    assert "primary" in ThemeTokens.names()
    assert "on-surface" in ThemeTokens.names()
    assert ThemeTokens.defaults().light["primary"] =~ ~r/^#[0-9a-f]{6}$/
    assert ThemeTokens.contrast("#ffffff", "#000000") == 21.0
    assert ThemeTokens.rating(4.6) == :aa
    assert ThemeTokens.rating(2.0) == :fail
  end

  test "the preview carries the edited palette; mode, edits, random and reset", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/theme-creator")
    light = ThemeTokens.defaults().light
    dark = ThemeTokens.defaults().dark

    assert has_element?(
             view,
             ~s|#theme-preview[data-theme="light"][style*="--color-pp-primary: #{light["primary"]}"]|
           )

    assert has_element?(view, "[data-contrast=on-primary]")

    # Dark mode previews (and edits) the dark palette
    view |> element("#mode-dark") |> render_click()

    assert has_element?(
             view,
             ~s|#theme-preview[data-theme="dark"][style*="--color-pp-primary: #{dark["primary"]}"]|
           )

    # Editing a token repaints the preview and the exported CSS
    view |> form("#theme-tokens-form", tokens: %{"primary" => "#123456"}) |> render_change()
    assert has_element?(view, ~s|#theme-preview[style*="--color-pp-primary: #123456"]|)
    assert has_element?(view, "pre code", "--color-pp-primary: #123456")

    # Invalid values are ignored
    view |> form("#theme-tokens-form", tokens: %{"primary" => "red"}) |> render_change()
    assert has_element?(view, ~s|#theme-preview[style*="--color-pp-primary: #123456"]|)

    view |> element("#theme-reset") |> render_click()
    assert has_element?(view, ~s|#theme-preview[style*="--color-pp-primary: #{dark["primary"]}"]|)

    view |> element("#theme-random") |> render_click()

    refute has_element?(
             view,
             ~s|#theme-preview[style*="--color-pp-primary: #{dark["primary"]};"]|
           )
  end

  test "the theme picker links to it, and so does the sidebar", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/getting-started")
    assert has_element?(view, ~s|#create-theme-link[href="/theme-creator"]|)
    assert has_element?(view, ~s|a[href="/theme-creator"]|, "Theme Creator")
  end
end
