defmodule PhoenixPaperWebsiteWeb.ThemePickerTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "the theme picker is built from PhoenixPaper components", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/actions")

    assert has_element?(view, ~s|#pp-theme-settings-trigger[data-pp-component="icon-button"]|)
    assert has_element?(view, ~s|#pp-theme-settings-sheet[data-pp-component="side-sheet"]|)

    assert has_element?(
             view,
             ~s|#pp-theme-settings-sheet [data-pp-component="theme-toggle"]|
           )

    assert has_element?(view, ~s|#pp-theme-settings-reset[data-pp-component="button"]|)
    assert has_element?(view, ~s|#create-theme-link[data-pp-component="button"]|)

    # Only the color swatches are custom: one per hue plus Baseline, per role.
    assert has_element?(view, ~s|#pp-theme-settings-sheet [data-pp-swatch="primary:baseline"]|)
    assert has_element?(view, ~s|#pp-theme-settings-sheet [data-pp-swatch="neutral:slate"]|)
  end
end
