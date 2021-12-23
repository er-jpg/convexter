ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Convexter.Repo, :manual)

Mox.defmock(Convexter.Currencylayer.Historical,
  for: Convexter.Currencylayer.HistoricalBehaviour
)

Application.put_env(:convexter, :historical, Convexter.Currencylayer.Historical)
