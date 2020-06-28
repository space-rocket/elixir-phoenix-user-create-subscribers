defmodule MyApp.Billing.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Orgs.Org
  alias MyApp.Accounts.User

  schema "subscribers" do
    has_many :orgs, Org
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, [])
    |> validate_required([])
    |> unique_constraint(:user_id)
  end
end
