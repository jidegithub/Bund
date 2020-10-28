defmodule BundWeb.LoginController do
  use BundWeb, :controller

  def index(conn, _params) do
    changeset = Pow.Plug.change_user(conn)
    render conn, "index.html", changeset: changeset, msg: "", layout: {BundWeb.LayoutView, "login.html"}
  end

  def create(conn, %{"user" => user_params}) do 
    conn
    |> Pow.Plug.authenticate_user(user_params)
    |> case do
      {:ok, conn} ->
        conn
          |> redirect(to: Routes.dashboard_path(conn, :index))

      {:error, conn} ->
        changeset = Pow.Plug.change_user(conn, conn.params["user"])

        conn
          |> render("index.html", changeset: changeset, msg: "error", layout: {BundWeb.LayoutView, "login.html"})
    end
  end
end