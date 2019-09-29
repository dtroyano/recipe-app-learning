defmodule Recipeapp do
  import Ecto.Query
  @moduledoc """
  Recipeapp keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # This function takes an id for Spoonacular and returns the information about that recipe
  def showRecipe(id) do
    api = spoonacularApiKey()
    location = "https://api.spoonacular.com/recipes/#{id}/information?includeNutrition=false#{api}"
    {:ok, results} = HTTPoison.get location
    {:ok, final} = Poison.decode results.body
    final
  end

  # This is a function to make a URL with my API for Spoonacular
  def spoonacularApiKey do
    apiKey = "3de3a3ffc34040b98943e44b95398ac3"
    "&apiKey=#{apiKey}"
  end

  # This is a function to create the URL for a serach for recipes in Spoonacular
  def spoon(term, number) do
    api = spoonacularApiKey()
    "https://api.spoonacular.com/recipes/search?query=#{term}&number=#{number}#{api}"
  end

  #This is a function to make the search of Spoonacular
  def spoonCall(term, number) do
    {:ok, results} = HTTPoison.get Recipeapp.spoon(term, number)
    {:ok, %{"results" => final}} = Poison.decode results.body
    final
  end

  def cookTime(time) do
    cond do
      time > 60 ->
        hours = Integer.floor_div time , 60
        minutes = time - (hours * 60)
        [hours, minutes]
      time < 60 ->
        [0, time]
    end
  end

  #Search Functionallity
  #################################
  #Function call for search 
  def run(query, search) do
    runQuery(query, normalize(search))
  end

  defmacro matching_recipe_ids_and_ranks(search) do
    quote do
      fragment(
        """
        SELECT recipe_search.id AS id,
        ts_rank(
          recipe_search.document, plainto_tsquery(unaccent(?))
        ) AS rank
        FROM recipe_search
        WHERE recipe_search.document @@ plainto_tsquery(unaccent(?))
        OR recipe_search.title ILIKE ?
        """,
        ^unquote(search),
        ^unquote(search),
        ^"%#{unquote(search)}%"
      )
    end
  end

  #Generate the acutal serach
  #defp runQuery(query, "") do: query
  defp runQuery(query, search) do
    from recipe in query,
      join: id_and_rank in matching_recipe_ids_and_ranks(search),
      on: id_and_rank.id == recipe.id,
      order_by: [desc: id_and_rank.rank]
  end


  #Remove Tabs, Lines, and Condense White Space and Trim it
  defp normalize(search) do
    search
      |> String.downcase
      |> String.replace(~r/\n/, " ")
      |> String.replace(~r/\t/. " ")
      |> String.replace(~r/\s{2,}/, " ")
      |> String.trim
  end


  #LEARING SEARCH
  def search(query, term) do
    wildcard_search = "%#{term}%"

    from recipe in query,
      where: ilike(recipe.name, ^wildcard_search),
      or_where: ilike(recipe.description, ^wildcard_search)
  end

end
