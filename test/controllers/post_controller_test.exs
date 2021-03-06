defmodule Potion.PostControllerTest do
  use Potion.ConnCase

  alias Potion.Post
  alias Potion.Factory

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  setup do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    post = Factory.insert(:post, user: user)

    admin_role = Factory.insert(:role, admin: true)
    admin_user = Factory.insert(:user, role: admin_role)

    other_user = Factory.insert(:user, role: role)

    conn = build_conn() |> login_user(user)
    {:ok, conn: conn, user: user, role: role, post: post, admin: admin_user, other_user: other_user}
  end

  test "lists all entries on index", %{conn: conn, user: user} do
    conn = get conn, user_post_path(conn, :index, user)
    assert html_response(conn, 200) =~ "Listing posts"
  end

  test "renders form for new resources", %{conn: conn, user: user} do
    conn = get conn, user_post_path(conn, :new, user)
    assert html_response(conn, 200) =~ "New post"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, user_post_path(conn, :create, user), post: @valid_attrs
    assert redirected_to(conn) == user_post_path(conn, :index, user)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, user: user} do
    conn = post conn, user_post_path(conn, :create, user), post: @invalid_attrs
    assert html_response(conn, 200) =~ "New post"
  end

  test "shows chosen resource", %{conn: conn, user: user} do
    post = build_post(user)
    conn = get conn, user_post_path(conn, :show, user, post)
    assert html_response(conn, 200) =~ "Single-Post"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, user: user} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, user_post_path(conn, :show, user, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, user: user} do
    post = build_post(user)
    conn = get conn, user_post_path(conn, :edit, user, post)
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    post = build_post(user)
    conn = put conn, user_post_path(conn, :update, user, post), post: @valid_attrs
    assert redirected_to(conn) == user_post_path(conn, :show, user, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user: user} do
    post = build_post(user)
    conn = put conn, user_post_path(conn, :update, user, post), post: %{"body" => nil}
    assert html_response(conn, 200) =~ "Edit post"
  end

  test "deletes chosen resource", %{conn: conn, user: user} do
    post = build_post(user)
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert redirected_to(conn) == user_post_path(conn, :index, user)
    refute Repo.get(Post, post.id)
  end

  test "redirects when the specified user does not exist", %{conn: conn} do
    conn = get conn, user_post_path(conn, :index, -1)
    assert get_flash(conn, :error) == "Invalid user!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "redirects when trying to edit a post for a different user", %{conn: conn, role: role, post: post} do
    other_user = Factory.insert(:user, %{role: role})
    conn = get conn, user_post_path(conn, :edit, other_user, post)
    assert get_flash(conn, :error) == "You are not authorized to modify that post!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "redirects when trying to update a post for a different user", %{conn: conn, role: role, post: post} do
    other_user = Factory.insert(:user, %{role: role})
    conn = put conn, user_post_path(conn, :update, other_user, post), %{"post" => @valid_attrs}
    assert get_flash(conn, :error) == "You are not authorized to modify that post!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "redirects when trying to delete a post for a different user", %{conn: conn, role: role, post: post} do
    other_user = Factory.insert(:user, %{role: role})
    conn = delete conn, user_post_path(conn, :delete, other_user, post)
    assert get_flash(conn, :error) == "You are not authorized to modify that post!"
    assert redirected_to(conn) == page_path(conn, :index)
    assert conn.halted
  end

  test "when logged in as the author, shows chosen resource with author flag set to true", %{conn: conn, user: user} do
    post = build_post(user)
    conn = login_user(conn, user) |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Single-Post"
    assert conn.assigns[:author_or_admin]
  end

  @tag admin: true
  test "when logged in as an admin, shows chosen resource with author flag set to true", %{conn: conn, user: user, admin: admin} do
    post = build_post(user)
    conn = login_user(conn, admin) |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Single-Post"
    assert conn.assigns[:author_or_admin]
  end

  test "when not logged in, shows chosen resource with author flag set to false", %{conn: conn, user: user} do
    post = build_post(user)
    conn = logout_user(conn, user) |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Single-Post"
    refute conn.assigns[:author_or_admin]
  end

  test "when logged in as a different user, shows chosen resource with author flag set to false", %{conn: conn, user: user, other_user: other_user} do
    post = build_post(user)
    conn = login_user(conn, other_user) |> get(user_post_path(conn, :show, user, post))
    assert html_response(conn, 200) =~ "Single-Post"
    refute conn.assigns[:author_or_admin]
  end

  @tag admin: true
  test "renders form for editing chosen resource when logged in as admin", %{conn: conn, user: user, post: post} do
    role = Factory.insert(:role, %{admin: true})
    admin = Factory.insert(:user, %{role: role})
    conn =
      login_user(conn, admin)
      |> (get user_post_path(conn, :edit, user, post))
    assert html_response(conn, 200) =~ "Edit post"
  end

  @tag admin: true
  test "updates chosen resource and redirects when data is valid when logged in as admin", %{conn: conn, user: user, post: post} do
    role = Factory.insert(:role, %{admin: true})
    admin = Factory.insert(:user, %{role: role})
    conn =
      login_user(conn, admin)
      |> (put user_post_path(conn, :update, user, post), post: @valid_attrs)
    assert redirected_to(conn) == user_post_path(conn, :show, user, post)
    assert Repo.get_by(Post, @valid_attrs)
  end

  @tag admin: true
  test "does not update chosen resource and renders errors when data is invalid when logged in as admin", %{conn: conn, user: user, post: post} do
    role = Factory.insert(:role, %{admin: true})
    admin = Factory.insert(:user, %{role: role})
    conn =
      login_user(conn, admin)
      |> (put user_post_path(conn, :update, user, post), post: %{"body" => nil})
    assert html_response(conn, 200) =~ "Edit post"
  end

  @tag admin: true
  test "deletes chosen resource when logged in as admin", %{conn: conn, user: user, post: post} do
    role = Factory.insert(:role, %{admin: true})
    admin = Factory.insert(:user, %{role: role})
    conn =
      login_user(conn, admin)
      |> (delete user_post_path(conn, :delete, user, post))
    assert redirected_to(conn) == user_post_path(conn, :index, user)
    refute Repo.get(Post, post.id)
  end

  # private
  defp login_user(conn, user) do
    post conn, session_path(conn, :create), user: %{username: user.username, password: user.password}
  end

  defp logout_user(conn, user) do
    delete conn, session_path(conn, :delete, user)
  end

  defp build_post(user) do
    changeset =
      user
      |> Ecto.build_assoc(:posts)
      |> Post.changeset(@valid_attrs)
    Repo.insert!(changeset)
  end
end
