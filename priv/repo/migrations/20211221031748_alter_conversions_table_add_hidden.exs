defmodule Convexter.Repo.Migrations.AlterConversionsTableAddHidden do
  use Ecto.Migration

  def change do
    alter table(:conversions) do
      add_if_not_exists(:hidden, :boolean, default: false)
    end
  end
end
