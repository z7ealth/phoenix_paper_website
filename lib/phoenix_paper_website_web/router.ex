defmodule PhoenixPaperWebsiteWeb.Router do
  use PhoenixPaperWebsiteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixPaperWebsiteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixPaperWebsiteWeb do
    pipe_through :browser

    live_session :default do
      live "/", HomeLive
      live "/getting-started", GettingStartedLive
      live "/components", Components.IndexLive
      live "/components/buttons", Components.ButtonsLive
      live "/components/forms", Components.FormsLive
      live "/components/selection", Components.SelectionLive
      live "/components/navigation", Components.NavigationLive
      live "/components/surfaces", Components.SurfacesLive
      live "/components/layout", Components.LayoutLive
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixPaperWebsiteWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard in development
  if Application.compile_env(:phoenix_paper_website, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PhoenixPaperWebsiteWeb.Telemetry
    end
  end
end
