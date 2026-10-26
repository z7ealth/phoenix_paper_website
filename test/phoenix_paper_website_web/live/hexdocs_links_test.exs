defmodule PhoenixPaperWebsiteWeb.HexdocsLinksTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # Since 0.5.4 every phoenix_paper moduledoc links to its demo section
  # here; renaming a section breaks those links on hexdocs.
  @links Path.wildcard(Path.join(Mix.Project.deps_paths()[:phoenix_paper], "lib/**/*.ex"))
         |> Enum.flat_map(fn file ->
           Regex.scan(~r{phoenixpaper\.dev(/[a-z/-]+)#([a-z-]+)}, File.read!(file),
             capture: :all_but_first
           )
         end)
         |> Enum.uniq()

  test "phoenix_paper links to demo sections" do
    assert length(@links) > 40
  end

  test "every demo section phoenix_paper links to exists", %{conn: conn} do
    for {path, anchors} <- Enum.group_by(@links, &hd/1, &List.last/1) do
      {:ok, view, _html} = live(conn, path)

      for anchor <- anchors do
        assert has_element?(view, "section##{anchor}"), "#{path}##{anchor} is missing"
      end
    end
  end
end
