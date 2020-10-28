defmodule BundWeb.DashboardControllerTest do
  use BundWeb.ConnCase


  alias Bund.Users.User

  setup %{conn: conn} do
    user = %User{email: "test@example.com", id: 1}
    authed_conn = Pow.Plug.assign_current_user(conn, user, [])

    {:ok, conn: conn, authed_conn: authed_conn}
  end

  describe "index" do
    test "lists all dashboards", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.dashboard_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Dashboard"
    end
  end

end
