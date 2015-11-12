defmodule Potion.Post do
  use Potion.Web, :model

  schema "posts" do
    belongs_to :user, Potion.User

    field :title, :string
    field :body, :string

    timestamps
  end

  @required_fields ~w(title body)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> strip_unsafe_body(params)
  end

  # private
  defp strip_unsafe_body(model, %{"body" => nil}) do
    model
  end

  defp strip_unsafe_body(model, %{"body" => body}) do
    model |> put_change(:body, strip_tags(body))
  end

  defp strip_unsafe_body(model, _) do
    model
  end

  defp strip_tags(body) do
    body
    |> strip_tag("script")
    |> strip_tag("iframe")
    |> strip_tag("link")
  end

  defp strip_tag(body, tag) do
    strip_regex = ~r{<#{tag}[^>]*>[^<>]*(</#{tag}>)*}i
    body |> String.replace(strip_regex, "")
  end
end
