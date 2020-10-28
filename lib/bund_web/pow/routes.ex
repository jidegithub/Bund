defmodule BundWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias BundWeb.Router.Helpers, as: Routes

  @impl true
  def user_not_authenticated_path(conn), do: Routes.login_path(conn, :index)
  def after_sign_out_path(conn), do: Routes.login_path(conn, :index)
end