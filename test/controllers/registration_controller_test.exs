defmodule PadelChampionships.RegistrationControllerTest do
  use PadelChampionships.ConnCase

  @valid_attrs %{
    email: "test@test.com",
    first_name: "some content",
    last_name: "some content",
    level: "some content",
    photo: "some content",
    telephone: "some content",
    password: "1224356df",
    password_validation: "1224356df"
  }

  @get_user %{
    email: "test@test.com",
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "user registration and create token", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @valid_attrs

    assert json_response(conn, 201)["data"]["user"]["email"] == @valid_attrs.email
    assert Repo.get_by(User, @get_user)
    assert Guardian.decode_and_verify(json_response(conn, 201)["data"]["jwt"])
  end

  test "user registration failed", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs

    assert json_response(conn, 422)["errors"] != %{}
  end
end
