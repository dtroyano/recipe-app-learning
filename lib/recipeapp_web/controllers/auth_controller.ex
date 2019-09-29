defmodule RecipeappWeb.AuthController do
    use RecipeappWeb, :controller
    alias Recipeapp.User
    plug Ueberauth


    def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
        user = %{token: auth.credentials.token, email: auth.info.email, provider: "google"}
        changeset = User.changeset(%User{}, user)

        signin(conn, changeset)
    end

    defp signin(conn, changeset) do
        case insert_or_update_user(changeset) do
            {:ok, user} ->
                conn
                    |> put_session(:user_id, user.id)
                    |> redirect(to: Routes.database_path(conn, :index))
            {:error, _reason} ->
                conn
                    |> redirect(to: Routes.database_path(conn, :index))
        end
    end

    def signout(conn, _params) do
        conn
            |> configure_session(drop: true)
            |> redirect(to: Routes.database_path(conn, :index))
    end

    defp insert_or_update_user(changeset) do
        case Recipeapp.Repo.get_by(User, email: changeset.changes.email) do
            nil ->
               Recipeapp.Repo.insert(changeset)
            user ->
                {:ok, user} 
        end
    end
end