defmodule Util do
  @moduledoc """
  Provides Utilities for application
  """

  @doc """
  Function to validate if parameter is a valid date
  """
  def is_date?(date) when is_bitstring(date) do
    case Date.from_iso8601(to_string(date)) do
      {:ok, _} -> true
      _ -> false
    end
  end

  def is_date?(_date), do: false
end
