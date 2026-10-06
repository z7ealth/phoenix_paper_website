defmodule Mix.Tasks.Site.Gen.ThemePickerCss do
  @shortdoc "Regenerates assets/css/theme_picker.css from PhoenixPaper.Theme"
  @moduledoc """
  Regenerates `assets/css/theme_picker.css` (see
  `PhoenixPaperWebsiteWeb.ThemePickerCss`). Run it after changing the theme
  picker's hues or upgrading phoenix_paper.

      $ mix site.gen.theme_picker_css
  """
  use Mix.Task

  @path "assets/css/theme_picker.css"

  @impl true
  def run(_args) do
    Mix.Task.run("compile")
    File.write!(@path, PhoenixPaperWebsiteWeb.ThemePickerCss.css())
    Mix.shell().info("Wrote #{@path}")
  end
end
