defmodule PadelChampionships.Session do
  @moduledoc false

  import Comeonin.Bcrypt, only: [checkpw: 2]
  alias PadelChampionships.{Repo, User}

  def authenticate(%{"email" => email, "password" => password}) do
    User
    |> Repo.get_by(email: String.downcase(email))
    |> check_password(password)
  end

  defp check_password(user, _password) when user == nil do
    :error
  end

  defp check_password(user, password) do
    case checkpw(password, user.encrypted_password) do
      true -> {:ok, user}
      false -> :error
    end
  end
end
