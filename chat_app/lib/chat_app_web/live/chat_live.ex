defmodule ChatAppWeb.ChatLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, messages: [], user: "", new_message: "")}
  end

  def handle_event("set_user", %{"user" => user}, socket) do
    LiveChat.User.start_link(user)
    if connected?(socket) do
      Phoenix.PubSub.subscribe(ChatApp.PubSub, "chat")
    end
    {:noreply, assign(socket, messages: LiveChat.ChatRoom.get_messages(), user: user)}
  end

  def handle_event("send_message", %{"message" => message}, socket) do
    LiveChat.User.send_message(socket.assigns.user, message)
    {:noreply, assign(socket, messages: LiveChat.ChatRoom.get_messages(), new_message: "")}
  end

  # Event PubSub
  def handle_info({:new_message, _name}, socket) do
    {:noreply, assign(socket, messages: LiveChat.ChatRoom.get_messages())}
  end

end
