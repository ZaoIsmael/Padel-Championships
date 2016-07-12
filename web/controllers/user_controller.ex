defmodule PadelChampionships.UserController do
  use PadelChampionships.Web, :controller

  alias PadelChampionships.{Repo, User, ChangesetView}

  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    render(conn, "index.json", users: User |> Repo.all)
  end

  def create(conn, %{"user" => user_params}) do
    case %User{} |> User.changeset(user_params) |> Repo.insert do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.json", user: User |> Repo.get!(id))
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case User |> Repo.get!(id) |> User.changeset(user_params) |> Repo.update do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    User |> Repo.get!(id) |> Repo.delete!
    send_resp(conn, :no_content, "")
  end
end
