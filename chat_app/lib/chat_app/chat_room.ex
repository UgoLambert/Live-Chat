defmodule LiveChat.ChatRoom do
  use GenServer

  # Démarre le GenServer avec un état initial vide
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Callback de démarrage
  def init(state) do
    {:ok, state}
  end

  # Fonction pour ajouter un utilisateur à la salle de chat
  def add_user(user_pid) do
    GenServer.cast(__MODULE__, {:add_user, user_pid})
  end

  # Fonction pour envoyer un message à tous les utilisateurs
  def broadcast_message(from_pid, message) do
    GenServer.cast(__MODULE__, {:broadcast_message, from_pid, message})
  end

  # Handle cast pour ajouter un utilisateur
  def handle_cast({:add_user, user_pid}, state) do
    {:noreply, Map.put(state, user_pid, true)}
  end

  # Handle cast pour diffuser un message à tous les utilisateurs
  def handle_cast({:broadcast_message, from_pid, message}, state) do
    for {user_pid, _} <- state do
      if user_pid != from_pid do
        send(user_pid, {:new_message, message})
      end
    end
    {:noreply, state}
  end
end
