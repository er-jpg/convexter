defmodule Convexter.Currencylayer do
  alias Convexter.Currencylayer

  def get_historical_date(date, target_currency) do
    if Util.is_date?(date) do
      Currencylayer.Historical.call(date, target_currency)
    else
      Currencylayer.Historical.call(Date.utc_today(), target_currency)
    end
  end
end
