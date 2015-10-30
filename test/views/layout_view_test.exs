defmodule Potion.LayoutViewTest do
  use Potion.ConnCase
  alias Potion.LayoutView
  alias Potion.User

  setup do
    User.changeset(%User{}, %{username: "tuser", password: "test", password_confirmation: "test", email: "test@test.com"})
    |> Repo.insert
    conn = conn()
    {:ok, conn: conn}
  end

  test "current user returns the user in the session", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "tuser", password: "test"}
    assert LayoutView.current_user(conn)
  end

  test "current user returns nothing if there is no user in the session" do
    user = Repo.get_by(User, %{username: "tuser"})
    conn = delete conn, session_path(conn, :delete, user)
    refute LayoutView.current_user(conn)
  end
end
