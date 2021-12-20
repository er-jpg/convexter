defmodule Convexter.TransactionTest do
  use Convexter.DataCase

  alias Convexter.Transaction

  describe "conversions" do
    alias Convexter.Transaction.Convert

    import Convexter.TransactionFixtures

    @invalid_attrs %{conversion_tax: nil, id_user: nil, origin_value: nil}

    test "list_conversions/0 returns all conversions" do
      convert = convert_fixture()
      assert Transaction.list_conversions() == [convert]
    end

    test "get_convert!/1 returns the convert with given id" do
      convert = convert_fixture()
      assert Transaction.get_convert!(convert.id) == convert
    end

    test "create_convert/1 with valid data creates a convert" do
      valid_attrs = %{conversion_tax: "120.5", id_user: "some id_user", origin_value: "120.5"}

      assert {:ok, %Convert{} = convert} = Transaction.create_convert(valid_attrs)
      assert convert.conversion_tax == Decimal.new("120.5")
      assert convert.id_user == "some id_user"
      assert convert.origin_value == Decimal.new("120.5")
    end

    test "create_convert/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transaction.create_convert(@invalid_attrs)
    end

    test "update_convert/2 with valid data updates the convert" do
      convert = convert_fixture()
      update_attrs = %{conversion_tax: "456.7", id_user: "some updated id_user", origin_value: "456.7"}

      assert {:ok, %Convert{} = convert} = Transaction.update_convert(convert, update_attrs)
      assert convert.conversion_tax == Decimal.new("456.7")
      assert convert.id_user == "some updated id_user"
      assert convert.origin_value == Decimal.new("456.7")
    end

    test "update_convert/2 with invalid data returns error changeset" do
      convert = convert_fixture()
      assert {:error, %Ecto.Changeset{}} = Transaction.update_convert(convert, @invalid_attrs)
      assert convert == Transaction.get_convert!(convert.id)
    end

    test "delete_convert/1 deletes the convert" do
      convert = convert_fixture()
      assert {:ok, %Convert{}} = Transaction.delete_convert(convert)
      assert_raise Ecto.NoResultsError, fn -> Transaction.get_convert!(convert.id) end
    end

    test "change_convert/1 returns a convert changeset" do
      convert = convert_fixture()
      assert %Ecto.Changeset{} = Transaction.change_convert(convert)
    end
  end
end
