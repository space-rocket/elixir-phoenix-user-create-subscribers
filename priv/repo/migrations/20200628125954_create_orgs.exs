defmodule MyApp.Repo.Migrations.CreateOrgs do
  use Ecto.Migration

  def change do
    create table(:orgs) do
      add :name, :string

      timestamps()
    end

    create unique_index(:orgs, [:name])
  end
end
