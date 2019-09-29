defmodule RecipeappWeb.Plugs.RequireAuth do
    import Plug.Conn
    import Phoenix.Controller

    alias RecipeappWeb.Router.Helpers

    def init(_params) do        
    end

    def call(conn, _params) do
        if conn.assigns[:user] do
            conn
        else
            conn
                |> redirect(to: Helpers.database_path(conn, :index) )
                |> halt()
        end
    end
end