defmodule RecipeappWeb.PageController do
  use RecipeappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"id" => item_id}) do
    item = Recipeapp.showRecipe item_id
    time = Recipeapp.cookTime(item["readyInMinutes"])
    render conn, "show.html", item: item, time: time
  end

  def create(conn, %{"term" => term}) do
    term = String.replace term, " ", "_"
    render conn, "index.html", term: term
  end
end
