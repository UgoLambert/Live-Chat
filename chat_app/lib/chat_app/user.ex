defmodule LiveChat.User do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  def init(name) do
    Registry.register(LiveChat.Registry, "users", name)
    {:ok, name}
  end

  def send_message(name, message) do
    GenServer.cast(via_tuple(name), {:send_message, message})
  end

  def handle_cast({:send_message, message}, name) do
    LiveChat.ChatRoom.broadcast_message(name, message)
    {:noreply, name}
  end

  defp via_tuple(name), do: {:via, Registry, {LiveChat.Registry, {:user, name}}}
end
