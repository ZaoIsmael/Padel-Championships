defmodule PadelChampionships.Router do
  use PadelChampionships.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  scope "/", PadelChampionships do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", PadelChampionships do
    pipe_through :api

    post "/registrations", RegistrationController, :create
    resources "/users", UserController, except: [:new, :edit]
  end
end
