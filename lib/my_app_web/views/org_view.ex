defmodule MyAppWeb.OrgView do
  use MyAppWeb, :view

  alias MyApp.Orgs.Org

  def subscriber_email(%Org{subscriber: subscriber}) do
  	subscriber.user.email
  end
end
