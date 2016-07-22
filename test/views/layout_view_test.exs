defmodule Potion.LayoutViewTest do
  use Potion.ConnCase
  alias Potion.LayoutView
  alias Potion.Factory

  setup do
    role = Factory.insert(:role, %{})
    user = Factory.insert(:user, %{role: role})
    conn = build_conn()
    {:ok, conn: conn, user: user}
  end

  test "current user returns the user in the session", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
    assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session", %{conn: conn, user: user} do
    conn = delete conn, session_path(conn, :delete, user)
    refute LayoutView.current_user(conn)
  end

end
