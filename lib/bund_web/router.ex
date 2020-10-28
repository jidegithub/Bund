defmodule BundWeb.Router do
  use BundWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :bund

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # BEGIN added for Pow
  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser
    pow_extension_routes()
    post "/register", BundWeb.Pow.RegistrationController, :create, as: :register
    resources "/login", BundWeb.LoginController
    pow_routes()
  end

  scope "/", BundWeb do
    pipe_through [:browser, :protected]

    # Add your protected routes here
    get "/", DashboardController, :index

    # get "/", PageController, :index
    resources "/accounts", AccountController
  end
  # END added for Pow

  scope "/", BundWeb do
    pipe_through :browser
    # get "/", PageController, :index
  end

  scope "/api", BundWeb.Api, as: :api do
    resources "/accounts", AccountController
     resources "/countries", CountryController
  end

  # Other scopes may use custom stacks.
  # scope "/api", BundWeb do
  #   pipe_through :api
  # end
end
