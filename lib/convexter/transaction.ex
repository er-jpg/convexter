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
    Convert
    |> where([c], not c.hidden)
    |> Repo.all()
  end

  @doc """
  Gets a single convert.

  Raises `Ecto.NoResultsError` if the Convert does not exist.

  ## Examples

      iex> get_convert!(123)
      %Convert{}

      iex> get_convert!(456)
      ** (Ecto.NoResultsError)

  """
  def get_convert!(id), do: Repo.get!(Convert, id)

  @doc """
  Creates a convert.

  ## Examples

      iex> create_conversion(%{
          id_user: "id",
          origin_value: 100,
          origin_currency: :brl,
          target_currency: :usd,
          conversion_tax: 0.10
        })
      {:ok, %Convert{}}

      iex> create_conversion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conversion(attrs \\ %{}) do
    %Convert{}
    |> Convert.changeset(attrs)
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
    |> Convert.changeset(%{})
    |> Convert.toggle_visibility()
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

  def convert_currency(value, target_currency, "USD" = base_currency) do
    map_key = base_currency <> target_currency

    Date.utc_today()
    |> Currencylayer.get_historical_date(target_currency)
    |> case do
      {:ok, %{^map_key => quota}} -> {:ok, calculate_quota(value, 1 / quota)}
      {:ok, _quota} -> {:error, :quota_not_found}
      error -> error
    end
  end

  def convert_currency(value, "USD" = base_currency, target_currency) do
    map_key = base_currency <> target_currency

    Date.utc_today()
    |> Currencylayer.get_historical_date(target_currency)
    |> case do
      {:ok, %{^map_key => quota}} -> {:ok, calculate_quota(value, quota)}
      {:ok, _quota} -> {:error, :quota_not_found}
      error -> error
    end
  end

  defp calculate_quota(value, quota), do: value * quota
end
