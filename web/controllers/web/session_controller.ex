defmodule PadelChampionships.WebSessionController do
  use PadelChampionships.Web, :controller

  alias PadelChampionships.{Session, SessionView}

  plug :put_view, SessionView
  plug :scrub_params, "session" when action in [:create]

  def new(conn, _params) do
    case Guardian.Plug.authenticated?(conn) do
      false ->
        render(conn, "new.html")
      true ->
        conn |> redirect(to: page_path(conn, :index))
    end
  end

  def create(conn, %{"session" => session}) do
    case Guardian.Plug.authenticated?(conn) do
      false ->
        case Session.authenticate(session) do
          {:ok, user} ->
            conn
            |> Guardian.Plug.sign_in(user)
            |> redirect(to: page_path(conn, :index))
          :error ->
            conn |> redirect(to: web_session_path(conn, :new))
        end
      true ->
        conn |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out")
    |> redirect(to: web_session_path(conn, :new))
  end

  def unauthenticated(conn, _params) do
    conn
    |> redirect(to: web_session_path(conn, :new))
  end
end
