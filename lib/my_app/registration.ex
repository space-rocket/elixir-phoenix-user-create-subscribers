defmodule MyApp.Registration do
  @moduledoc """
  The Registration context.
  """
  alias Ecto.Multi
  alias MyApp.Repo
  alias MyApp.Billing
  alias MyApp.Subdomain.Accounts

  def register_user_subscriber(params) do
    Ecto.Multi.new()
    |> Multi.run(:user, fn _repo, _changes_so_far -> Accounts.register_user(params) end)
    |> Multi.run(:subscriber, fn _repo, %{user: user} ->
    	Ecto.Multi.new()
    	|> Multi.run(:subscriber, fn _repo, _changes_so_far -> Billing.register_subscriber(user, params) end)
	    |> Repo.transaction()
	    |> case do
	      {:ok, %{subscriber: subscriber}} -> {:ok, subscriber}
	      {:error, :subscriber, changeset, _} -> {:error, changeset}
	    end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

end
