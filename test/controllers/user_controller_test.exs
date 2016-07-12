defmodule PadelChampionships.UserControllerTest do
  use PadelChampionships.ConnCase

  @user %User{
    email: "test@test.com",
    first_name: "some content",
    last_name: "some content",
    level: "some content",
    photo: "some content",
    telephone: "some content",
    encrypted_password: "1224356df"
  }

  @user2 %User{
    email: "test2@test.com",
    first_name: "some content",
    last_name: "some content",
    level: "some content",
    photo: "some content",
    telephone: "some content",
    encrypted_password: "1224356df"
  }

  @valid_attrs %{
    email: "test2@test.com",
    first_name: "some content",
    last_name: "some content",
    level: "some content",
    photo: "some content",
    telephone: "some content",
    password: "1224356df",
    password_validation: "1224356df"
  }

  setup %{conn: conn} do
    user = Repo.insert! @user
    {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user)
    conn = conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", jwt)

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"]
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! @user2
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"id" => user.id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "email" => user.email,
      "photo" => user.photo,
      "telephone" => user.telephone,
      "level" => user.level}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @valid_attrs
    user = Repo.get_by(User, email: @valid_attrs[:email])
    assert json_response(conn, 201)["data"]["id"] == user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! @user2
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"] == user.id
    assert Repo.get_by(User, email: @valid_attrs[:email])
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! @user2
    conn = put conn, user_path(conn, :update, user), user: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! @user2
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end

  test "raise exception to delete a non-existent resource", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      delete conn, user_path(conn, :delete, -1)
    end
  end
end
