defmodule InnWeb.TinController do
  use InnWeb, :controller

  alias Inn.Checker
  alias Inn.Checker.Tin

  action_fallback InnWeb.FallbackController

  def index(conn, _params) do
    tins = Checker.list_tins()
    render(conn, "index.json", tins: tins)
  end

  def create(conn, %{"tin" => tin_params}) do
    with {:ok, %Tin{} = tin} <- Checker.create_tin(tin_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.tin_path(conn, :show, tin))
      |> render("show.json", tin: tin)
    end
  end

  def show(conn, %{"id" => id}) do
    tin = Checker.get_tin(id)
    case tin do
      %Tin{} -> conn|> put_status(200)|> render("show.json", %{success: true, tin: tin, msg: "Ok"}) 
      _ -> conn|> put_status(404)|> render("show.json", %{success: false, tin: tin, msg: "Not Found"})
    end
  end

  def update(conn, %{"id" => id, "tin" => tin_params}) do
    tin = Checker.get_tin!(id)

    with {:ok, %Tin{} = tin} <- Checker.update_tin(tin, tin_params) do
      render(conn, "show.json", tin: tin)
    end
  end

  def delete(conn, %{"id" => id}) do
    tin = Checker.get_tin!(id)

    with {:ok, %Tin{}} <- Checker.delete_tin(tin) do
      send_resp(conn, :no_content, "")
    end
  end
end
