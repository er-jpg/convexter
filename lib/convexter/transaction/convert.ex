defmodule Convexter.Transaction.Convert do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "conversions" do
    field :conversion_tax, :decimal
    field :id_user, :string
    field :origin_value, :decimal
    field :origin_currency, Ecto.Enum, values: [:brl, :usd, :eur, :jpy]
    field :target_currency, Ecto.Enum, values: [:brl, :usd, :eur, :jpy]

    timestamps()
  end

  @doc false
  def changeset(convert, attrs) do
    convert
    |> cast(attrs, [:id_user, :origin_value, :conversion_tax])
    |> validate_required([:id_user, :origin_value, :conversion_tax])
  end
end
