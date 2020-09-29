defmodule InnWeb.TinControllerTest do
  use InnWeb.ConnCase

  alias Inn.Checker

  alias Inn.Guardian
  alias Inn.Account

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

  @create_attrs %{
    ip: "some ip",
    is_valid: true,
    number: 42
  }

  def fixture(:tin) do
    {:ok, tin} = Checker.create_tin(@create_attrs)
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

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tins", %{conn: conn} do
      conn = conn |> set_cookie(@admin) |> get(Routes.tin_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end

    test "lists all tins 401 code", %{conn: conn} do
      conn = conn |> get(Routes.tin_path(conn, :index))
      assert json_response(conn, 401)["data"] == nil
    end

    test "lists all tins 403 code", %{conn: conn} do
      conn = conn |> set_cookie(@guest) |> get(Routes.tin_path(conn, :index))
      assert json_response(conn, 403)["data"] == nil
    end
  end

  describe "delete tin" do
    setup [:create_tin]

    test "deletes chosen tin", %{conn: conn, tin: tin} do
      conn = conn |> set_cookie(@operator) |> delete(Routes.tin_path(conn, :delete, tin.id))
      assert response(conn, 204)

      conn = conn |> get(Routes.tin_path(conn, :show, tin.id))
      assert response(conn, 404)
    end
  end

  defp create_tin(_) do
    tin = fixture(:tin)
    %{tin: tin}
  end
end
