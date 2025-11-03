defmodule Hackathon.Mentoria do
  @moduledoc """
  Módulo para gestionar mentores y consultas
  """

  alias Hackathon.Structs.Mentor

  @doc """
  Registra un nuevo mentor
  """
  def registrar_mentor(mentores, id, nombre, especialidad) do
    nuevo_mentor = Mentor.nuevo(id, nombre, especialidad)
    [nuevo_mentor | mentores]
  end

  @doc """
  Asigna un equipo a un mentor usando recursividad
  """
  def asignar_equipo(mentores, mentor_id, equipo_id) do
    actualizar_mentor_recursivo(mentores, mentor_id, fn mentor ->
      %{mentor | equipos_asignados: [equipo_id | mentor.equipos_asignados]}
    end)
  end

  # Función recursiva privada para actualizar mentor
  defp actualizar_mentor_recursivo([], _id, _funcion), do: []

  defp actualizar_mentor_recursivo([mentor | resto], id, funcion) do
    if mentor.id == id do
      [funcion.(mentor) | resto]
    else
      [mentor | actualizar_mentor_recursivo(resto, id, funcion)]
    end
  end

  @doc """
  Busca un mentor por ID
  """
  def buscar_mentor([], _id), do: nil

  def buscar_mentor([mentor | resto], id) do
    if mentor.id == id do
      mentor
    else
      buscar_mentor(resto, id)
    end
  end

  @doc """
  Lista mentores por especialidad usando Enum
  """
  def buscar_por_especialidad(mentores, especialidad) do
    mentores
    |> Enum.filter(fn m -> m.especialidad == especialidad end)
    |> Enum.map(fn m ->
      %{id: m.id, nombre: m.nombre, equipos: length(m.equipos_asignados)}
    end)
  end

  @doc """
  Obtiene todos los equipos asignados a un mentor
  """
  def equipos_del_mentor(mentores, mentor_id) do
    case buscar_mentor(mentores, mentor_id) do
      nil -> {:error, "Mentor no encontrado"}
      mentor -> {:ok, mentor.equipos_asignados}
    end
  end

  @doc """
  Lista todos los mentores con sus cargas de trabajo
  """
  def resumen_mentores(mentores) do
    mentores
    |> Enum.map(fn mentor ->
      %{
        nombre: mentor.nombre,
        especialidad: mentor.especialidad,
        equipos_asignados: length(mentor.equipos_asignados)
      }
    end)
  end

  @doc """
  Encuentra el mentor con menos carga usando recursividad
  """
  def mentor_con_menos_carga(mentores) do
    encontrar_menor_carga_recursivo(mentores, nil, 999999)
  end

  # Función recursiva para encontrar mentor con menos carga
  defp encontrar_menor_carga_recursivo([], mejor_mentor, _menor_carga), do: mejor_mentor

  defp encontrar_menor_carga_recursivo([mentor | resto], mejor_mentor, menor_carga) do
    carga_actual = length(mentor.equipos_asignados)

    if carga_actual < menor_carga do
      encontrar_menor_carga_recursivo(resto, mentor, carga_actual)
    else
      encontrar_menor_carga_recursivo(resto, mejor_mentor, menor_carga)
    end
  end

  @doc """
  Verifica si un mentor puede tomar más equipos (máximo 5)
  """
  def puede_tomar_equipo?(mentores, mentor_id) do
    case buscar_mentor(mentores, mentor_id) do
      nil -> false
      mentor -> length(mentor.equipos_asignados) < 5
    end
  end
end
