defmodule PhoenixPaperWebsiteWeb.Release052DemosTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "Text Field's chips demo removes a chip, and the label drops with the last", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")

    assert has_element?(view, ~s|section#text-field [data-pp-component="chip"]|, "Ada Lovelace")

    render_click(view, "remove_recipient", %{"name" => "Ada Lovelace"})
    render_click(view, "remove_recipient", %{"name" => "Grace Hopper"})
    refute has_element?(view, ~s|section#text-field [data-pp-component="chip"]|)
    assert has_element?(view, "#reset-recipients")
  end

  test "Password Field renders the visibility toggle", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")

    assert has_element?(view, "input#password-demo[type=password]")
    assert has_element?(view, ~s|section#password-field button[aria-pressed="false"]|)
  end

  test "Autocomplete multiple shows the picked values as chips", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")

    assert has_element?(view, ~s|#tags-autocomplete [data-pp-component="chip"]|, "elixir")
    assert has_element?(view, ~s|#tags-autocomplete input[name="tags[]"][value="phoenix"]|)
  end

  test "Upload renders a drop zone with a live file input", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")

    assert has_element?(view, "#upload-form [phx-drop-target]")
    assert has_element?(view, "#upload-form input[type=file]")
  end

  test "list-detail opens and closes a message", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/surfaces")

    refute has_element?(view, "#message-detail")
    view |> element("#message-2") |> render_click()
    assert has_element?(view, "#message-detail", "Found a bug")
    view |> element("#close-message") |> render_click()
    refute has_element?(view, "#message-detail")
  end
end
