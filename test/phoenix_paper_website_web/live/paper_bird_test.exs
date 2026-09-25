defmodule PhoenixPaperWebsiteWeb.PaperBirdTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # The game itself runs in a canvas hook (not exercisable here); this checks
  # the wiring LiveView is responsible for.
  test "the home page wires the hero bird easter egg to the game dialog", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#hero-egg[phx-hook][data-open] svg.pp-hero-mark")
    assert has_element?(view, "#paper-bird-dialog")

    assert has_element?(
             view,
             "#paper-bird-stage[phx-update=ignore] canvas#paper-bird-canvas[phx-hook]"
           )

    assert has_element?(view, "#paper-bird-close")

    # The width lives on the centred container (phoenix_paper 0.2.7), so the
    # canvas, which has no natural width, can't collapse the dialog.
    assert has_element?(view, "#paper-bird-dialog-container.w-full.max-w-2xl")
  end
end
