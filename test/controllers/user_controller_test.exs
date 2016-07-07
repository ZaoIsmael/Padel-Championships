defmodule PadelChampionships.UserControllerTest do
  use PadelChampionships.ConnCase

  alias PadelChampionships.User
  @valid_attrs %{email: "some content", encrypted_password: "some content", first_name: "some content", last_name: "some content", level: "some content", photo: "some content", telephone: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{email: "some content", encrypted_password: "some content", first_name: "some content", last_name: "some content", level: "some content", photo: "some content", telephone: "some content"}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"id" => user.id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "email" => user.email,
      "encrypted_password" => user.encrypted_password,
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
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{email: "some content", encrypted_password: "some content", first_name: "some content", last_name: "some content", level: "some content", photo: "some content", telephone: "some content"}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{email: "some content", encrypted_password: "some content", first_name: "", last_name: "some content", level: "some content", photo: "", telephone: ""}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{email: "some content", encrypted_password: "some content", first_name: "some content", last_name: "some content", level: "some content", photo: "some content", telephone: "some content"}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end