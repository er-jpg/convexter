defmodule Convexter.Currencylayer.Historical do
  @moduledoc """
  Provides functions to call the historical endpoint in currencylayer
  """

  use Tesla

  @behaviour Convexter.Currencylayer.HistoricalBehaviour

  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.BaseUrl,
       Application.get_env(:convexter, Convexter.Currencylayer)[:currencylayer_url]

  @route "/historical"

  def call(date, origin_currency) do
    @route
    |> get(
      query: [
        access_key: get_access_key(),
        date: date,
        currencies: "#{origin_currency}"
      ]
    )
    |> handle_response()
  end

  defp get_access_key do
    case Application.get_env(:convexter, Convexter.Currencylayer)[:currencylayer_access_key] do
      "" -> raise "currencylayer_access_key env not set"
      nil -> raise "currencylayer_access_key env not set"
      string -> string
    end
  end

  defp handle_response({:ok, %Tesla.Env{body: %{"quotes" => quotes}, status: 200}}),
    do: {:ok, quotes}

  defp handle_response({:ok, %Tesla.Env{body: %{"error" => %{"info" => message}}}}),
    do: {:error, message}

  defp handle_response({:error, _reason} = error), do: error
end
