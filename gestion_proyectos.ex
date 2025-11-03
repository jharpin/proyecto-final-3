defmodule Hackathon.GestionProyectos do
  @moduledoc """
  Módulo para gestionar proyectos de la Hackathon
  """

  alias Hackathon.Structs.Proyecto

  @doc """
  Registra un nuevo proyecto para un equipo
  """
  def registrar_proyecto(proyectos, id, equipo_id, nombre, descripcion, categoria) do
    nuevo_proyecto = Proyecto.nuevo(id, equipo_id, nombre, descripcion, categoria)
    [nuevo_proyecto | proyectos]
  end

  @doc """
  Actualiza el avance de un proyecto usando recursividad
  """
  def actualizar_avance(proyectos, proyecto_id, avance) do
    actualizar_proyecto_recursivo(proyectos, proyecto_id, fn proyecto ->
      Proyecto.agregar_avance(proyecto, avance)
    end)
  end

  # Función recursiva privada para actualizar proyecto
  defp actualizar_proyecto_recursivo([], _id, _funcion), do: []

  defp actualizar_proyecto_recursivo([proyecto | resto], id, funcion) do
    if proyecto.id == id do
      [funcion.(proyecto) | resto]
    else
      [proyecto | actualizar_proyecto_recursivo(resto, id, funcion)]
    end
  end

  @doc """
  Agrega retroalimentación a un proyecto
  """
  def agregar_retroalimentacion(proyectos, proyecto_id, mentor_id, comentario) do
    actualizar_proyecto_recursivo(proyectos, proyecto_id, fn proyecto ->
      nueva_retro = %{
        mentor_id: mentor_id,
        comentario: comentario,
        timestamp: DateTime.utc_now()
      }
      %{proyecto | retroalimentacion: [nueva_retro | proyecto.retroalimentacion]}
    end)
  end

  @doc """
  Busca un proyecto por ID usando recursividad
  """
  def buscar_proyecto([], _id), do: nil

  def buscar_proyecto([proyecto | resto], id) do
    if proyecto.id == id do
      proyecto
    else
      buscar_proyecto(resto, id)
    end
  end

  @doc """
  Busca proyecto por equipo_id
  """
  def buscar_por_equipo([], _equipo_id), do: nil

  def buscar_por_equipo([proyecto | resto], equipo_id) do
    if proyecto.equipo_id == equipo_id do
      proyecto
    else
      buscar_por_equipo(resto, equipo_id)
    end
  end

  @doc """
  Consulta proyectos por categoría usando Enum
  """
  def consultar_por_categoria(proyectos, categoria) do
    proyectos
    |> Enum.filter(fn p -> p.categoria == categoria end)
    |> Enum.map(fn p ->
      %{
        id: p.id,
        nombre: p.nombre,
        equipo_id: p.equipo_id,
        estado: p.estado
      }
    end)
  end

  @doc """
  Consulta proyectos por estado usando recursividad
  """
  def consultar_por_estado(proyectos, estado) do
    filtrar_por_estado_recursivo(proyectos, estado, [])
  end

  # Función recursiva para filtrar por estado
  defp filtrar_por_estado_recursivo([], _estado, acumulador), do: Enum.reverse(acumulador)

  defp filtrar_por_estado_recursivo([proyecto | resto], estado, acumulador) do
    if proyecto.estado == estado do
      filtrar_por_estado_recursivo(resto, estado, [proyecto | acumulador])
    else
      filtrar_por_estado_recursivo(resto, estado, acumulador)
    end
  end

  @doc """
  Lista todos los avances de un proyecto
  """
  def listar_avances(proyectos, proyecto_id) do
    case buscar_proyecto(proyectos, proyecto_id) do
      nil -> {:error, "Proyecto no encontrado"}
      proyecto -> {:ok, proyecto.avances}
    end
  end

  @doc """
  Cuenta avances de forma recursiva
  """
  def contar_avances([]), do: 0
  def contar_avances([_avance | resto]) do
    1 + contar_avances(resto)
  end

  @doc """
  Obtiene resumen de todos los proyectos usando Enum
  """
  def resumen_proyectos(proyectos) do
    proyectos
    |> Enum.map(fn proyecto ->
      %{
        nombre: proyecto.nombre,
        categoria: proyecto.categoria,
        estado: proyecto.estado,
        total_avances: length(proyecto.avances),
        total_retroalimentacion: length(proyecto.retroalimentacion)
      }
    end)
  end

  @doc """
  Cambia el estado de un proyecto
  """
  def cambiar_estado(proyectos, proyecto_id, nuevo_estado) do
    actualizar_proyecto_recursivo(proyectos, proyecto_id, fn proyecto ->
      %{proyecto | estado: nuevo_estado}
    end)
  end

  @doc """
  Obtiene estadísticas de proyectos por categoría
  """
  def estadisticas_por_categoria(proyectos) do
    proyectos
    |> Enum.group_by(fn p -> p.categoria end)
    |> Enum.map(fn {categoria, lista_proyectos} ->
      {categoria, length(lista_proyectos)}
    end)
    |> Enum.into(%{})
  end
end
