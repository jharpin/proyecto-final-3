defmodule Hackathon.Sistema do
  @moduledoc """
  Módulo principal que coordina todos los componentes del sistema
  """

  use GenServer

  alias Hackathon.GestionEquipos
  alias Hackathon.GestionProyectos
  alias Hackathon.Mentoria

  # Cliente API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, initial_state(), opts)
  end

  defp initial_state do
    %{
      participantes: [],
      equipos: [],
      proyectos: [],
      mentores: [],
      chat_pid: nil
    }
  end

  # Comandos del sistema

  @doc """
  Registra un participante
  """
  def registrar_participante(pid, id, nombre, email) do
    GenServer.call(pid, {:registrar_participante, id, nombre, email})
  end

  @doc """
  Crea un equipo
  """
  def crear_equipo(pid, id, nombre, tema) do
    GenServer.call(pid, {:crear_equipo, id, nombre, tema})
  end

  @doc """
  Une a un participante a un equipo
  """
  def unir_a_equipo(pid, participante_id, equipo_id) do
    GenServer.call(pid, {:unir_equipo, participante_id, equipo_id})
  end

  @doc """
  Lista todos los equipos (/teams)
  """
  def listar_equipos(pid) do
    GenServer.call(pid, :listar_equipos)
  end

  @doc """
  Muestra información de un proyecto (/project nombre_equipo)
  """
  def info_proyecto(pid, equipo_id) do
    GenServer.call(pid, {:info_proyecto, equipo_id})
  end

  @doc """
  Registra un proyecto
  """
  def registrar_proyecto(pid, id, equipo_id, nombre, descripcion, categoria) do
    GenServer.call(pid, {:registrar_proyecto, id, equipo_id, nombre, descripcion, categoria})
  end

  @doc """
  Agrega avance a un proyecto
  """
  def agregar_avance(pid, proyecto_id, avance) do
    GenServer.call(pid, {:agregar_avance, proyecto_id, avance})
  end

  @doc """
  Registra un mentor
  """
  def registrar_mentor(pid, id, nombre, especialidad) do
    GenServer.call(pid, {:registrar_mentor, id, nombre, especialidad})
  end

  @doc """
  Agrega retroalimentación a un proyecto
  """
  def agregar_retroalimentacion(pid, proyecto_id, mentor_id, comentario) do
    GenServer.call(pid, {:agregar_retroalimentacion, proyecto_id, mentor_id, comentario})
  end

  @doc """
  Obtiene el estado completo del sistema
  """
  def obtener_estado(pid) do
    GenServer.call(pid, :obtener_estado)
  end

  # Callbacks del servidor

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call({:registrar_participante, id, nombre, email}, _from, state) do
    nuevos_participantes = GestionEquipos.registrar_participante(state.participantes, id, nombre, email)
    nuevo_estado = %{state | participantes: nuevos_participantes}
    {:reply, {:ok, "Participante registrado"}, nuevo_estado}
  end

  @impl true
  def handle_call({:crear_equipo, id, nombre, tema}, _from, state) do
    nuevos_equipos = GestionEquipos.crear_equipo(state.equipos, id, nombre, tema)
    nuevo_estado = %{state | equipos: nuevos_equipos}
    {:reply, {:ok, "Equipo creado"}, nuevo_estado}
  end

  @impl true
  def handle_call({:unir_equipo, participante_id, equipo_id}, _from, state) do
    {equipos_act, participantes_act} =
      GestionEquipos.asignar_a_equipo(state.equipos, state.participantes, participante_id, equipo_id)

    nuevo_estado = %{state | equipos: equipos_act, participantes: participantes_act}
    {:reply, {:ok, "Participante unido al equipo"}, nuevo_estado}
  end

  @impl true
  def handle_call(:listar_equipos, _from, state) do
    equipos = GestionEquipos.listar_equipos_activos(state.equipos)
    {:reply, {:ok, equipos}, state}
  end

  @impl true
  def handle_call({:info_proyecto, equipo_id}, _from, state) do
    proyecto = GestionProyectos.buscar_por_equipo(state.proyectos, equipo_id)

    respuesta = case proyecto do
      nil -> {:error, "No hay proyecto registrado para este equipo"}
      p -> {:ok, %{
        nombre: p.nombre,
        descripcion: p.descripcion,
        categoria: p.categoria,
        estado: p.estado,
        avances: length(p.avances)
      }}
    end

    {:reply, respuesta, state}
  end

  @impl true
  def handle_call({:registrar_proyecto, id, equipo_id, nombre, descripcion, categoria}, _from, state) do
    nuevos_proyectos = GestionProyectos.registrar_proyecto(
      state.proyectos, id, equipo_id, nombre, descripcion, categoria
    )
    nuevo_estado = %{state | proyectos: nuevos_proyectos}
    {:reply, {:ok, "Proyecto registrado"}, nuevo_estado}
  end

  @impl true
  def handle_call({:agregar_avance, proyecto_id, avance}, _from, state) do
    nuevos_proyectos = GestionProyectos.actualizar_avance(state.proyectos, proyecto_id, avance)
    nuevo_estado = %{state | proyectos: nuevos_proyectos}
    {:reply, {:ok, "Avance agregado"}, nuevo_estado}
  end

  @impl true
  def handle_call({:registrar_mentor, id, nombre, especialidad}, _from, state) do
    nuevos_mentores = Mentoria.registrar_mentor(state.mentores, id, nombre, especialidad)
    nuevo_estado = %{state | mentores: nuevos_mentores}
    {:reply, {:ok, "Mentor registrado"}, nuevo_estado}
  end

  @impl true
  def handle_call({:agregar_retroalimentacion, proyecto_id, mentor_id, comentario}, _from, state) do
    nuevos_proyectos = GestionProyectos.agregar_retroalimentacion(
      state.proyectos, proyecto_id, mentor_id, comentario
    )
    nuevo_estado = %{state | proyectos: nuevos_proyectos}
    {:reply, {:ok, "Retroalimentación agregada"}, nuevo_estado}
  end

  @impl true
  def handle_call(:obtener_estado, _from, state) do
    {:reply, state, state}
  end
end
