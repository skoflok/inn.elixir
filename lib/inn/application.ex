defmodule Inn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    redis_link =
      case Mix.env() do
        :dev -> "redis://127.0.0.1:6379/1"
        :test -> "redis://127.0.0.1:6379/2"
        _ -> System.get_env("REDIS_URL")
      end

    children = [
      # Start the Ecto repository
      Inn.Repo,
      # Start the Telemetry supervisor
      InnWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Inn.PubSub},
      # Start the Endpoint (http/https)
      InnWeb.Endpoint,
      # Start a worker by calling: Inn.Worker.start_link(arg)
      # {Inn.Worker, arg},

      # {Redix, [name: :redix, host: "127.0.0.1", port: 6379, database: redis_db]}
      {Redix, {redis_link,  [name: :redix]}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Inn.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    InnWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
