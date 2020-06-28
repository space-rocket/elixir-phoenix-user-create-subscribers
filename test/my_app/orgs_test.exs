defmodule MyApp.OrgsTest do
  use MyApp.DataCase

  alias MyApp.Orgs

  describe "orgs" do
    alias MyApp.Orgs.Org

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def org_fixture(attrs \\ %{}) do
      {:ok, org} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Orgs.create_org()

      org
    end

    test "list_orgs/0 returns all orgs" do
      org = org_fixture()
      assert Orgs.list_orgs() == [org]
    end

    test "get_org!/1 returns the org with given id" do
      org = org_fixture()
      assert Orgs.get_org!(org.id) == org
    end

    test "create_org/1 with valid data creates a org" do
      assert {:ok, %Org{} = org} = Orgs.create_org(@valid_attrs)
      assert org.name == "some name"
    end

    test "create_org/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orgs.create_org(@invalid_attrs)
    end

    test "update_org/2 with valid data updates the org" do
      org = org_fixture()
      assert {:ok, %Org{} = org} = Orgs.update_org(org, @update_attrs)
      assert org.name == "some updated name"
    end

    test "update_org/2 with invalid data returns error changeset" do
      org = org_fixture()
      assert {:error, %Ecto.Changeset{}} = Orgs.update_org(org, @invalid_attrs)
      assert org == Orgs.get_org!(org.id)
    end

    test "delete_org/1 deletes the org" do
      org = org_fixture()
      assert {:ok, %Org{}} = Orgs.delete_org(org)
      assert_raise Ecto.NoResultsError, fn -> Orgs.get_org!(org.id) end
    end

    test "change_org/1 returns a org changeset" do
      org = org_fixture()
      assert %Ecto.Changeset{} = Orgs.change_org(org)
    end
  end
end
