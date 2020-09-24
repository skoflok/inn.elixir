defmodule InnWeb.PageController do
  use InnWeb, :controller

  def index(conn, _params) do
    conn |> render( "index.html")
  end
end
