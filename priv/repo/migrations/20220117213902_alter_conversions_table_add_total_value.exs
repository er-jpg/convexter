defmodule Convexter.Repo.Migrations.AlterConversionsTableAddTotalValue do
  use Ecto.Migration

  def change do
    alter table(:conversions) do
      add_if_not_exists(:total_value, :decimal)
    end
  end
end
