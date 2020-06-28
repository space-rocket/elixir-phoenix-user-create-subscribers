defmodule MyApp.Repo.Migrations.AddSubscriberIdToOrganizations do
  use Ecto.Migration

  def change do
    alter table(:orgs) do
      add :subscriber_id, references(:subscribers, on_delete: :delete_all), 
      null: false
    end

    create index(:orgs, [:subscriber_id])
  end
end
