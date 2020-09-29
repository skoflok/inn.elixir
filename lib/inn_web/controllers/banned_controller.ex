defmodule InnWeb.BannedController do
  use InnWeb, :controller

  alias Inn.RedisClient
  alias Inn.Checker

  action_fallback(InnWeb.FallbackController)

  plug(InnWeb.Plugs.ApiPanel, %{:is_admin => true, :is_operator => false})

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer(10)

    p =
      cond do
        page <= 0 -> 1
        true -> page
      end

    %{:meta => meta, :data => list} = RedisClient.list_paging(p, 4)

    render(conn, "index.json", list: list, meta: meta)
  end

  def ban(conn, params) do
    {:ok, data, _conn_details} = Plug.Conn.read_body(conn)
    IO.inspect(data, label: "TEST")
    body = Jason.decode!(data)
    %{"time" => time_s} = body
    %{"id" => id_s} = params

    id = String.to_integer(id_s, 10)

    time =
      case is_integer(time_s) do
        true -> time_s
        _ -> nil
      end

    tin = Checker.get_tin(id)

    RedisClient.set_banned(tin.ip, time)
    %{:meta => meta, :data => list} = RedisClient.list_paging(1, 4)

    render(conn, "show.json", %{banned: %{:ip => tin.ip, :time => time}, success: true, msg: "Ok"})
  end

  def remove(conn, %{"ip" => ip} = params) do
    RedisClient.rem_banned(ip)
    render(conn, "show.json", %{banned: %{:ip => ip, :time => nil}, success: true, msg: "Ok"})
  end
end
