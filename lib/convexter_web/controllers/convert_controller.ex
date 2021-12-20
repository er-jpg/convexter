defmodule ConvexterWeb.ConvertController do
  use ConvexterWeb, :controller

  alias Convexter.Transaction
  alias Convexter.Transaction.Convert

  action_fallback ConvexterWeb.FallbackController

  def index(conn, _params) do
    conversions = Transaction.list_conversions()
    render(conn, "index.json", conversions: conversions)
  end

  def create(conn, %{"convert" => convert_params}) do
    with {:ok, %Convert{} = convert} <- Transaction.create_convert(convert_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.convert_path(conn, :show, convert))
      |> render("show.json", convert: convert)
    end
  end

  def show(conn, %{"id" => id}) do
    convert = Transaction.get_convert!(id)
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
