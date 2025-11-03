defmodule Hackathon.Supervisor do
  @moduledoc """
  Supervisor principal del sistema de Hackathon
  Reinicia procesos automáticamente si fallan
  """

  use Supervisor

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      # Sistema principal
      {Hackathon.Sistema, name: Hackathon.Sistema},

      # Servidor de chat
      {Hackathon.ChatServer, name: Hackathon.ChatServer}
    ]

    # Estrategia: one_for_one reinicia solo el proceso que falló
    # max_restarts: 5 reinicios en max_seconds: 60 segundos
    Supervisor.init(children, strategy: :one_for_one, max_restarts: 5, max_seconds: 60)
  end
end
