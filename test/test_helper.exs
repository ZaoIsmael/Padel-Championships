ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PadelChampionships.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PadelChampionships.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PadelChampionships.Repo)

