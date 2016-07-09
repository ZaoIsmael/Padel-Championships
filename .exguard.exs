use ExGuard.Config

guard("unit-test", run_on_start: true)
|> notification(:off)
|> command("mix test --color")
|> watch(~r{\.(erl|ex|exs|eex|xrl|yrl)\z}i)
|> ignore(~r/priv/)
