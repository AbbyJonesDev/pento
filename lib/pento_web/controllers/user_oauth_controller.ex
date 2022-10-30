defmodule PentoWeb.UserOauthController do
  require Logger
  use PentoWeb, :controller
  alias Pento.Accounts
  alias PentoWeb.UserAuth
  plug Ueberauth
  @rand_pass_length 32

  def callback(%{assigns: %{ueberauth_auth: %{info: user_info}}} = conn, %{"provider" => "google"}) do
    user_params = %{email: user_info.email, password: random_password()}

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        UserAuth.log_in_user(conn, user)

      _ ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def callback(%{assigns: %{ueberauth_auth: %{info: user_info, extra: extra_info}}} = conn, %{
        "provider" => "okta"
      }) do
    Logger.debug("User info: #{inspect(user_info)}")
    Logger.debug("Extra info: #{inspect(extra_info)}")

    user_params = %{email: user_info.email, password: random_password()}

    case Accounts.fetch_or_create_user(user_params) do
      {:ok, user} ->
        UserAuth.log_in_user(conn, user)

      _ ->
        conn
        |> put_flash(:error, "Authentication failed")
        |> redirect(to: "/")
    end
  end

  def callback(conn, _params) do
    Logger.debug(inspect(conn.assigns))

    conn
    |> put_flash(:error, "Authentication failed")
    |> redirect(to: "/")
  end

  defp random_password do
    :crypto.strong_rand_bytes(@rand_pass_length) |> Base.encode64()
  end
end
