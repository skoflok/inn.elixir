# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :inn,
  ecto_repos: [Inn.Repo]

# Configures the endpoint
config :inn, InnWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "sJK7jZf0OTdYHAkAbVLqpMuQpowBqDY0Z6JQeWBGRx+8yZXFdnQRVpdgQjunO7Bh",
  render_errors: [view: InnWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Inn.PubSub,
  live_view: [signing_salt: "bmHzvbc6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :inn, Inn.Guardian,
       issuer: "inn",
       secret_key: "kHIpsSiyIj+xswvZHw7DsaOZGGThDF/v99fysEWHXrSUCn088KSUsRmBxHMRkHYt"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
