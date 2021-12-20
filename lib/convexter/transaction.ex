defmodule Convexter.Transaction do
  @moduledoc """
  The Transaction context.
  """

  import Ecto.Query, warn: false
  alias Convexter.Repo

  alias Convexter.Transaction.Convert

  @doc """
  Returns the list of conversions.

  ## Examples

      iex> list_conversions()
      [%Convert{}, ...]

  """
  def list_conversions do
    Repo.all(Convert)
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

      iex> create_convert(%{field: value})
      {:ok, %Convert{}}

      iex> create_convert(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_convert(attrs \\ %{}) do
    %Convert{}
    |> Convert.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a convert.

  ## Examples

      iex> update_convert(convert, %{field: new_value})
      {:ok, %Convert{}}

      iex> update_convert(convert, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_convert(%Convert{} = convert, attrs) do
    convert
    |> Convert.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a convert.

  ## Examples

      iex> delete_convert(convert)
      {:ok, %Convert{}}

      iex> delete_convert(convert)
      {:error, %Ecto.Changeset{}}

  """
  def delete_convert(%Convert{} = convert) do
    Repo.delete(convert)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking convert changes.

  ## Examples

      iex> change_convert(convert)
      %Ecto.Changeset{data: %Convert{}}

  """
  def change_convert(%Convert{} = convert, attrs \\ %{}) do
    Convert.changeset(convert, attrs)
  end
end
