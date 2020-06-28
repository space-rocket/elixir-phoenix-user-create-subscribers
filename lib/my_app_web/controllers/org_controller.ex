defmodule MyAppWeb.OrgController do
  use MyAppWeb, :controller

  alias MyApp.Orgs
  alias MyApp.Orgs.Org

  plug :require_existing_subscriber
  plug :authorize_org when action in [:edit, :update, :delete]

  def index(conn, _params) do
    orgs = Orgs.list_orgs()
    render(conn, "index.html", orgs: orgs)
  end

  def new(conn, _params) do
    changeset = Orgs.change_org(%Org{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"org" => org_params}) do
    case Orgs.create_org(conn.assigns.current_subscriber, org_params) do
      {:ok, org} ->
        conn
        |> put_flash(:info, "Org created successfully.")
        |> redirect(to: Routes.org_path(conn, :show, org))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    org = Orgs.get_org!(id)
    render(conn, "show.html", org: org)
  end

  def edit(conn, _) do
    changeset = Orgs.change_org(conn.assigns.org)
    render(conn, "edit.html", changeset: changeset)
  end

  # def update(conn, %{"id" => id, "org" => org_params}) do
  def update(conn, %{"org" => org_params}) do
    case Orgs.update_org(conn.assigns.org, org_params) do
      {:ok, org} ->
        conn
        |> put_flash(:info, "Org updated successfully.")
        |> redirect(to: Routes.org_path(conn, :show, org))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    {:ok, _org} = Orgs.delete_org(conn.assigns.org)

    conn
    |> put_flash(:info, "Org deleted successfully.")
    |> redirect(to: Routes.org_path(conn, :index))
  end

  defp require_existing_subscriber(conn, _) do
    subscriber = Orgs.ensure_subscriber_exists(conn.assigns.current_user)
    assign(conn, :current_subscriber, subscriber)
  end

  defp authorize_org(conn, _) do
    org = Orgs.get_org!(conn.params["id"])

    if conn.assigns.current_subscriber.id == org.subscriber_id do
      assign(conn, :org, org)
    else
      conn
      |> put_flash(:error, "You can't modify that org")
      |> redirect(to: Routes.org_path(conn, :index))
      |> halt()
    end
  end
end
