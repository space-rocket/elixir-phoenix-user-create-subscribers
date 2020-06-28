defmodule MyAppWeb.OrgController do
  use MyAppWeb, :controller

  alias MyApp.Orgs
  alias MyApp.Orgs.Org

  def index(conn, _params) do
    orgs = Orgs.list_orgs()
    render(conn, "index.html", orgs: orgs)
  end

  def new(conn, _params) do
    changeset = Orgs.change_org(%Org{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"org" => org_params}) do
    case Orgs.create_org(org_params) do
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

  def edit(conn, %{"id" => id}) do
    org = Orgs.get_org!(id)
    changeset = Orgs.change_org(org)
    render(conn, "edit.html", org: org, changeset: changeset)
  end

  def update(conn, %{"id" => id, "org" => org_params}) do
    org = Orgs.get_org!(id)

    case Orgs.update_org(org, org_params) do
      {:ok, org} ->
        conn
        |> put_flash(:info, "Org updated successfully.")
        |> redirect(to: Routes.org_path(conn, :show, org))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", org: org, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    org = Orgs.get_org!(id)
    {:ok, _org} = Orgs.delete_org(org)

    conn
    |> put_flash(:info, "Org deleted successfully.")
    |> redirect(to: Routes.org_path(conn, :index))
  end
end
