defmodule Hackathon.ChatServer do
  @moduledoc """
  Servidor de chat usando GenServer para manejar mensajes concurrentemente
  """

  use GenServer
  alias Hackathon.Structs.Mensaje

  # Cliente API

  @doc """
  Inicia el servidor de chat
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, %{mensajes: [], salas: %{}}, opts)
  end

  @doc """
  Envía un mensaje a un equipo
  """
  def enviar_mensaje(pid, autor_id, contenido, destino, tipo \\ :equipo) do
    GenServer.call(pid, {:enviar_mensaje, autor_id, contenido, destino, tipo})
  end

  @doc """
  Obtiene mensajes de un equipo
  """
  def obtener_mensajes(pid, equipo_id) do
    GenServer.call(pid, {:obtener_mensajes, equipo_id})
  end

  @doc """
  Crea una sala temática
  """
  def crear_sala(pid, nombre_sala) do
    GenServer.call(pid, {:crear_sala, nombre_sala})
  end

  @doc """
  Lista todas las salas
  """
  def listar_salas(pid) do
    GenServer.call(pid, :listar_salas)
  end

  @doc """
  Obtiene mensajes del canal general
  """
  def obtener_anuncios(pid) do
    GenServer.call(pid, :obtener_anuncios)
  end

  # Callbacks del servidor

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:enviar_mensaje, autor_id, contenido, destino, tipo}, _from, state) do
    mensaje_id = generar_id()
    mensaje = Mensaje.nuevo(mensaje_id, autor_id, contenido, destino, tipo)

    nuevo_estado = %{state | mensajes: [mensaje | state.mensajes]}

    {:reply, {:ok, "Mensaje enviado"}, nuevo_estado}
  end

  @impl true
  def handle_call({:obtener_mensajes, equipo_id}, _from, state) do
    mensajes_equipo = filtrar_mensajes_recursivo(state.mensajes, equipo_id, [])
    {:reply, {:ok, mensajes_equipo}, state}
  end

  @impl true
  def handle_call({:crear_sala, nombre_sala}, _from, state) do
    nueva_sala = %{nombre: nombre_sala, mensajes: [], creado: DateTime.utc_now()}
    nuevas_salas = Map.put(state.salas, nombre_sala, nueva_sala)

    nuevo_estado = %{state | salas: nuevas_salas}
    {:reply, {:ok, "Sala creada"}, nuevo_estado}
  end

  @impl true
  def handle_call(:listar_salas, _from, state) do
    nombres_salas = Map.keys(state.salas)
    {:reply, {:ok, nombres_salas}, state}
  end

  @impl true
  def handle_call(:obtener_anuncios, _from, state) do
    anuncios = filtrar_por_tipo_recursivo(state.mensajes, :general, [])
    {:reply, {:ok, anuncios}, state}
  end

  # Funciones auxiliares privadas

  defp generar_id do
    :erlang.unique_integer([:positive])
  end

  # Filtrar mensajes de forma recursiva
  defp filtrar_mensajes_recursivo([], _equipo_id, acumulador), do: Enum.reverse(acumulador)

  defp filtrar_mensajes_recursivo([mensaje | resto], equipo_id, acumulador) do
    if mensaje.destino == equipo_id and mensaje.tipo == :equipo do
      filtrar_mensajes_recursivo(resto, equipo_id, [mensaje | acumulador])
    else
      filtrar_mensajes_recursivo(resto, equipo_id, acumulador)
    end
  end

  # Filtrar por tipo de forma recursiva
  defp filtrar_por_tipo_recursivo([], _tipo, acumulador), do: Enum.reverse(acumulador)

  defp filtrar_por_tipo_recursivo([mensaje | resto], tipo, acumulador) do
    if mensaje.tipo == tipo do
      filtrar_por_tipo_recursivo(resto, tipo, [mensaje | acumulador])
    else
      filtrar_por_tipo_recursivo(resto, tipo, acumulador)
    end
  end
end
