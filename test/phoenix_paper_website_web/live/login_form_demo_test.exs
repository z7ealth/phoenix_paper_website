defmodule PhoenixPaperWebsiteWeb.LoginFormDemoTest do
  use PhoenixPaperWebsiteWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "the sign-in card is a plain <.form> of pp_* inputs", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")

    assert has_element?(view, "#login-card form#login-form input[name='user[email]']")
    assert has_element?(view, "#login-form input[name='user[password]'][type=password]")
    assert has_element?(view, "#login-form input[name='user[remember_me]'][type=checkbox]")
    assert has_element?(view, "#login-form button#login-submit[type=submit]")
  end

  test "an invalid submit marks the fields, a valid one flashes", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/components/forms")

    view
    |> form("#login-form", user: %{email: "nope", password: "short"})
    |> render_submit()

    assert has_element?(view, "#login-form input[name='user[email]'][aria-invalid=true]")
    assert has_element?(view, "#login-form input[name='user[password]'][aria-invalid=true]")

    view
    |> form("#login-form", user: %{email: "ada@example.com", password: "analytical"})
    |> render_submit()

    refute has_element?(view, "#login-form [aria-invalid=true]")
    assert render(view) =~ "Signed in as ada@example.com"
  end
end
