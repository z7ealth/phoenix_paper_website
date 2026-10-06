defmodule PhoenixPaperWebsiteWeb.ThemeDefaultsTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  # The site's default colors are the library's whole MD3 baseline scheme:
  # Baseline for every role and the surface, so <html> carries no hue
  # attributes until a visitor picks one in the theme picker.
  test "<html> starts on the library's baseline scheme", %{conn: conn} do
    html = conn |> get("/") |> html_response(200)
    [tag] = Regex.run(~r/<html[^>]*>/, html)

    for attr <- ~w(data-pp-primary data-pp-secondary data-pp-tertiary data-pp-neutral) do
      refute tag =~ attr, "<html> has #{attr}"
    end
  end
end
