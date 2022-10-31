defmodule PentoWeb.UserAuthLive do
  import Phoenix.LiveView
  alias Pento.Accounts
  require Logger

  def on_mount(_layout, _params, %{"user_token" => user_token} = _session, socket) do

    IO.puts("In on_mount")
    IO.puts("User token: #{inspect user_token}")
    user = Accounts.get_user_by_session_token(user_token)
    IO.puts("User: #{inspect user}")

    socket = socket |> assign_new(:current_user, fn -> user end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end
