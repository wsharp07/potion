defmodule Potion.CommentController do
  use Potion.Web, :controller

  alias Potion.Comment
  alias Potion.Post

  plug :scrub_params, "comment" when action in [:create, :update]

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
        comment_changeset: changeset)
    end
  end

  def update(conn, _), do: conn
  def delete(conn, _), do: conn
end
