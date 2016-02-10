defmodule Potion.CommentTest do
  use Potion.ModelCase
  
  alias Potion.Factory
  alias Potion.Comment

  @valid_attrs %{approved: true, author: "some content", body: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "creates a comment associated with a post" do
    comment = Factory.create(:comment)
    assert comment.post_id
  end

end