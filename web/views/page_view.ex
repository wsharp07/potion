defmodule Potion.PageView do
  use Potion.Web, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end
end
