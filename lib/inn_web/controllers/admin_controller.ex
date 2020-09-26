defmodule InnWeb.AdminController do
  use InnWeb, :controller

  alias Inn.Checker

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()

    p =
      cond do
        page <= 0 -> 1
        true -> page
      end

    tins = Checker.list_paging(p,3)
    meta = Checker.meta_paging(p,3)
    conn |> render("index.html", tins: tins, meta: meta)
  end
end
