defmodule Convexter.TransactionTest do
  use Convexter.DataCase

  import Mox

  alias Convexter.Transaction

  setup :set_mox_global
  setup :verify_on_exit!

  describe "conversions" do
    alias Convexter.Transaction.Convert

    import Convexter.TransactionFixtures

    @invalid_attrs %{conversion_tax: nil, id_user: nil, origin_value: nil}

    test "list_conversions_by_user/0 returns all conversions by an user" do
      expect(Convexter.Currencylayer.Historical, :call, 2, fn _env, _opts ->
        {:ok, %{"USDBRL" => 5.667398}}
      end)

      convert_1 = convert_fixture(%{id_user: "asd"})
      convert_2 = convert_fixture(%{id_user: "test_user"})

      assert Transaction.list_conversions_by_user("asd") == [convert_1]
      refute Transaction.list_conversions_by_user("test_user") == [convert_1]

      refute Enum.member?(Transaction.list_conversions_by_user("invalid_name"), [
               convert_1,
               convert_2
             ])
    end

    test "list_conversions/0 returns all conversions" do
      expect(Convexter.Currencylayer.Historical, :call, fn _env, _opts ->
        {:ok, %{"USDBRL" => 5.667398}}
      end)

      convert = convert_fixture()

      assert Transaction.list_conversions() == [convert]
    end

    test "get_conversion!/1 returns the convert with given id" do
      expect(Convexter.Currencylayer.Historical, :call, fn _env, _opts ->
        {:ok, %{"USDBRL" => 5.667398}}
      end)

      convert = convert_fixture()

      assert Transaction.get_conversion!(convert.id) == convert
    end

    test "create_conversion/1 with valid data creates a convert" do
      expect(Convexter.Currencylayer.Historical, :call, fn _env, _opts ->
        {:ok, %{"USDBRL" => 5.0}}
      end)

      valid_attrs = %{
        conversion_tax: "0",
        id_user: "some id_user",
        origin_value: "120.5",
        origin_currency: :USD,
        target_currency: :BRL,
        target_value: "120.5"
      }

      assert {:ok, %Convert{} = convert} = Transaction.create_conversion(valid_attrs)
      assert convert.conversion_tax == Decimal.new("0")
      assert convert.id_user == "some id_user"
      assert convert.origin_value == Decimal.new("120.5")
      assert convert.target_value == Decimal.new("602.50")
    end

    test "create_conversion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transaction.create_conversion(@invalid_attrs)
    end

    test "toggle_conversion/1 hides the convert" do
      expect(Convexter.Currencylayer.Historical, :call, fn _env, _opts ->
        {:ok, %{"USDBRL" => 5.667398}}
      end)

      convert = convert_fixture()

      assert {:ok, %Convert{}} = Transaction.toggle_conversion(convert)
      assert_raise Ecto.NoResultsError, fn -> Transaction.get_conversion!(convert.id) end
    end

    #   test "change_convert/1 returns a convert changeset" do
    #     convert = convert_fixture()

    #     assert %Ecto.Changeset{} = Transaction.change_convert(convert)
    #   end
  end
end
