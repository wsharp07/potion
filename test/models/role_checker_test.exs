defmodule Potion.RoleCheckerTest do
  use Potion.ModelCase
  alias Potion.Factory
  alias Potion.RoleChecker

  test "is_admin? is true when user has an admin role" do
    role = Factory.create(:role, %{admin: true})
    user = Factory.create(:user, %{role: role})
    assert RoleChecker.is_admin?(user)
  end

  test "is_admin? is false when user does not have an admin role" do
    role = Factory.create(:role, %{admin: false})
    user = Factory.create(:user, %{role: role})
    refute RoleChecker.is_admin?(user)
  end
end
