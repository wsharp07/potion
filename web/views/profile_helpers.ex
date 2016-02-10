defmodule Potion.ProfileHelpers do
  @moduledoc """
  Conveniences for rendering user profile elements
  """

  def gravatar_url(user_email) do
    md5_hash =
      :crypto.hash(:md5, user_email)
      |> Base.encode16
      |> String.downcase

    "http://www.gravatar.com/avatar/#{md5_hash}"
  end
end
