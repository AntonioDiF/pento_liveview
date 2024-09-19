defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, score: 0, message: "Make a guess", correct_number: :rand.uniform(10))}
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    correct = correct_answer?(guess, socket.assigns.correct_number)
    message = "Your guess: #{guess}. #{get_message(correct)} "
    score = socket.assigns.score + get_score_change(correct)

    {:noreply, assign(socket, message: message, score: score)}
  end

  defp correct_answer?(guess, correct_number) do
    case Integer.parse(guess) do
      {value, _remainder} -> value == correct_number
      :error -> false
    end
  end

  defp get_message(correct_guess) do
    case(correct_guess) do
      true -> "Correct guess!"
      false -> "Wrong. Guess again."
    end
  end

  defp get_score_change(correct_guess) do
    case(correct_guess) do
      true -> 1
      false -> -1
    end
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <br />
    <h2>
      <%= for n <- 1..10 do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700
    text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    """
  end
end
