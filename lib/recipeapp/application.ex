defmodule Recipeapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Recipeapp.Repo,
      # Start the endpoint when the application starts
      RecipeappWeb.Endpoint
      # Starts a worker by calling: Recipeapp.Worker.start_link(arg)
      # {Recipeapp.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Recipeapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RecipeappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
