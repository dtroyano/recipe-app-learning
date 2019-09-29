defmodule Recipeapp.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :cook, :integer
    field :description, :string
    field :ingredients, {:array, :string}
    field :instructions, {:array, :string}
    field :image, :string
    field :name, :string
    field :rating, :integer
    field :servings, :integer
    field :submittedby, :string
    field :type, :string
    field :vegetarian, :boolean, default: false
    belongs_to :user, Recipeapp.User

    timestamps()
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:name, :image, :description, :ingredients, :instructions, :cook, :servings, :type, :vegetarian, :submittedby, :rating])
    |> validate_required([:name, :image, :description, :ingredients, :instructions, :cook, :servings, :type, :vegetarian, :submittedby])
  end
end