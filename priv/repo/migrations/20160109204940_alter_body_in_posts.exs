defmodule Potion.Repo.Migrations.AlterBodyInPosts do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify :body, :text
    end
  end
end
