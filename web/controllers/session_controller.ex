defmodule PadelChampionships.SessionController do
  use PadelChampionships.Web, :controller

  alias PadelChampionships.{User, Session}

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session}) do
    case Session.authenticate(session) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)

        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)

      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    claims = Guardian.Plug.claims(conn)
    Guardian.revoke!(jwt, claims)

    conn |> put_status(:created)
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render("forbidden.json", error: "Not Authenticated")
  end
end
