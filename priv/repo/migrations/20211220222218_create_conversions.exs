defmodule Convexter.Repo.Migrations.CreateConversions do
  use Ecto.Migration

  def change do
    create table(:conversions) do
      add :id_user, :string
      add :origin_value, :decimal
      add :conversion_tax, :decimal

      timestamps()
    end
  end
end
