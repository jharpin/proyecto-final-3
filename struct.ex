defmodule Hackathon.Structs do
  @moduledoc """
  Módulo con las estructuras de datos del sistema de Hackathon
  """

  # Estructura para representar un participante
  defmodule Participante do
    defstruct [:id, :nombre, :email, :equipo_id]

    @doc """
    Crea un nuevo participante
    """
    def nuevo(id, nombre, email) do
      %Participante{
        id: id,
        nombre: nombre,
        email: email,
        equipo_id: nil
      }
    end
  end

  # Estructura para representar un equipo
  defmodule Equipo do
    defstruct [:id, :nombre, :tema, :miembros, :proyecto_id, :activo]

    @doc """
    Crea un nuevo equipo
    """
    def nuevo(id, nombre, tema) do
      %Equipo{
        id: id,
        nombre: nombre,
        tema: tema,
        miembros: [],
        proyecto_id: nil,
        activo: true
      }
    end

    @doc """
    Agrega un miembro al equipo
    """
    def agregar_miembro(equipo, participante_id) do
      %{equipo | miembros: [participante_id | equipo.miembros]}
    end
  end

  # Estructura para representar un proyecto
  defmodule Proyecto do
    defstruct [:id, :equipo_id, :nombre, :descripcion, :categoria, :avances, :estado, :retroalimentacion]

    @doc """
    Crea un nuevo proyecto
    """
    def nuevo(id, equipo_id, nombre, descripcion, categoria) do
      %Proyecto{
        id: id,
        equipo_id: equipo_id,
        nombre: nombre,
        descripcion: descripcion,
        categoria: categoria,
        avances: [],
        estado: :en_progreso,
        retroalimentacion: []
      }
    end

    @doc """
    Agrega un avance al proyecto
    """
    def agregar_avance(proyecto, avance) do
      nuevo_avance = %{
        texto: avance,
        timestamp: DateTime.utc_now()
      }
      %{proyecto | avances: [nuevo_avance | proyecto.avances]}
    end
  end

  # Estructura para representar un mensaje
  defmodule Mensaje do
    defstruct [:id, :autor_id, :contenido, :destino, :tipo, :timestamp]

    @doc """
    Crea un nuevo mensaje
    """
    def nuevo(id, autor_id, contenido, destino, tipo \\ :equipo) do
      %Mensaje{
        id: id,
        autor_id: autor_id,
        contenido: contenido,
        destino: destino,
        tipo: tipo,
        timestamp: DateTime.utc_now()
      }
    end
  end

  # Estructura para representar un mentor
  defmodule Mentor do
    defstruct [:id, :nombre, :especialidad, :equipos_asignados]

    @doc """
    Crea un nuevo mentor
    """
    def nuevo(id, nombre, especialidad) do
      %Mentor{
        id: id,
        nombre: nombre,
        especialidad: especialidad,
        equipos_asignados: []
      }
    end
  end
end
