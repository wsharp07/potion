alias Potion.Repo
alias Potion.Role
alias Potion.User
import Ecto.Query, only: [from: 2]

find_or_create_role = fn role_name, admin ->
  case Repo.all(from r in Role, where: r.name == ^role_name and r.admin == ^admin) do
    [] ->
      %Role{}
      |> Role.changeset(%{name: role_name, admin: admin})
      |> Repo.insert!()
    _ ->
      IO.puts "Role: #{role_name} already exists, skipping"
  end
end

find_or_create_user = fn first_name, last_name, username, email, role ->
  case Repo.all(from u in User, where: u.username == ^username and u.email == ^email) do
    [] ->
      %User{}
      |> User.changeset(%{first_name: first_name, last_name: last_name, username: username, email: email, password: "test", password_confirmation: "test", role_id: role.id})
      |> Repo.insert!()
    _ ->
      IO.puts "User: #{username} already exists, skipping"
  end
end

_user_role  = find_or_create_role.("User Role", false)
admin_role  = find_or_create_role.("Admin Role", true)
_admin_user = find_or_create_user.("Super", "User", "admin", "admin@test.com", admin_role)
