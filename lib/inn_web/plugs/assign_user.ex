defmodule InnWeb.Plugs.AssignUser do
  import Plug.Conn
  alias Inn.Account

  def init(default), do: default

  def call(%Plug.Conn{cookies: %{"_inn_token" => jwt}} = conn, _opts) do
    res =
      case Inn.Guardian.decode_and_verify(jwt) do
        {:ok, claims} ->
          case Account.get_user(String.to_integer(claims["sub"])) do
            user ->
              %{:is_logged_in => true, :user => user, :status => "Ok"}

            nil ->
              %{:is_logged_in => false, :user => nil, :status => "User not found"}
          end

        _ ->
          %{:is_logged_in => false, :user => nil, :status => "Bad token"}
      end

    assign(conn, :logged_user, res)
  end

  def call(conn, _opts) do
    assign(conn, :logged_user, %{
      :is_logged_in => false,
      :user => nil,
      :status => "Token mismatch"
    })
  end
end
