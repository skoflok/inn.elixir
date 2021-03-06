defmodule InnWeb.AdminController do
  use InnWeb, :controller

  alias Inn.Checker
  alias Inn.RedisClient

  plug(
    InnWeb.Plugs.AdminPanel,
    %{:is_admin => true, :is_operator => false} when action in [:banned]
  )

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer(10)

    p =
      cond do
        page <= 0 -> 1
        true -> page
      end

    %{:meta => meta, :data => tins} = Checker.list_paging(p, 10)
    conn |> render("index.html", tins: tins, meta: meta)
  end

  def banned(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer(10)

    p =
      cond do
        page <= 0 -> 1
        true -> page
      end

    %{:meta => meta, :data => list} = RedisClient.list_paging(p, 10)

    conn |> render("banned.html", list: list, meta: meta)
  end
end
