defmodule Hackathon.Utilidades do
  @moduledoc """
  Módulo con funciones de utilidad usando recursividad y Enum
  """

  @doc """
  Genera estadísticas del sistema de forma recursiva
  """
  def estadisticas_sistema(participantes, equipos, proyectos) do
    %{
      total_participantes: contar_recursivo(participantes),
      total_equipos: contar_recursivo(equipos),
      total_proyectos: contar_recursivo(proyectos),
      participantes_sin_equipo: contar_sin_equipo(participantes),
      equipos_sin_proyecto: contar_equipos_sin_proyecto(equipos, proyectos)
    }
  end

  @doc """
  Cuenta elementos de una lista de forma recursiva
  """
  def contar_recursivo([]), do: 0
  def contar_recursivo([_elemento | resto]) do
    1 + contar_recursivo(resto)
  end

  @doc """
  Cuenta participantes sin equipo de forma recursiva
  """
  def contar_sin_equipo([]), do: 0
  def contar_sin_equipo([participante | resto]) do
    if participante.equipo_id == nil do
      1 + contar_sin_equipo(resto)
    else
      contar_sin_equipo(resto)
    end
  end

  @doc """
  Cuenta equipos sin proyecto
  """
  def contar_equipos_sin_proyecto(equipos, proyectos) do
    equipos_con_proyecto = obtener_equipos_con_proyecto(proyectos, [])
    contar_equipos_sin_proyecto_recursivo(equipos, equipos_con_proyecto)
  end

  # Función auxiliar recursiva
  defp obtener_equipos_con_proyecto([], acumulador), do: acumulador
  defp obtener_equipos_con_proyecto([proyecto | resto], acumulador) do
    obtener_equipos_con_proyecto(resto, [proyecto.equipo_id | acumulador])
  end

  defp contar_equipos_sin_proyecto_recursivo([], _equipos_con_proyecto), do: 0
  defp contar_equipos_sin_proyecto_recursivo([equipo | resto], equipos_con_proyecto) do
    if equipo.id in equipos_con_proyecto do
      contar_equipos_sin_proyecto_recursivo(resto, equipos_con_proyecto)
    else
      1 + contar_equipos_sin_proyecto_recursivo(resto, equipos_con_proyecto)
    end
  end

  @doc """
  Valida email usando pattern matching
  """
  def validar_email(email) do
    case String.split(email, "@") do
      [_usuario, dominio] when byte_size(dominio) > 0 -> true
      _ -> false
    end
  end

  @doc """
  Genera reporte en texto usando recursividad
  """
  def generar_reporte(equipos, proyectos) do
    IO.puts("\n" <> String.duplicate("=", 50))
    IO.puts("REPORTE DE LA HACKATHON CODE4FUTURE")
    IO.puts(String.duplicate("=", 50) <> "\n")

    IO.puts("Total de equipos: #{length(equipos)}")
    IO.puts("Total de proyectos: #{length(proyectos)}\n")

    IO.puts("Detalle de equipos:")
    generar_reporte_equipos_recursivo(equipos, proyectos, 1)

    IO.puts("\n" <> String.duplicate("=", 50))
  end

  # Función recursiva para generar reporte de equipos
  defp generar_reporte_equipos_recursivo([], _proyectos, _contador), do: :ok

  defp generar_reporte_equipos_recursivo([equipo | resto], proyectos, contador) do
    proyecto = buscar_proyecto_por_equipo(proyectos, equipo.id)

    IO.puts("\n#{contador}. Equipo: #{equipo.nombre}")
    IO.puts("   Tema: #{equipo.tema}")
    IO.puts("   Miembros: #{length(equipo.miembros)}")

    case proyecto do
      nil -> IO.puts("   Proyecto: No registrado")
      p ->
        IO.puts("   Proyecto: #{p.nombre}")
        IO.puts("   Categoría: #{p.categoria}")
        IO.puts("   Avances: #{length(p.avances)}")
    end

    generar_reporte_equipos_recursivo(resto, proyectos, contador + 1)
  end

  # Buscar proyecto por equipo (recursivo)
  defp buscar_proyecto_por_equipo([], _equipo_id), do: nil
  defp buscar_proyecto_por_equipo([proyecto | resto], equipo_id) do
    if proyecto.equipo_id == equipo_id do
      proyecto
    else
      buscar_proyecto_por_equipo(resto, equipo_id)
    end
  end

  @doc """
  Filtra y mapea elementos usando Enum
  """
  def proyectos_activos(proyectos) do
    proyectos
    |> Enum.filter(fn p -> p.estado == :en_progreso end)
    |> Enum.map(fn p ->
      %{nombre: p.nombre, categoria: p.categoria, equipo: p.equipo_id}
    end)
  end

  @doc """
  Calcula promedio de miembros por equipo
  """
  def promedio_miembros(equipos) do
    if length(equipos) == 0 do
      0
    else
      total_miembros = sumar_miembros_recursivo(equipos)
      total_miembros / length(equipos)
    end
  end

  # Suma miembros de forma recursiva
  defp sumar_miembros_recursivo([]), do: 0
  defp sumar_miembros_recursivo([equipo | resto]) do
    length(equipo.miembros) + sumar_miembros_recursivo(resto)
  end

  @doc """
  Ordena equipos por cantidad de miembros usando Enum
  """
  def ordenar_por_miembros(equipos) do
    Enum.sort_by(equipos, fn equipo -> length(equipo.miembros) end, :desc)
  end

  @doc """
  Genera ID único
  """
  def generar_id do
    :erlang.unique_integer([:positive])
  end

  @doc """
  Formatea fecha y hora
  """
  def formatear_timestamp(datetime) do
    datetime
    |> DateTime.truncate(:second)
    |> DateTime.to_string()
  end
end
