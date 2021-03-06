defmodule Convexter.Transaction.Convert do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @params ~w(conversion_tax id_user origin_value origin_currency target_currency hidden total_value)a

  schema "conversions" do
    field :conversion_tax, :decimal
    field :id_user, :string
    field :origin_value, :decimal
    field :target_value, :decimal, default: 0
    field :origin_currency, Ecto.Enum, values: [:BRL, :USD, :EUR, :JPY]
    field :target_currency, Ecto.Enum, values: [:BRL, :USD, :EUR, :JPY]
    field :hidden, :boolean, default: false
    field :total_value, :decimal, default: 0

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = convert, attrs) do
    convert
    |> cast(attrs, @params)
    |> validate_required(@params)
  end

  @doc false
  def add_value(%Ecto.Changeset{} = schema, conversion_function) do
    struct = apply_changes(schema)

    case conversion_function.(
           struct.origin_value,
           struct.origin_currency,
           struct.target_currency
         ) do
      {:ok, target_value} -> put_change(schema, :target_value, target_value)
      {:error, reason} -> add_error(schema, :target_value, reason)
    end
  end

  @doc false
  def calculate_conversion_tax(%Ecto.Changeset{} = schema) do
    struct = apply_changes(schema)

    total_value =
      struct.target_value
      |> Decimal.mult(struct.conversion_tax)
      |> Decimal.add(struct.target_value)

    schema
    |> put_change(:total_value, total_value)
  end
end
