defmodule Convexter.Currencylayer.HistoricalBehaviour do
  @moduledoc false
  @callback call(any(), any()) :: tuple()
end
