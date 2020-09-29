defmodule InnWeb.Plugs.AdminPanel do
  import Plug.Conn

  def init(perms), do: perms

  def call(conn, perms) do
    if conn.assigns.logged_user.is_logged_in == false do
      conn
      |> Phoenix.Controller.put_flash(:error, "Для доступа в панель, пройдите авторизацию")
      |> Phoenix.Controller.redirect(to: "/sessions/new")
      |> halt()
    else
      user = conn.assigns.logged_user.user

      case (user.is_admin && perms.is_admin) || (user.is_operator && perms.is_operator) do
        true ->
          conn

        _ ->
          conn
          |> Phoenix.Controller.put_flash(:error, "У вас не хватает прав для просмотра страницы")
          |> Phoenix.Controller.redirect(to: "/sessions/new")
          |> halt()
      end
    end
  end
end
