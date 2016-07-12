defmodule PadelChampionships.RegistrationController  do
  use PadelChampionships.Web, :controller

  alias PadelChampionships.{Repo, User, SessionView, ChangesetView}

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user}) do
    case %User{} |> User.changeset(user) |> Repo.insert do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

        conn
        |> put_status(:created)
        |> render(SessionView, "show.json", jwt: jwt, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end
end
