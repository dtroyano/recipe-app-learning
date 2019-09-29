defmodule Recipeapp.Repo.Migrations.ChangeToText do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      modify :description, :text
      modify :ingredients, {:array, :text}
      modify :instructions, {:array, :text}
    end
  end
end
