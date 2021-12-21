# Convexter

Convexter is a simple currency conversion API.

## Use case

Implementation of a Rest API for conversion between a pair of currencies using the external currencylayer service.

Requiments:

  1. Must be able to use the free version of the currencylayer api
  2. The base coin from the API is the USD
  3. Transactions should persist in the database having the following schema:
      * `user_id`
      * `origin_currency`
      * `target_currency`
      * `conversion_tax`
      * `timestamps`
  4. The success transaction must have the following response:
  ```json
  {
      "transactionId": "value",
      "userId": "value",
      "originCurrency": "value",
      "targetCurrency": "value",
      "originValue": 0.00,
      "targetValue": 0.00,
      "conversionTax": 0.000,
      "conversionDateTime": "0000-00-00 00:00:00.000000"
  }
  ```
  5. Besides an endpoint to create a conversion, the following endpoints should exist:
      * `[GET]/transactions`
      * `[GET]/transactions/:user_id`

## Installation

To start your Convexter server:

  * Clone this repository with `git clone https://github.com/er-jpg/convexter.git`
  * Edit `.env.example` to use your [currencylayer](https://currencylayer.com/dashboard) API Access Key
  * Rename `.env.example` to `.env`
  * Export your enviroment to bash using `export $(cat .env | sed 's/#.*//g' | xargs)`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`


## Usage

Import the [Insomnia](https://insomnia.rest/) colletion in __under_construction__ and run the endpoints with the given examples.

### Tests and Lint

To run tests in your application:

  * Run `mix test`

Run code analysis with strict mode:

  * Run `mix credo`

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
