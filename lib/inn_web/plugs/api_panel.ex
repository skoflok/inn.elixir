defmodule InnWeb.Plugs.ApiPanel do
  import Plug.Conn

  def init(perms), do: perms

  def call(conn, perms) do
    if conn.assigns.logged_user.is_logged_in == false do
        conn
        |> put_status(:unauthorized)
        |> Phoenix.Controller.put_view(InnWeb.ErrorView)
        |> Phoenix.Controller.render("401.json", %{})
        |> halt()
    else 
        IO.inspect(perms, label: "Perms")
        user = conn.assigns.logged_user.user
        case user.is_admin && perms.is_admin || user.is_operator && perms.is_operator do
            true -> conn
            _ -> 
                conn
                |> put_status(:forbidden)
                |> Phoenix.Controller.put_view(InnWeb.ErrorView)
                |> Phoenix.Controller.render("403.json", %{})
                |> halt() 
        end
        conn
    end
  end


end
