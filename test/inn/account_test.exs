defmodule Inn.AccountTest do
  use Inn.DataCase

  alias Inn.Account
  alias Bcrypt

  describe "users" do
    alias Inn.Account.User

    @valid_attrs %{email: "some email", is_admin: true, is_operator: true, name: "some name", password: "some password"}
    @update_attrs %{email: "some updated email", is_admin: false, is_operator: false, name: "some updated name", password: "some updated password"}
    @invalid_attrs %{email: nil, is_admin: nil, is_operator: nil, name: nil, password: ""}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.is_admin == true
      assert user.is_operator == true
      assert user.name == "some name"
      assert true == Bcrypt.verify_pass("some password",user.password_hash)
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Account.update_user(user, @update_attrs)
      assert user.email == "some updated email"
      assert user.is_admin == false
      assert user.is_operator == false
      assert user.name == "some updated name"
      assert true == Bcrypt.verify_pass("some updated password",user.password_hash)
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

  end
end
