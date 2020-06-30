defmodule MyApp.Billing.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset
  alias MyApp.Accounts.User

  schema "subscribers" do
    # field :user_id, :id
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
    |> unique_constraint(:user_id)
    |> foreign_key_constraint(:user_id)
  end
end
