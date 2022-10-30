defmodule PentoWeb.UserAuthLive do
  require Logger
  import Phoenix.LiveView
  # alias Pento.Accounts

  def on_mount(_, _params, session, socket) do
    # user = Accounts.get_user_by_session_token(user_token)
    # socket = socket |> assign_new(:current_user, fn -> user end)

    Logger.debug("Session: #{inspect session}")


    if socket.assigns[:current_user] do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/auth/okta")}
    end
  end
end
