defmodule Convexter.Transaction do
  @moduledoc """
  The Transaction context.
  """

  import Ecto.Query, warn: false
  alias Convexter.Repo

  alias Convexter.Currencylayer
  alias Convexter.Transaction.Convert

  @doc """
  Returns the list of conversions.

  ## Examples

      iex> list_conversions()
      [%Convert{}, ...]

  """
  def list_conversions do
    base_list_query()
    |> Repo.all()
  end

  @doc """
  Returns the list of conversions from the given `id_user`.

    ## Examples

        iex> list_conversions("value")
        [%Convert{}, ...]
  """
  def list_conversions_by_user(id_user) do
    base_list_query()
    |> where([c], c.id_user == ^id_user)
    |> Repo.all()
  end

  @doc """
  Gets a single conversion.

  Raises `Ecto.NoResultsError` if the Convert does not exist.

  ## Examples

      iex> get_conversion!(123)
      %Convert{}

      iex> get_conversion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conversion!(id) do
    base_list_query()
    |> where([c], c.id == ^id)
    |> Repo.one!()
  end

  @doc """
  Creates a convert.

  ## Examples

      iex> create_conversion(%{
          id_user: "id",
          origin_value: 100,
          origin_currency: :BRL,
          target_currency: :USD,
          conversion_tax: 0.10
        })
      {:ok, %Convert{}}

      iex> create_conversion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversion(attrs \\ %{}) do
    %Convert{}
    |> Convert.changeset(attrs)
    |> Convert.add_value(&convert_currency/3)
    |> Repo.insert()
  end

  @doc """
  Hides a conversion.

  ## Examples

      iex> toggle_conversion(conversion)
      {:ok, %Convert{}}

      iex> toggle_conversion(convert)
      {:error, %Ecto.Changeset{}}

  """
  def toggle_conversion(%Convert{} = convert) do
    convert
    |> Convert.changeset(%{hidden: true})
    |> Repo.update()
  end

  @doc """
  Converts a given currency pair for a given value.

  ## Parameters

    - value: decimal value for conversion
    - base_currency: string for the base currency
    - target_currency: string for the target currency for conversion

  ## Returns `{:ok, value}`.

  ## Examples

    iex> convert_currency(100, "USD", "BRL")
    {:ok, value}

  """
  def convert_currency(value, base_currency, target_currency)
      when base_currency == target_currency,
      do: {:ok, value}

  def convert_currency(value, target_currency, :USD = base_currency) do
    map_key = to_string(base_currency) <> to_string(target_currency)

    target_currency
    |> Currencylayer.get_historical_date()
    |> case do
      {:ok, %{^map_key => quota}} -> {:ok, calculate_quota(value, 1 / quota)}
      {:ok, _quota} -> {:error, :quota_not_found}
      error -> error
    end
  end

  def convert_currency(value, :USD = base_currency, target_currency) do
    map_key = to_string(base_currency) <> to_string(target_currency)

    target_currency
    |> Currencylayer.get_historical_date()
    |> case do
      {:ok, %{^map_key => quota}} -> {:ok, calculate_quota(value, quota)}
      {:ok, _quota} -> {:error, :quota_not_found}
      error -> error
    end
  end

  defp calculate_quota(value, quota) do
    quota
    |> Decimal.from_float()
    |> Decimal.mult(value)
  end

  defp base_list_query do
    Convert
    |> where([c], not c.hidden)
  end
end
