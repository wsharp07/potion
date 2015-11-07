defmodule Potion.RoleChecker do
  alias Potion.Repo
  alias Potion.Role

  def is_admin?(user) do
    (role = Repo.get(Role, user.role_id)) && role.admin
  end
end
