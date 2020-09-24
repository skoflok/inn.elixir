defmodule InnWeb.TinControllerTest do
  use InnWeb.ConnCase

  alias Inn.Checker
  alias Inn.Checker.Tin

  @create_attrs %{
    ip: "some ip",
    is_valid: true,
    number: 42
  }
  @update_attrs %{
    ip: "some updated ip",
    is_valid: false,
    number: 43
  }
  @invalid_attrs %{ip: nil, is_valid: nil, number: nil}

  def fixture(:tin) do
    {:ok, tin} = Checker.create_tin(@create_attrs)
    tin
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tins", %{conn: conn} do
      conn = get(conn, Routes.tin_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tin" do
    test "renders tin when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tin_path(conn, :create), tin: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.tin_path(conn, :show, id))

      assert %{
               "id" => id,
               "ip" => "some ip",
               "is_valid" => true,
               "number" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tin_path(conn, :create), tin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tin" do
    setup [:create_tin]

    test "renders tin when data is valid", %{conn: conn, tin: %Tin{id: id} = tin} do
      conn = put(conn, Routes.tin_path(conn, :update, tin), tin: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.tin_path(conn, :show, id))

      assert %{
               "id" => id,
               "ip" => "some updated ip",
               "is_valid" => false,
               "number" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tin: tin} do
      conn = put(conn, Routes.tin_path(conn, :update, tin), tin: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tin" do
    setup [:create_tin]

    test "deletes chosen tin", %{conn: conn, tin: tin} do
      conn = delete(conn, Routes.tin_path(conn, :delete, tin))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.tin_path(conn, :show, tin))
      end
    end
  end

  defp create_tin(_) do
    tin = fixture(:tin)
    %{tin: tin}
  end
end
