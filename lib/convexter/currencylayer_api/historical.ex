defmodule Convexter.Currencylayer.Historical do
  @moduledoc """
  Provides functions to call the historical endpoint in currencylayer
  """

  use Tesla

  plug Tesla.Middleware.Headers, [{"Content-Type", "application/json"}]
  plug Tesla.Middleware.JSON

  plug Tesla.Middleware.BaseUrl,
       Application.get_env(:convexter, Convexter.Currencylayer)[:currencylayer_url]

  @route "/historical"
  @access_key Application.get_env(:convexter, Convexter.Currencylayer)[:currencylayer_access_key]

  def call(date, origin_currency) do
    @route
    |> get(
      query: [
        access_key: @access_key,
        date: date,
        currencies: "#{origin_currency}"
      ]
    )
    |> handle_response()
  end

  defp handle_response({:ok, %Tesla.Env{body: %{"quotes" => quotes}, status: 200}}),
    do: {:ok, quotes}

  defp handle_response({:ok, %Tesla.Env{body: body, status: status}}),
    do: {:error, "#{status} #{body}"}

  defp handle_response({:error, _reason} = error), do: error
end
