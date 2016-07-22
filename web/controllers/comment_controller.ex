defmodule Potion.CommentController do
  use Potion.Web, :controller

  alias Potion.Comment
  alias Potion.Post

  plug :scrub_params, "comment" when action in [:create, :update]
  plug :set_post_and_authorize_user when action in [:update, :delete]

  @valid_attrs %{author: "Some Person", body: "This is a sample comment"}
  @invalid_attrs %{}

  def create(conn, %{"comment" => comment_params, "post_id" => post_id}) do
    # Find the post and preload nav props
    post = Repo.get!(Post, post_id) |> Repo.preload([:user, :comments])

    # Build the changeset
    changeset = post
      |> build_assoc(:comments)
      |> Comment.changeset(comment_params)

    case Repo.insert(changeset) do
      # Inserted successfully
      {:ok, _comment} ->
        conn
        |> put_flash(:info, "Comment created successfully!")
        |> redirect(to: user_post_path(conn, :show, post.user, post))
      # Error on insert
      {:error, changeset} ->
        render(conn, Potion.PostView, "show.html", post: post, user: post.user,
        comment_changeset: changeset, num_approved_comments: 0)
    end
  end

  def update(conn, %{"id" => id, "post_id" => post_id, "comment" => comment_params}) do
    post = Repo.get!(Post, post_id) |> Repo.preload(:user)
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Comment updated successfully.")
        |> redirect(to: user_post_path(conn, :show, post.user, post))
      {:error, _} ->
        conn
        |> put_flash(:info, "Failed to update comment!")
        |> redirect(to: user_post_path(conn, :show, post.user, post))
    end
  end

  def delete(conn, %{"id" => id}) do
    post = conn.assigns[:post]
    comment = Repo.get!(Comment, id)
    Repo.delete!(comment)
    conn
      |> put_flash(:info, "Deleted comment!")
      |> redirect(to: user_post_path(conn, :show, post.user, post))
  end

  # private
  defp set_post(conn) do
    post = Repo.get!(Post, conn.params["post_id"]) |> Repo.preload(:user)
    assign(conn, :post, post)
  end


  defp set_post_and_authorize_user(conn, _opts) do
    conn = set_post(conn)
    if is_authorized_user?(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to modify that comment!")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end

  defp is_authorized_user?(conn) do
    user = get_session(conn, :current_user)
    post = conn.assigns[:post]
    (user && (user.id == post.user_id || Potion.RoleChecker.is_admin?(user)))
  end

end
