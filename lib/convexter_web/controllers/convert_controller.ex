defmodule ConvexterWeb.ConvertController do
  use ConvexterWeb, :controller

  alias Convexter.Transaction
  alias Convexter.Transaction.Convert

  action_fallback ConvexterWeb.FallbackController

  def index(conn, _params) do
    conversions = Transaction.list_conversions()
    render(conn, "index.json", conversions: conversions)
  end

  def convert(conn, params) do
    with {:ok, %Convert{} = convert} <- Transaction.create_conversion(params) do
      conn
      |> put_status(:created)
      |> render("show.json", convert: convert)
    end
  end

  def get_by_user(conn, %{"id_user" => user_id}) do
    conversions = Transaction.list_conversions_by_user(user_id)
    render(conn, "index.json", conversions: conversions)
  end

  def show(conn, %{"id" => id}) do
    convert = Transaction.get_conversion!(id)
    render(conn, "show.json", convert: convert)
  end

  def update(conn, %{"id" => id, "convert" => convert_params}) do
    convert = Transaction.get_convert!(id)

    with {:ok, %Convert{} = convert} <- Transaction.update_convert(convert, convert_params) do
      render(conn, "show.json", convert: convert)
    end
  end

  def delete(conn, %{"id" => id}) do
    convert = Transaction.get_convert!(id)

    with {:ok, %Convert{}} <- Transaction.delete_convert(convert) do
      send_resp(conn, :no_content, "")
    end
  end
end
