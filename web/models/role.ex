defmodule Potion.Role do
  use Potion.Web, :model

  schema "roles" do
    has_many :users, Potion.User

    field :name, :string
    field :admin, :boolean, default: false

    timestamps
  end

  @required_fields ~w(name admin)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
