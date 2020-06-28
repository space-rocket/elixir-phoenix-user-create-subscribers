defmodule MyApp.Orgs do
  @moduledoc """
  The Orgs context.
  """

  import Ecto.Query, warn: false
  alias MyApp.Repo

  alias MyApp.Orgs.Org
  alias MyApp.Billing.Subscriber

  @doc """
  Returns the list of orgs.

  ## Examples

      iex> list_orgs()
      [%Org{}, ...]

  """
  def list_orgs do
    Org
    |> Repo.all()
    # |> Repo.preload(subscriber: [:user])
  end

  @doc """
  Gets a single org.

  Raises `Ecto.NoResultsError` if the Org does not exist.

  ## Examples

      iex> get_org!(123)
      %Org{}

      iex> get_org!(456)
      ** (Ecto.NoResultsError)

  """
  def get_org!(id) do 
    Org
    |> Repo.get!(id)
    |> Repo.preload(subscriber: [:user])
  end

  @doc """
  Creates a org.

  ## Examples

      iex> create_org(%{field: value})
      {:ok, %Org{}}

      iex> create_org(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_org(%Subscriber{} = subscriber, attrs \\ %{}) do
    %Org{}
    |> Org.changeset(attrs)
    |> Ecto.Changeset.put_change(:subscriber_id, subscriber.id)
    |> Repo.insert()
  end

  def ensure_subscriber_exists(%MyApp.Accounts.User{} = user) do
    IO.inspect("🚌 user")
    IO.inspect(user)
    %Subscriber{user_id: user.id}
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.unique_constraint(:user_id)
    |> Repo.insert()
    |> handle_existing_subscriber()
  end
  defp handle_existing_subscriber({:ok, subscriber}), do: subscriber
  defp handle_existing_subscriber({:error, changeset}) do
    Repo.get_by!(Subscriber, user_id: changeset.data.user_id)
  end
  @doc """
  Updates a org.

  ## Examples

      iex> update_org(org, %{field: new_value})
      {:ok, %Org{}}

      iex> update_org(org, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_org(%Org{} = org, attrs) do
    org
    |> Org.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a org.

  ## Examples

      iex> delete_org(org)
      {:ok, %Org{}}

      iex> delete_org(org)
      {:error, %Ecto.Changeset{}}

  """
  def delete_org(%Org{} = org) do
    Repo.delete(org)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking org changes.

  ## Examples

      iex> change_org(org)
      %Ecto.Changeset{data: %Org{}}

  """
  def change_org(%Org{} = org, attrs \\ %{}) do
    Org.changeset(org, attrs)
  end
end
