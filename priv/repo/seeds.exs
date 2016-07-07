# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PadelChampionships.Repo.insert!(%PadelChampionships.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


alias PadelChampionships.{Repo, User}

Repo.insert!(%User{first_name: "Jose", last_name: "Lopez", telephone: "95577889", level: "A", encrypted_password: "123456", email: "test@test.es"})
Repo.insert!(%User{first_name: "Antonio", last_name: "Gomez", telephone: "95577889", level: "B", encrypted_password: "123456", email: "test@test2.es"})
Repo.insert!(%User{first_name: "Manuel", last_name: "Herrera", telephone: "95577889", level: "C", encrypted_password: "123456", email: "test@tes3.es"})
