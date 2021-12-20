defmodule Convexter.Repo do
  use Ecto.Repo,
    otp_app: :convexter,
    adapter: Ecto.Adapters.Postgres
end
