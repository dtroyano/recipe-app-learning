defmodule Recipeapp.Repo do
  use Ecto.Repo,
    otp_app: :recipeapp,
    adapter: Ecto.Adapters.Postgres
end
