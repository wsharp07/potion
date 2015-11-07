defmodule Potion.PageController do
  use Potion.Web, :controller

  alias Potion.Repo
  alias Potion.User

  def index(conn, _params) do
    current_user = Plug.Conn.get_session(conn, :current_user)
    posts = nil
    if (current_user != nil) do
      user = Repo.get!(User, current_user.id)
      posts = Repo.all(assoc(user, :posts))
    end
    render(conn, "index.html", posts: posts)
  end
end
