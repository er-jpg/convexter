defmodule Convexter.Currencylayer do
  @moduledoc """
  Provides functions for the Currencylayer context
  """
  alias Convexter.Currencylayer

  @doc """
  Get the historical quota for a target currency.
  """
  def get_historical_date(target_currency) do
    Currencylayer.Historical.call(Date.utc_today(), target_currency)
  end
end
