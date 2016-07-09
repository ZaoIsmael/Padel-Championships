defmodule PadelChampionships.UserView do
  use PadelChampionships.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, PadelChampionships.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, PadelChampionships.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      photo: user.photo,
      telephone: user.telephone,
      level: user.level}
  end
end
