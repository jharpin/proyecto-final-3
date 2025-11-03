defmodule Hackathon.GestionEquipos do
  @moduledoc """
  Módulo para gestionar equipos de la Hackathon
  Usa recursividad y Enum para operaciones sobre listas
  """

  alias Hackathon.Structs.{Equipo, Participante}

  @doc """
  Registra un nuevo participante
  """
  def registrar_participante(participantes, id, nombre, email) do
    nuevo_participante = Participante.nuevo(id, nombre, email)
    [nuevo_participante | participantes]
  end

  @doc """
  Crea un nuevo equipo
  """
  def crear_equipo(equipos, id, nombre, tema) do
    nuevo_equipo = Equipo.nuevo(id, nombre, tema)
    [nuevo_equipo | equipos]
  end

  @doc """
  Asigna un participante a un equipo
  Usa recursividad para buscar y actualizar
  """
  def asignar_a_equipo(equipos, participantes, participante_id, equipo_id) do
    # Actualizar equipo
    equipos_actualizados = actualizar_equipo_recursivo(equipos, equipo_id, participante_id)

    # Actualizar participante
    participantes_actualizados = actualizar_participante_recursivo(participantes, participante_id, equipo_id)

    {equipos_actualizados, participantes_actualizados}
  end

  # Función recursiva privada para actualizar equipo
  defp actualizar_equipo_recursivo([], _equipo_id, _participante_id), do: []

  defp actualizar_equipo_recursivo([equipo | resto], equipo_id, participante_id) do
    if equipo.id == equipo_id do
      equipo_actualizado = Equipo.agregar_miembro(equipo, participante_id)
      [equipo_actualizado | resto]
    else
      [equipo | actualizar_equipo_recursivo(resto, equipo_id, participante_id)]
    end
  end

  # Función recursiva privada para actualizar participante
  defp actualizar_participante_recursivo([], _participante_id, _equipo_id), do: []

  defp actualizar_participante_recursivo([participante | resto], participante_id, equipo_id) do
    if participante.id == participante_id do
      participante_actualizado = %{participante | equipo_id: equipo_id}
      [participante_actualizado | resto]
    else
      [participante | actualizar_participante_recursivo(resto, participante_id, equipo_id)]
    end
  end

  @doc """
  Lista todos los equipos activos usando Enum
  """
  def listar_equipos_activos(equipos) do
    equipos
    |> Enum.filter(fn equipo -> equipo.activo end)
    |> Enum.map(fn equipo ->
      %{
        id: equipo.id,
        nombre: equipo.nombre,
        tema: equipo.tema,
        cantidad_miembros: length(equipo.miembros)
      }
    end)
  end

  @doc """
  Busca un equipo por ID usando recursividad
  """
  def buscar_equipo([], _id), do: nil

  def buscar_equipo([equipo | resto], id) do
    if equipo.id == id do
      equipo
    else
      buscar_equipo(resto, id)
    end
  end

  @doc """
  Busca equipos por tema usando Enum.filter
  """
  def buscar_por_tema(equipos, tema) do
    Enum.filter(equipos, fn equipo -> equipo.tema == tema end)
  end

  @doc """
  Cuenta participantes en un equipo de forma recursiva
  """
  def contar_miembros_recursivo([]), do: 0
  def contar_miembros_recursivo([_miembro | resto]) do
    1 + contar_miembros_recursivo(resto)
  end

  @doc """
  Obtiene información detallada de un equipo
  """
  def info_equipo(equipos, participantes, equipo_id) do
    equipo = buscar_equipo(equipos, equipo_id)

    case equipo do
      nil -> {:error, "Equipo no encontrado"}
      equipo ->
        miembros_info = obtener_info_miembros(participantes, equipo.miembros)

        {:ok, %{
          nombre: equipo.nombre,
          tema: equipo.tema,
          miembros: miembros_info,
          total_miembros: length(miembros_info)
        }}
    end
  end

  # Función auxiliar recursiva para obtener info de miembros
  defp obtener_info_miembros(participantes, ids_miembros) do
    Enum.map(ids_miembros, fn id ->
      participante = buscar_participante_recursivo(participantes, id)
      case participante do
        nil -> %{id: id, nombre: "Desconocido"}
        p -> %{id: p.id, nombre: p.nombre, email: p.email}
      end
    end)
  end

  # Buscar participante de forma recursiva
  defp buscar_participante_recursivo([], _id), do: nil
  defp buscar_participante_recursivo([participante | resto], id) do
    if participante.id == id do
      participante
    else
      buscar_participante_recursivo(resto, id)
    end
  end
end
