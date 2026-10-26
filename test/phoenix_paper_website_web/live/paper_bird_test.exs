defmodule PhoenixPaperWebsiteWeb.PaperBirdTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  # The game itself runs in a canvas hook (not exercisable here); this checks
  # the wiring LiveView is responsible for.
  test "the home page wires the hero bird easter egg to the game dialog", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/")

    assert has_element?(view, "#hero-egg[phx-hook][data-open] svg.pp-hero-mark")

    # Both triggers look clickable
    assert has_element?(view, "#hero-egg.cursor-pointer")
    assert has_element?(view, "#hero-egg-mobile.cursor-pointer")
    # The small bird next to the headline is the trigger phones can reach.
    assert has_element?(view, "#hero-egg-mobile[phx-hook][data-open] svg.pp-hero-mark")

    # Two hero marks on one page: each needs its own gradient id, or the
    # desktop one would resolve url(#...) to the (hidden) mobile one's.
    assert has_element?(view, "#hero-egg linearGradient#pp-hero-gradient")
    assert has_element?(view, "#hero-egg-mobile linearGradient#pp-hero-mobile-gradient")
    assert has_element?(view, "#paper-bird-dialog")

    assert has_element?(
             view,
             "#paper-bird-stage[phx-update=ignore] canvas#paper-bird-canvas[phx-hook]"
           )

    assert has_element?(view, "#paper-bird-close")

    # The width lives on the centred container: MD3's basic dialog is w-full
    # up to 560px (0.5.0 dropped max_width), so the canvas, which has no
    # natural width, can't collapse it.
    assert has_element?(view, ~s|#paper-bird-dialog-container.w-full[class~="max-w-[560px]"]|)
  end
end
