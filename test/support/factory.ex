defmodule Potion.Factory do
  use ExMachina.Ecto, repo: Potion.Repo

  alias Potion.Role
  alias Potion.User
  alias Potion.Post

  def factory(:role) do
    %Role{
      name: sequence(:name, &"Test Role #{&1}"),
      admin: false
    }
  end

  def factory(:user) do
    %User{
      username: sequence(:username, &"User #{&1}"),
      first_name: "test",
      last_name: "user",
      email: "test@test.com",
      password: "test1234",
      password_confirmation: "test1234",
      password_digest: Comeonin.Bcrypt.hashpwsalt("test1234"),
      role: build(:role)
    }
  end

  def factory(:post) do
    %Post{
      title: "Some Post",
      body: "And the body of some post",
      user: build(:user)
    }
  end
end
