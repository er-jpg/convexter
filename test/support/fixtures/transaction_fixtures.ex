defmodule Convexter.TransactionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Convexter.Transaction` context.
  """

  @doc """
  Generate a convert.
  """
  def convert_fixture(attrs \\ %{}) do
    {:ok, convert} =
      attrs
      |> Enum.into(%{
        conversion_tax: "120.5",
        id_user: "some id_user",
        origin_value: "120.5"
      })
      |> Convexter.Transaction.create_convert()

    convert
  end
end