defmodule Convexter.Transaction.Convert do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @params ~w(conversion_tax id_user origin_value target_value origin_currency target_currency)a

  schema "conversions" do
    field :conversion_tax, :decimal
    field :id_user, :string
    field :origin_value, :decimal
    field :target_value, :decimal
    field :origin_currency, Ecto.Enum, values: [:brl, :usd, :eur, :jpy]
    field :target_currency, Ecto.Enum, values: [:brl, :usd, :eur, :jpy]

    timestamps()
  end

  @doc false
  def changeset(convert, attrs) do
    convert
    |> cast(attrs, @params)
    |> validate_required(@params)
  end
end
