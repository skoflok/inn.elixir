defmodule Inn.CheckerTest do
  use Inn.DataCase

  alias Inn.Checker

  describe "tins" do
    alias Inn.Checker.Tin

    @valid_attrs %{ip: "192.231.191.2", number: 427652136712}
    @invalid_attrs %{ip: nil, number: nil}

    def tin_fixture(attrs \\ %{}) do
      {:ok, tin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Checker.create_tin()

      tin
    end

    test "list_tins/0 returns all tins" do
      tin = tin_fixture()
      assert Checker.list_tins() == [tin]
    end

    test "get_tin!/1 returns the tin with given id" do
      tin = tin_fixture()
      assert Checker.get_tin!(tin.id) == tin
    end

    test "create_tin/1 with valid data creates a tin" do
      assert {:ok, %Tin{} = tin} = Checker.create_tin(@valid_attrs)
      assert tin.ip == "192.231.191.2"
      assert tin.number == 427652136712
    end

    test "create_tin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checker.create_tin(@invalid_attrs)
    end


    test "delete_tin/1 deletes the tin" do
      tin = tin_fixture()
      assert {:ok, %Tin{}} = Checker.delete_tin(tin)
      assert_raise Ecto.NoResultsError, fn -> Checker.get_tin!(tin.id) end
    end
  end
end
