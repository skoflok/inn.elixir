defmodule Inn.CheckerTest do
  use Inn.DataCase

  alias Inn.Checker

  describe "tins" do
    alias Inn.Checker.Tin

    @valid_attrs %{ip: "some ip", number: 42}
    @update_attrs %{ip: "some updated ip", number: 43}
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
      assert tin.ip == "some ip"
      assert tin.number == 42
    end

    test "create_tin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checker.create_tin(@invalid_attrs)
    end

    test "update_tin/2 with valid data updates the tin" do
      tin = tin_fixture()
      assert {:ok, %Tin{} = tin} = Checker.update_tin(tin, @update_attrs)
      assert tin.ip == "some updated ip"
      assert tin.number == 43
    end

    test "update_tin/2 with invalid data returns error changeset" do
      tin = tin_fixture()
      assert {:error, %Ecto.Changeset{}} = Checker.update_tin(tin, @invalid_attrs)
      assert tin == Checker.get_tin!(tin.id)
    end

    test "delete_tin/1 deletes the tin" do
      tin = tin_fixture()
      assert {:ok, %Tin{}} = Checker.delete_tin(tin)
      assert_raise Ecto.NoResultsError, fn -> Checker.get_tin!(tin.id) end
    end

    test "change_tin/1 returns a tin changeset" do
      tin = tin_fixture()
      assert %Ecto.Changeset{} = Checker.change_tin(tin)
    end
  end

  describe "tins" do
    alias Inn.Checker.Tin

    @valid_attrs %{ip: "some ip", is_valid: true, number: 42}
    @update_attrs %{ip: "some updated ip", is_valid: false, number: 43}
    @invalid_attrs %{ip: nil, is_valid: nil, number: nil}

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
      assert tin.ip == "some ip"
      assert tin.is_valid == true
      assert tin.number == 42
    end

    test "create_tin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Checker.create_tin(@invalid_attrs)
    end

    test "update_tin/2 with valid data updates the tin" do
      tin = tin_fixture()
      assert {:ok, %Tin{} = tin} = Checker.update_tin(tin, @update_attrs)
      assert tin.ip == "some updated ip"
      assert tin.is_valid == false
      assert tin.number == 43
    end

    test "update_tin/2 with invalid data returns error changeset" do
      tin = tin_fixture()
      assert {:error, %Ecto.Changeset{}} = Checker.update_tin(tin, @invalid_attrs)
      assert tin == Checker.get_tin!(tin.id)
    end

    test "delete_tin/1 deletes the tin" do
      tin = tin_fixture()
      assert {:ok, %Tin{}} = Checker.delete_tin(tin)
      assert_raise Ecto.NoResultsError, fn -> Checker.get_tin!(tin.id) end
    end

    test "change_tin/1 returns a tin changeset" do
      tin = tin_fixture()
      assert %Ecto.Changeset{} = Checker.change_tin(tin)
    end
  end
end
