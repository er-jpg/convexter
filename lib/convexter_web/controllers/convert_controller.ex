defmodule ConvexterWeb.ConvertController do
  use ConvexterWeb, :controller

  alias Convexter.Transaction
  alias Convexter.Transaction.Convert

  action_fallback ConvexterWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    conversions = Transaction.list_conversions_by_user(user_id)
    render(conn, "index.json", conversions: conversions)
  end

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

  def show(conn, %{"id" => id}) do
    convert = Transaction.get_conversion!(id)
    render(conn, "show.json", convert: convert)
  end

  def toggle(conn, %{"id" => id}) do
    convert = Transaction.get_conversion!(id)

    with {:ok, %Convert{}} <- Transaction.hide_conversion(convert) do
      send_resp(conn, :no_content, "")
    end
  end
end
