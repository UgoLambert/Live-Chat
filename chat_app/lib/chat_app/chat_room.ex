defmodule LiveChat.ChatRoom do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    {:ok, []}
  end

  def broadcast_message(name, message) do
    GenServer.cast(__MODULE__, {:broadcast_message, name, message})
  end

  def get_messages do
    GenServer.call(__MODULE__, :get_messages)
  end

  def handle_cast({:add_user}, messages) do
    {:noreply, messages}
  end

  def handle_cast({:broadcast_message, name, message}, messages) do
    new_message = %{
      user: name,
      body: message,
      timestamp: DateTime.utc_now()
    }

    Phoenix.PubSub.broadcast(ChatApp.PubSub, "chat", {:new_message, name})
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end
end
