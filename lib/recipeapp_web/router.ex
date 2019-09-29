defmodule RecipeappWeb.Router do
  use RecipeappWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RecipeappWeb.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RecipeappWeb do
    pipe_through :browser
    resources "/", PageController
  end

  scope "/", RecipeappWeb do
    pipe_through :browser
    resources "/", DatabaseController
    get "/user/:id", DatabaseController, :userRecipes
  end

  # Scope for OAuth
  scope "/auth", RecipeappWeb do
    pipe_through :browser
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    put "/signout", AuthController, :signout
  end

  # Other scopes may use custom stacks.
  # scope "/api", RecipeappWeb do
  #   pipe_through :api
  # end
end
