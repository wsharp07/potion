defmodule Potion.RoleCheckerTest do
  use Potion.ModelCase
  alias Potion.Factory
  alias Potion.RoleChecker

  setup do
    admin_role = Factory.insert(:role, admin: true)
    user_role = Factory.insert(:role, admin: false)
    admin_user = Factory.insert(:user, role: admin_role)
    regular_user = Factory.insert(:user, role: user_role)
    {:ok, admin_user: admin_user, regular_user: regular_user}
  end

  test "is_admin? is true when user has an admin role", %{ admin_user: admin_user} do
    assert RoleChecker.is_admin?(admin_user)
  end

  test "is_admin? is false when user does not have an admin role", %{ regular_user: regular_user } do
    refute RoleChecker.is_admin?(regular_user)
  end
end
