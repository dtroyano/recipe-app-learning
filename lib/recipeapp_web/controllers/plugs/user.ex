defmodule RecipeappWeb.Plugs.SetUser do
    import Plug.Conn
    import Phoenix.Controller

    alias Recipeapp.Repo
    alias Recipeapp.User

    def init(_params) do
        
    end

    def call(conn, _params) do
        user_id = get_session(conn, :user_id)

        cond do
            user = user_id && Repo.get(User, user_id) -> #check for user
                assign(conn, :user, user) #assign user to the conn
            true ->
                assign(conn, :user, nil) #user not found                
        end
    end
end