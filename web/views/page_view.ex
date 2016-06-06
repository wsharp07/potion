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

  def get_summary(post_body) do
    post_body
    |> take_summary(500)
  end

  # Private
  defp take_summary(str, num_words) do
    word_list = String.split(str, " ")
    list_length = length(word_list)
    is_short = false

    if(list_length < num_words) do
      num_words = list_length
      is_short = true
    end

    tmp_list = Enum.slice(word_list,0,num_words)
    result = Enum.join(tmp_list, " ")

    if is_short do
      result
    else
      "#{result}..."
    end
  end
end
