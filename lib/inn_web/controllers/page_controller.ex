defmodule InnWeb.PageController do
  use InnWeb, :controller

  alias Inn.Checker

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
end
