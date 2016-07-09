use ExGuard.Config

guard("credo", run_on_start: true)
|> notification(:off)
|> command("mix credo --strict")
|> watch(~r{\.(ex|exs|eex)\z}i)
