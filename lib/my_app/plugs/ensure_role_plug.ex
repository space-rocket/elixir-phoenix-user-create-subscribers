defmodule MyApp.Plug.EnsureRole do
  @moduledoc """
  This plug ensures that a user has a particular role.

  ## Example

      plug MyAppWeb.EnsureRolePlug, [:user, :admin]

      plug MyAppWeb.EnsureRolePlug, :admin

      plug MyAppWeb.EnsureRolePlug, ~w(user admin)a
  """
  import Plug.Conn, only: [halt: 1]
  alias MyAppWeb.Router.Helpers, as: Routes
  alias Phoenix.Controller

  @doc false
  def init(config), do: config

  @doc false
  def call(conn, roles) do
    conn
    |> current_user
    |> has_role?(roles)
    |> maybe_halt(conn)
  end

  defp current_user(conn) do
    conn.assigns.current_user
  end
  defp has_role?(nil, _roles), do: false
  defp has_role?(user, roles) when is_list(roles), do: Enum.any?(roles, &has_role?(user, &1))
  defp has_role?(user, role) when is_atom(role), do: has_role?(user, Atom.to_string(role))
  defp has_role?(%{role: role}, role), do: true
  defp has_role?(_user, _role), do: false

  defp maybe_halt(true, conn), do: conn
  defp maybe_halt(_any, conn) do
    conn
    |> Controller.put_flash(:error, "Unauthorized access")
    |> Controller.redirect(to: Routes.page_path(conn, :index))
    |> halt()
  end
end