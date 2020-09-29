defmodule InnWeb.BannedControllerTest do
  use InnWeb.ConnCase

  alias Inn.Checker

  alias Inn.Guardian
  alias Inn.Account

  alias Inn.RedisClient

  @tin_attrs %{
    ip: "193.123.130.233",
    is_valid: true,
    number: 42
  }

  @admin %{
    name: "admin",
    email: "admin@example.com",
    password: "admin",
    is_admin: true,
    is_operator: false
  }

  @operator %{
    name: "operator",
    email: "operator@example.com",
    password: "operator",
    is_admin: false,
    is_operator: true
  }

  @guest %{
    name: "guest",
    email: "guest@example.com",
    password: "guest",
    is_admin: false,
    is_operator: false
  }

  def ban_fixture(attrs \\ %{}) do
    RedisClient.set_banned(attrs.ip, attrs.time)
  end

  def tin_fixture() do
    {:ok, tin} = Checker.create_tin(@tin_attrs)
    tin
  end

  def jwt_fixture(attrs) do
    user = Account.create_user!(attrs)
    Guardian.encode_and_sign(user)
  end

  defp set_cookie(conn, user) do
    {_status, jwt, _claims} = jwt_fixture(user)
    conn |> put_req_cookie("_inn_token", jwt)
  end

  describe "GET :index" do
    test "get 401", %{conn: conn} do
      conn = conn |> get(Routes.banned_path(conn, :index))
      assert json_response(conn, 401)["data"] == nil
    end

    test "get 403 guest", %{conn: conn} do
      conn = conn |> set_cookie(@guest) |> get(Routes.banned_path(conn, :index))
      assert json_response(conn, 403)["data"] == nil
    end

    test "get 403 operator", %{conn: conn} do
      conn = conn |> set_cookie(@operator) |> get(Routes.banned_path(conn, :index))
      assert json_response(conn, 403)["data"] == nil
    end

    test "get 200 admin", %{conn: conn} do
      conn = conn |> set_cookie(@admin) |> get(Routes.banned_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "POST :ban" do
    test "get 401", %{conn: conn} do
      tin = tin_fixture()
      conn = conn |> post(Routes.banned_path(conn, :ban, tin.id))
      assert json_response(conn, 401)["data"] == nil
    end

    test "get 403 guest", %{conn: conn} do
      tin = tin_fixture()
      conn = conn |> set_cookie(@guest) |> post(Routes.banned_path(conn, :ban, tin.id))
      assert json_response(conn, 403)["data"] == nil
    end

    test "get 403 operator", %{conn: conn} do
      tin = tin_fixture()
      conn = conn |> set_cookie(@operator) |> post(Routes.banned_path(conn, :ban, tin.id))
      assert json_response(conn, 403)["data"] == nil
    end
  end

  describe "DELETE :remove" do
    test "get 401", %{conn: conn} do
      tin = tin_fixture()
      conn = conn |> delete(Routes.banned_path(conn, :ban, tin.ip))
      assert json_response(conn, 401)["data"] == nil
    end

    test "get 403 guest", %{conn: conn} do
      tin = tin_fixture()
      conn = conn |> set_cookie(@guest) |> delete(Routes.banned_path(conn, :ban, tin.ip))
      assert json_response(conn, 403)["data"] == nil
    end

    test "get 403 operator", %{conn: conn} do
      tin = tin_fixture()
      conn = conn |> set_cookie(@operator) |> delete(Routes.banned_path(conn, :ban, tin.ip))
      assert json_response(conn, 403)["data"] == nil
    end
  end
end
