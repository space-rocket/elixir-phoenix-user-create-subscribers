defmodule MyApp.BillingTest do
  use MyApp.DataCase

  alias MyApp.Billing

  describe "subscribers" do
    alias MyApp.Billing.Subscriber

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def subscriber_fixture(attrs \\ %{}) do
      {:ok, subscriber} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Billing.create_subscriber()

      subscriber
    end

    test "list_subscribers/0 returns all subscribers" do
      subscriber = subscriber_fixture()
      assert Billing.list_subscribers() == [subscriber]
    end

    test "get_subscriber!/1 returns the subscriber with given id" do
      subscriber = subscriber_fixture()
      assert Billing.get_subscriber!(subscriber.id) == subscriber
    end

    test "create_subscriber/1 with valid data creates a subscriber" do
      assert {:ok, %Subscriber{} = subscriber} = Billing.create_subscriber(@valid_attrs)
    end

    @tag :skip
    test "create_subscriber/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billing.create_subscriber(@invalid_attrs)
    end

    test "update_subscriber/2 with valid data updates the subscriber" do
      subscriber = subscriber_fixture()
      assert {:ok, %Subscriber{} = subscriber} = Billing.update_subscriber(subscriber, @update_attrs)
    end

    @tag :skip
    test "update_subscriber/2 with invalid data returns error changeset" do
      subscriber = subscriber_fixture()
      assert {:error, %Ecto.Changeset{}} = Billing.update_subscriber(subscriber, @invalid_attrs)
      assert subscriber == Billing.get_subscriber!(subscriber.id)
    end

    test "delete_subscriber/1 deletes the subscriber" do
      subscriber = subscriber_fixture()
      assert {:ok, %Subscriber{}} = Billing.delete_subscriber(subscriber)
      assert_raise Ecto.NoResultsError, fn -> Billing.get_subscriber!(subscriber.id) end
    end

    test "change_subscriber/1 returns a subscriber changeset" do
      subscriber = subscriber_fixture()
      assert %Ecto.Changeset{} = Billing.change_subscriber(subscriber)
    end
  end
end
