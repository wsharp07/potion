defmodule Potion.UserTest do
  use Potion.ModelCase

  alias Potion.User
  alias Potion.TestHelper

  @valid_attrs %{email: "test@test.com", password: "test1234", password_confirmation: "test1234", username: "tuser"}
  @invalid_attrs %{}

  setup do
    {:ok, role}  = TestHelper.create_role(%{name: "user", admin: false})
    {:ok, role: role}
  end

  test "changeset with valid attributes", %{role: role} do
    changeset = User.changeset(%User{}, valid_attrs(role))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "password_digest value gets set to a hash" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password, Ecto.Changeset.get_change(changeset, :password_digest))
  end

  test "password_digest value does not get set if password is nil" do
    changeset = User.changeset(%User{}, %{email: "test@test.com", password: nil, password_confirmation: nil, username: "test"})
    refute Ecto.Changeset.get_change(changeset, :password_digest)
  end

  # private
  defp valid_attrs(role) do
    Map.put(@valid_attrs, :role_id, role.id)
  end
end
