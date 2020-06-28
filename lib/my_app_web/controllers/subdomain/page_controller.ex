defmodule MyAppWeb.Subdomain.PageController do
  use MyAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", subdomain: conn.private[:subdomain])
  end
end
