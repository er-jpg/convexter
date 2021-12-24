defmodule ConvexterWeb.ConvertControllerTest do
  use ConvexterWeb.ConnCase

  import Convexter.TransactionFixtures
  import Mox

  alias Convexter.Transaction.Convert

  setup :set_mox_global
  setup :verify_on_exit!

  @create_attrs %{
    conversion_tax: "120.5",
    id_user: "some id_user",
    origin_value: "120.5",
    origin_currency: :USD,
    target_currency: :BRL
  }
  @update_attrs %{
    conversion_tax: "456.7",
    id_user: "some updated id_user",
    origin_value: "456.7"
  }
  @invalid_attrs %{conversion_tax: nil, id_user: nil, origin_value: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all conversions", %{conn: conn} do
      conn = get(conn, Routes.convert_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create conversion" do
    test "renders conversion when data is valid", %{conn: conn} do
      expect(Convexter.Currencylayer.Historical, :call, fn _env, _opts ->
        {:ok, %{"USDBRL" => 5.50}}
      end)

      conn = post(conn, Routes.convert_path(conn, :convert), @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.convert_path(conn, :index))

      assert [
               %{
                 "id" => ^id,
                 "conversion_tax" => "120.5",
                 "id_user" => "some id_user",
                 "origin_value" => "120.5",
                 "target_value" => "662.75",
                 "origin_currency" => "USD",
                 "target_currency" => "BRL"
               }
             ] = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.convert_path(conn, :convert), @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "toggle convert" do
  #   setup [:create_conversion]

  #   test "renders convert when data is valid", %{conn: conn, convert: %Convert{id: id} = convert} do
  #     conn = put(conn, Routes.convert_path(conn, :update, convert), convert: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.convert_path(conn, :show, id))

  #     assert %{
  #              "id" => ^id,
  #              "conversion_tax" => "456.7",
  #              "id_user" => "some updated id_user",
  #              "origin_value" => "456.7"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, convert: convert} do
  #     conn = put(conn, Routes.convert_path(conn, :update, convert), convert: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete convert" do
  #   setup [:create_convert]

  #   test "deletes chosen convert", %{conn: conn, convert: convert} do
  #     conn = delete(conn, Routes.convert_path(conn, :delete, convert))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.convert_path(conn, :show, convert))
  #     end
  #   end
  # end

  defp create_convert(_) do
    convert = convert_fixture()

    %{convert: convert}
  end
end
