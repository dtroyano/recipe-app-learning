defmodule Recipeapp.Repo.Migrations.CorrelateUsersToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :user_id, references(:users)
    end
  end
end
