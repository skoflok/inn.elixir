defmodule InnWeb.AdminControllerTest do
  use InnWeb.ConnCase

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

  def jwt_fixture(attrs) do
    user = Account.create_user!(attrs)
    Guardian.encode_and_sign(user)
  end

  defp set_cookie(conn, user) do
    {_status, jwt, _claims} = jwt_fixture(user)
    conn |> put_req_cookie("_inn_token", jwt)
  end

  describe "/admin" do
    test "GET /admin", %{conn: conn} do
      conn = conn |> set_cookie(@operator) |> get("/admin")
      assert html_response(conn, 200) =~ "<h2> Админ-панель </h2>"
    end

    test "GET /admin 302", %{conn: conn} do
      conn = conn |> get("/admin")
      assert html_response(conn, 302) =~ "redirected"
    end

    test "GET /admin 302 guest", %{conn: conn} do
      conn = conn |> set_cookie(@guest) |> get("/admin")
      assert html_response(conn, 302) =~ "redirected"
    end
  end

  describe "/admin/banned" do

   test "GET /banned", %{conn: conn} do
      conn = conn |> set_cookie(@admin) |> get("/admin/banned")
      assert html_response(conn, 200) =~ "<h2> Список забаненных </h2>"
    end

    test "GET /admin 302 operator", %{conn: conn} do
      conn = conn |> set_cookie(@operator) |> get("/admin/banned")
      assert html_response(conn, 302) =~ "redirected"
    end

    test "GET /admin 302", %{conn: conn} do
      conn = conn |> get("/admin/banned")
      assert html_response(conn, 302) =~ "redirected"
    end

    test "GET /admin 302 guest", %{conn: conn} do
      conn = conn |> set_cookie(@guest) |> get("/admin/banned")
      assert html_response(conn, 302) =~ "redirected"
    end
  end
end
