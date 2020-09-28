defmodule InnWeb.SessionController do
  use InnWeb, :controller
  alias Inn.Account
  alias Inn.Guardian

  # plug :scrub_params, "session" when action in [:create]

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    user = Account.get_user_by_email(email)

    result =
      cond do
        user && Bcrypt.verify_pass(password, user.password_hash) ->
          {:ok, conn}

        user ->
          {:error, :unauthorized, conn}

        true ->
          {:error, :not_found, conn}
      end

    {status, jwt, claims} = Guardian.encode_and_sign(user);
    case result do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Вы залогинены")
        |> put_resp_cookie("_inn_token", jwt)
        |> redirect(to: "/admin")

      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Неверный логин/пароль")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> put_flash(:info, "Вы вышли из системы")
    |> delete_resp_cookie("_inn_token")
    |> redirect(to: "/")
  end
end
