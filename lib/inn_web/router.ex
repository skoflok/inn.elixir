defmodule InnWeb.Router do
  use InnWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(InnWeb.Plugs.AssignUser)
  end

  pipeline :admin_area do
    plug(:logged_in)
  end

  def logged_in(conn, _opts) do
    if conn.assigns.logged_user.is_logged_in == false do
      conn
      |> put_flash(:error, "Для доступа в панель, пройдите авторизацию")
      |> redirect(to: "/sessions/new")
    else
      conn
    end
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", InnWeb do
    pipe_through(:browser)

    get("/", PageController, :index)

    resources("/sessions", SessionController, only: [:new, :create])
    delete("/sessions", SessionController, :delete)
  end

  scope "/admin", InnWeb do
    pipe_through [:browser, :admin_area]

    get("/", AdminController, :index)
  end

  # Other scopes may use custom stacks.
  scope "/api", InnWeb do
    pipe_through(:api)

    scope "/v1" do
      scope "/tins" do
        get("/", TinController, :index)
        get("/:id", TinController, :show)
      end
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)
      live_dashboard("/dashboard", metrics: InnWeb.Telemetry)
    end
  end
end
