defmodule MyApp.Orgs.Org do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Billing.Subscriber

  schema "orgs" do
    field :name, :string
    belongs_to :subscriber, Subscriber

    timestamps()
  end

  @doc false
  def changeset(org, attrs) do
    org
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
