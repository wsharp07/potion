
defmodule Potion.CommentHelperTest do
  use Potion.ModelCase

  alias Potion.Comment
  alias Potion.Factory

  alias Potion.CommentHelper

  setup do
    user    = Factory.insert(:user)
    post    = Factory.insert(:post, user: user)
    comment = Factory.insert(:comment, post: post, approved: false)
    fake_socket = %{assigns: %{user: user.id}}

    {:ok, user: user, post: post, comment: comment, socket: fake_socket}
  end

  test "creates a comment for a post", %{post: post} do
    {:ok, comment} = CommentHelper.create(%{"postId" => post.id, "author" => "Some Person", "body" => "Some Post"}, %{})
    assert comment
    assert Repo.get(Comment, comment.id)
  end

  test "approves a comment when an authorized user", %{post: post, comment: comment, socket: socket} do
    {:ok, comment} = CommentHelper.approve(%{"postId" => post.id, "commentId" => comment.id}, socket)
    assert comment.approved
  end

  test "does not approve a comment when not an authorized user", %{post: post, comment: comment} do
    {:error, message} = CommentHelper.approve(%{"postId" => post.id, "commentId" => comment.id}, %{})
    assert message == "User is not authorized"
  end

  test "deletes a comment when an authorized user", %{post: post, comment: comment, socket: socket} do
    {:ok, comment} = CommentHelper.delete(%{"postId" => post.id, "commentId" => comment.id}, socket)
    refute Repo.get(Comment, comment.id)
  end

  test "does not delete a comment when not an authorized user", %{post: post, comment: comment} do
    {:error, message} = CommentHelper.delete(%{"postId" => post.id, "commentId" => comment.id}, %{})
    assert message == "User is not authorized"
  end
end
