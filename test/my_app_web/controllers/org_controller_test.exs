defmodule MyAppWeb.OrgControllerTest do
  use MyAppWeb.ConnCase

  alias MyApp.Orgs

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:org) do
    {:ok, org} = Orgs.create_org(@create_attrs)
    org
  end

  setup :set_localhost
  
  describe "index" do
    test "lists all orgs", %{conn: conn} do
      conn = get(conn, Routes.org_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Orgs"
    end
  end

  describe "new org" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.org_path(conn, :new))
      assert html_response(conn, 200) =~ "New Org"
    end
  end

  describe "create org" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.org_path(conn, :create), org: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.org_path(conn, :show, id)

      conn = get(conn, Routes.org_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Org"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.org_path(conn, :create), org: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Org"
    end
  end

  describe "edit org" do
    setup [:create_org]

    test "renders form for editing chosen org", %{conn: conn, org: org} do
      conn = get(conn, Routes.org_path(conn, :edit, org))
      assert html_response(conn, 200) =~ "Edit Org"
    end
  end

  describe "update org" do
    setup [:create_org]

    test "redirects when data is valid", %{conn: conn, org: org} do
      conn = put(conn, Routes.org_path(conn, :update, org), org: @update_attrs)
      assert redirected_to(conn) == Routes.org_path(conn, :show, org)

      conn = get(conn, Routes.org_path(conn, :show, org))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, org: org} do
      conn = put(conn, Routes.org_path(conn, :update, org), org: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Org"
    end
  end

  describe "delete org" do
    setup [:create_org]

    test "deletes chosen org", %{conn: conn, org: org} do
      conn = delete(conn, Routes.org_path(conn, :delete, org))
      assert redirected_to(conn) == Routes.org_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.org_path(conn, :show, org))
      end
    end
  end

  defp create_org(_) do
    org = fixture(:org)
    %{org: org}
  end
end
