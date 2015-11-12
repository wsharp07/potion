defmodule Potion.PostView do
  use Potion.Web, :view

  def markdown(body) do
    body
    |> Earmark.to_html
    |> raw
  end
end
