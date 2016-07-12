defmodule PadelChampionships.SessionController do
  use PadelChampionships.Web, :controller

  alias PadelChampionships.{Repo, User, SessionView}
  alias Comeonin.Bcrypt

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session}) do
    case authenticate(session) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)

        conn
        |> put_status(:created)
        |> render(SessionView, "show.json", jwt: jwt, user: user)

      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(SessionView, "error.json")
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(SessionView, "forbidden.json", error: "Not Authenticated")
  end

  defp authenticate(%{"email" => email, "password" => password}) do
    User
    |> Repo.get_by(email: String.downcase(email))
    |> check_password(password)
  end

  defp check_password(user, _password) when user == nil do
    :error
  end

  defp check_password(user, password) do
    case Bcrypt.checkpw(password, user.encrypted_password) do
      true -> {:ok, user}
      false -> :error
    end
  end
end
