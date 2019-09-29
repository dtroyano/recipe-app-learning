defmodule RecipeappWeb.DatabaseController do
    use RecipeappWeb, :controller

    alias Recipeapp.Recipe
    alias Recipeapp.User

    plug RecipeappWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
    plug :check_owner when action in [:update, :edit, :delete]


    def index conn, params do
        term = get_in(params, ["term"])
        recipes = Recipe
            |> Recipeapp.search(term)
            |> Recipeapp.Repo.all()
        #recipes = Recipeapp.Repo.all(Recipe)
        render conn, "index.html", recipes: recipes, term: term
    end

    def new conn, _params do
        changeset = Recipe.changeset(%Recipe{}, %{})
        render conn, "new.html", changeset: changeset
    end

    def create conn, %{"recipe" => recipe} do
        changeset = conn.assigns.user
            |> Ecto.build_assoc(:recipes)
            |> Recipe.changeset(recipe)

        #changeset = Recipe.changeset(%Recipe{}, recipe)

        case Recipeapp.Repo.insert(changeset) do
            {:ok, recipe} ->
                conn
                    |> put_flash(:info, "Successfully created #{recipe.name}")
                    |> redirect(to: Routes.database_path(conn, :index))
            {:error, _recipe} ->
                conn
                    |> put_flash(:error, "Failed to create")
                    |> render("new.html", changeset: changeset)
        end        
    end

    def show conn, %{"id" => recipe_id} do
        recipe = Recipeapp.Repo.get(Recipe, recipe_id)
        time = Recipeapp.cookTime(recipe.cook)
        render conn, "show.html", recipe: recipe, time: time
    end

    def edit conn, %{"id" => recipe_id} do
        recipe = Recipeapp.Repo.get(Recipe, recipe_id)
        changeset = Recipe.changeset(recipe)
        render conn, "edit.html", changeset: changeset, recipe: recipe
    end

    def update conn, %{"id" => recipe_id, "recipe" => recipe} do
        old_recipe = Recipeapp.Repo.get(Recipe, recipe_id)
        changeset = Recipe.changeset(old_recipe, recipe)
        case Recipeapp.Repo.update(changeset) do
             {:ok, recipe} ->
                conn
                    |> put_flash(:info, "Successfully updated #{recipe.name}")
                    |> redirect(to: Routes.database_path(conn, :index))
            {:error, _recipe} ->
                 conn
                    |> put_flash(:error, "Update failed")
                    |> render("edit.html", changeset: changeset, recipe: old_recipe)
        end
    end

    def delete conn, %{"id" => recipe_id} do

        %{name: name} = Recipeapp.Repo.get!(Recipe, recipe_id) 
            |> Recipeapp.Repo.delete!

        conn
            |> put_flash(:info, "Successfully deleted #{name}")
            |> redirect(to: Routes.database_path(conn, :index))
    end

    def check_owner conn, _params do
        %{params: %{"id" => recipe_id}} = conn

        if Recipeapp.Repo.get(Recipe, recipe_id).user_id == conn.assigns.user.id do
            conn
            else
            conn
                |> put_flash(:error, "You can't edit an entry you didn't create")
                |> redirect(to: Routes.database_path(conn, :index))
                |> halt()
        end
    end

    def userRecipes conn, %{"id" => user_id} = params do
        term = get_in(params, ["term"])
        user = Recipeapp.Repo.get(User, user_id)
        recipes = Recipeapp.Repo.all(Ecto.assoc(user, :recipes))
        render conn, "index.html", recipes: recipes, term: term
    end

end