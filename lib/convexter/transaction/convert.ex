defmodule Convexter.Transaction.Convert do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @params ~w(conversion_tax id_user origin_value target_value origin_currency target_currency hidden)a

  schema "conversions" do
    field :conversion_tax, :decimal
    field :id_user, :string
    field :origin_value, :decimal
    field :target_value, :decimal
    field :origin_currency, Ecto.Enum, values: [:brl, :usd, :eur, :jpy]
    field :target_currency, Ecto.Enum, values: [:brl, :usd, :eur, :jpy]
    field :hidden, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = convert, attrs) do
    convert
    |> cast(attrs, @params)
    |> validate_required(@params)
  end

  @doc false
  def toggle_visibility(convert) do
    hidden? = get_field(convert, :hidden)

    if is_nil(hidden?) do
      put_change(convert, :hidden, !hidden?)
    else
      convert
    end
  end
end
