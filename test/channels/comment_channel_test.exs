defmodule Potion.CommentChannelTest do
  use Potion.ChannelCase

  alias Potion.CommentChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(CommentChannel, "comments:lobby")

    {:ok, socket: socket}
  end

end
