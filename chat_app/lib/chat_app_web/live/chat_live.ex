defmodule ChatAppWeb.ChatLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, messages: [], user: "", new_message: "")}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    new_message = %{user: socket.assigns.user, body: message}
    # Appelle ici ton GenServer pour stocker le message
    {:noreply, assign(socket, messages: [new_message | socket.assigns.messages], new_message: "")}
  end

  def handle_event("set_user", %{"user" => user}, socket) do
    {:noreply, assign(socket, user: user)}
  end
end
