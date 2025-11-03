defmodule Hackathon.Application do
  @moduledoc """
  Módulo de aplicación que inicia el supervisor principal
  """

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Iniciando sistema Hackathon Code4Future...")

    # Inicia el supervisor con todos los procesos
    Hackathon.Supervisor.start_link(name: Hackathon.Supervisor)
  end
end
