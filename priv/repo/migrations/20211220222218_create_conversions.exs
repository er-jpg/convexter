defmodule Convexter.Repo.Migrations.CreateConversions do
  use Ecto.Migration

  def change do
    create table(:conversions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :id_user, :string
      add :origin_value, :decimal
      add :conversion_tax, :decimal

      timestamps()
    end
  end
end
