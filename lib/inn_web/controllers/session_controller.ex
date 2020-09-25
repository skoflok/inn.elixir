defmodule InnWeb.SessionController do
  use InnWeb, :controller

  # plug :scrub_params, "session" when action in [:create]

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    # here will be an implementation
  end

  def delete(conn, _) do
    # here will be an implementation
  end
end
