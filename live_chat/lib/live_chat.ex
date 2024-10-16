defmodule LiveChat do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: LiveChat.Registry},
      {LiveChat.ChatRoom, []}
    ]

    opts = [strategy: :one_for_one, name: LiveChat.Supervisor]
    Supervisor.start_link(children, opts)
    IO.puts("Serveur started")
  end
end
