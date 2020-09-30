use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :inn, Inn.Repo,
  username: "postgres",
  password: "postgres",
  database: "inn_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :inn, Inn.Guardian,
       issuer: "inn",
       secret_key: "3IXtlma0ghiMZw/9dHH1KQR8o8cZ4WjK0LuGEQbjUdBeX4M9vfsRqdJxDRMUTvKL"

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :inn, InnWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
