defmodule Potion.QuoteController do
  use Potion.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
