defmodule Convexter.Transaction.Convert do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "conversions" do
    field :conversion_tax, :decimal
    field :id_user, :string
    field :origin_value, :decimal

    timestamps()
  end

  @doc false
  def changeset(convert, attrs) do
    convert
    |> cast(attrs, [:id_user, :origin_value, :conversion_tax])
    |> validate_required([:id_user, :origin_value, :conversion_tax])
  end
end
