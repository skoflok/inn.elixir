defmodule InnWeb.Plugs.BanTimer do
  import Plug.Conn

  alias Inn.RedisClient

  def init(default), do: default

  def call(conn, _opts) do
    RedisClient.rem_outdated_ip()
    conn
  end
end
