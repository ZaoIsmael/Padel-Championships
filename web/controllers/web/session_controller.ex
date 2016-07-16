defmodule PadelChampionships.WebSessionController do
  use PadelChampionships.Web, :controller

  alias PadelChampionships.SessionView

  plug :put_view, SessionView
  plug :scrub_params, "session" when action in [:create]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(_conn, %{"session" => _session}) do
    :ok
  end
end
