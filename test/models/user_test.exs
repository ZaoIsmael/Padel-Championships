defmodule PadelChampionships.UserTest do
  use PadelChampionships.ModelCase

  alias PadelChampionships.User

  @valid_attrs %{
    email: "valid@email.com",
    first_name: "some content",
    last_name: "some content",
    level: "some content",
    photo: "some content",
    telephone: "some content",
    password: "password",
    password_confirmation: "password"
  }
  @invalid_attrs %{
    email: "validemail.com",
    first_name: "some content",
    last_name: "some content",
    level: "some content",
    photo: "some content",
    telephone: "some content",
    password: "password",
    password_confirmation: "password12"
  }

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
