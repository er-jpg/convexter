defmodule Convexter.Repo.Migrations.AlterConversionsTable do
  use Ecto.Migration

  def change do
    execute "DROP TYPE IF EXISTS currency;"
    execute "CREATE TYPE currency AS ENUM ('brl', 'usd', 'eur', 'jpy');"

    alter table(:conversions) do
      add_if_not_exists(:origin_currency, :currency)
      add_if_not_exists(:target_currency, :currency)
    end
  end
end
