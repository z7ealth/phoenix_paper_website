defmodule PhoenixPaperWebsiteWeb.ThemeDefaultsTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  # The site's default hues: Violet secondary, Slate tertiary, rendered on
  # <html>; Primary and Surface stay on the library's baseline (no attribute).
  test "<html> carries the default role hues", %{conn: conn} do
    html = conn |> get("/") |> html_response(200)
    [tag] = Regex.run(~r/<html[^>]*>/, html)

    assert tag =~ ~s(data-pp-secondary="violet")
    assert tag =~ ~s(data-pp-tertiary="slate")
    refute tag =~ "data-pp-primary"
    refute tag =~ "data-pp-neutral"
  end
end
