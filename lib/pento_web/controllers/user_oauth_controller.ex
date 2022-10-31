defmodule PentoWeb.UserOauthController do
  require Logger
  use PentoWeb, :controller
  alias PentoWeb.UserAuth
  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: %{info: user_info, extra: _extra_info}}} = conn, %{
        "provider" => "okta"
      }) do
    # Logger.debug("User info: #{inspect(user_info)}")
    # Logger.debug("Extra info: #{inspect(extra_info)}")

    user = %{email: user_info.email}
    UserAuth.log_in_user(conn, user)
  end

  def callback(conn, _params) do
    Logger.debug(inspect(conn.assigns))

    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end
end
