defmodule PadelChampionships.SessionView do
  use PadelChampionships.Web, :view

  def render("show.json", %{jwt: jwt, user: user}) do
    %{
      data: %{
        jwt: jwt,
        user: render_one(user, PadelChampionships.UserView, "user.json")
      }
    }
  end

  def render("forbidden.json", %{error: error}) do
    %{
      error: error
    }
  end

  def render("error.json", _params) do
    %{error: "Invalid email or password"}
  end
end
