defmodule PentoWeb.UserAuthLive do
  import Phoenix.LiveView
  require Logger

  def on_mount(
        _layout,
        _params,
        %{"user_token" => user_token, "current_user" => current_user} = session,
        socket
      ) do
    IO.puts("In on_mount")
    IO.puts("User token: #{inspect(user_token)}")
    IO.puts("Current user: #{inspect(current_user)}")

    if user_token do
      socket = assign_new(socket, :current_user, fn -> current_user end)
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/auth/okta")}
    end
  end
end
