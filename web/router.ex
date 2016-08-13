defmodule PadelChampionships.Router do
  use PadelChampionships.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated,
      handler: PadelChampionships.SessionController
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated,
      handler: PadelChampionships.WebSessionController
  end

  scope "/", PadelChampionships do
    pipe_through [:browser, :browser_auth]

    get "/", PageController, :index
    delete "/session", WebSessionController, :delete
  end

  scope "/", PadelChampionships do
    pipe_through :browser # Use the default browser stack

    resources "/session", WebSessionController, only: [:create, :new]
  end

  scope "/api", PadelChampionships do
    pipe_through [:api, :api_auth]

    resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api", PadelChampionships do
    pipe_through :api

    resources "/session", SessionController, only: [:create, :delete]
    post "/registrations", RegistrationController, :create
  end
end
