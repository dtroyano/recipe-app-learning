defmodule Recipeapp.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string
      add :image, :string
      add :description, :string
      add :ingredients, {:array, :string}
      add :instructions, {:array, :string}
      add :cook, :integer
      add :servings, :integer
      add :type, :string
      add :vegetarian, :boolean, default: false, null: false
      add :submittedby, :string
      add :rating, :integer

      timestamps()
    end

  end
end
