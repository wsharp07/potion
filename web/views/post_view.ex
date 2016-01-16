defmodule Potion.PostView do
  use Potion.Web, :view

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end

  def can_edit(conn) do
    if(user = current_user(conn)) do
      True
    else
      False
    end
  end
end
