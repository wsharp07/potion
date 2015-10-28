defmodule Potion.PageController do
  use Potion.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
