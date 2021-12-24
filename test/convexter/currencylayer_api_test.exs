defmodule Convexter.CurrencylayerTest do
  use Convexter.DataCase

  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  describe "Currencylayer" do
    alias Convexter.Currencylayer

    test "get_historical_date/1 returns 200 api external call" do
      conversion_quota = %{"USDBRL" => 5.50}

      expect(Convexter.Currencylayer.Historical, :call, fn _env, _opts ->
        {:ok, conversion_quota}
      end)

      date = Date.utc_today()

      assert {:ok, conversion_quota} == Currencylayer.Historical.call(date, :BRL)
    end
  end
end
