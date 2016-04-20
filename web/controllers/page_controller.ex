defmodule Potion.PageController do
  use Potion.Web, :controller

  alias Potion.Repo
  alias Potion.User
  alias Potion.Post

  def index(conn, _params) do
    current_user = Plug.Conn.get_session(conn, :current_user)
    posts = Repo.all(from p in Post,
                       limit: 5,
                       order_by: [desc: :id],
                       preload: [:user])
    if (current_user != nil) do
      user = Repo.get!(User, current_user.id)
    end

    render(conn, "index.html", posts: posts)
  end
end
