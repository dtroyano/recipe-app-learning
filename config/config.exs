# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :recipeapp,
  ecto_repos: [Recipeapp.Repo]

# Configures the endpoint
config :recipeapp, RecipeappWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "iQKYATZsMwBNABpgRqloNRJzFFQwOKDydwMAnR117a7slkYQ7V8Sb+o4d1/AuAf7",
  render_errors: [view: RecipeappWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Recipeapp.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

# Configure Ueberauth to use google
config :ueberauth, Ueberauth,
  providers: [
    google: {Ueberauth.Strategy.Google, [] }
  ]

  # Configure Ueberauth with my Secrets
  config :ueberauth, Ueberauth.Strategy.Google.OAuth,
    client_id: "411860587385-dauhojg97ucr4n6lk02omp6hctmpi6v9.apps.googleusercontent.com",
    client_secret: "KLL7T5LUcRRbRoExkB5erAM0"