defmodule LiveChat.User do
  use GenServer

  # Démarre un utilisateur avec un nom donné
  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: via_tuple(name))
  end

  # Enregistre l'utilisateur dans la salle de chat
  def init(name) do
    LiveChat.ChatRoom.add_user(self())
    {:ok, name}
  end

  # Envoie un message à la salle de chat
  def send_message(name, message) do
    GenServer.cast(via_tuple(name), {:send_message, message})
  end

  # Reçoit un message de la salle de chat
  def handle_info({:new_message, message}, name) do
    IO.puts("#{name} a reçu un message: #{message}")
    {:noreply, name}
  end

  # Gestion du cast pour envoyer un message à la salle
  def handle_cast({:send_message, message}, name) do
    LiveChat.ChatRoom.broadcast_message(self(), "#{name}: #{message}")
    {:noreply, name}
  end

  defp via_tuple(name), do: {:via, Registry, {LiveChat.Registry, name}}
end
