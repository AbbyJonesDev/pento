defmodule PentoWeb.WrongLive do
  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  def mount(_params, _session, socket) do
    random_number = :rand.uniform(10)

    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess: ",
        time: time(),
        correct_answer: random_number
      )
    }
  end

  def render(assigns) do
    ~H"""
      <h1>Your score: <%= @score %></h1>
      <h2>
        <%= @message %>
        It's <%= @time %>
      </h2>

      <h2>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number={n}>
            <%= n %>
          </a>
        <% end %>
      </h2>
    """
  end

  def handle_event("guess", %{"number" => guess} = data, socket) do
    success = guess == to_string(socket.assigns.correct_answer)

    messages = %{
      success: "Correct!",
      incorrect: "Your guess: #{guess}.  Wrong.  Guess again."
    }

    {score, message} =
      if success do
        {socket.assigns.score, Map.get(messages, :success)}
      else
        {socket.assigns.score - 1, Map.get(messages, :incorrect)}
      end

    time = time()

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        time: time
      )
    }
  end

  def time() do
    DateTime.utc_now() |> to_string()
  end
end
