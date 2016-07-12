defmodule PadelChampionships.RegistrationControllerTest do
  use PadelChampionships.ConnCase

  alias Comeonin.Bcrypt

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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "user registration and create token", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @valid_attrs
    user = Repo.get_by(User, email: @valid_attrs[:email])

    assert json_response(conn, 201)["data"]["user"]["email"] == @valid_attrs[:email]
    assert Bcrypt.checkpw(@valid_attrs[:password], user.encrypted_password)
    assert {:ok, _jwt} = Guardian.decode_and_verify(json_response(conn, 201)["data"]["jwt"])
  end

  test "user registration failed", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: %{}

    assert json_response(conn, 422)["errors"] != %{}
  end
end
