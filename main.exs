# main.exs - Sistema Hackathon COMPLETO E INTERACTIVO

# ============================================================================
# ESTRUCTURAS DE DATOS
# ============================================================================

defmodule Hackathon.Structs.Participante do
  defstruct [:id, :nombre, :email, :equipo_id]

  def nuevo(id, nombre, email) do
    %__MODULE__{id: id, nombre: nombre, email: email, equipo_id: nil}
  end
end

defmodule Hackathon.Structs.Equipo do
  defstruct [:id, :nombre, :tema, :miembros, :proyecto_id, :activo]

  def nuevo(id, nombre, tema) do
    %__MODULE__{
      id: id,
      nombre: nombre,
      tema: tema,
      miembros: [],
      proyecto_id: nil,
      activo: true
    }
  end

  def agregar_miembro(equipo, participante_id) do
    %{equipo | miembros: [participante_id | equipo.miembros]}
  end
end

defmodule Hackathon.Structs.Proyecto do
  defstruct [:id, :equipo_id, :nombre, :descripcion, :categoria, :avances, :estado, :retroalimentacion]

  def nuevo(id, equipo_id, nombre, descripcion, categoria) do
    %__MODULE__{
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

  def agregar_avance(proyecto, avance) do
    nuevo_avance = %{texto: avance, timestamp: DateTime.utc_now()}
    %{proyecto | avances: [nuevo_avance | proyecto.avances]}
  end
end

# ============================================================================
# GESTIÓN DE EQUIPOS
# ============================================================================

defmodule Hackathon.GestionEquipos do
  alias Hackathon.Structs.{Equipo, Participante}

  def registrar_participante(participantes, id, nombre, email) do
    nuevo_participante = Participante.nuevo(id, nombre, email)
    [nuevo_participante | participantes]
  end

  def crear_equipo(equipos, id, nombre, tema) do
    nuevo_equipo = Equipo.nuevo(id, nombre, tema)
    [nuevo_equipo | equipos]
  end

  def asignar_a_equipo(equipos, participantes, participante_id, equipo_id) do
    equipos_actualizados = actualizar_equipo_recursivo(equipos, equipo_id, participante_id)
    participantes_actualizados = actualizar_participante_recursivo(participantes, participante_id, equipo_id)
    {equipos_actualizados, participantes_actualizados}
  end

  defp actualizar_equipo_recursivo([], _equipo_id, _participante_id), do: []
  defp actualizar_equipo_recursivo([equipo | resto], equipo_id, participante_id) do
    if equipo.id == equipo_id do
      [Equipo.agregar_miembro(equipo, participante_id) | resto]
    else
      [equipo | actualizar_equipo_recursivo(resto, equipo_id, participante_id)]
    end
  end

  defp actualizar_participante_recursivo([], _participante_id, _equipo_id), do: []
  defp actualizar_participante_recursivo([participante | resto], participante_id, equipo_id) do
    if participante.id == participante_id do
      [%{participante | equipo_id: equipo_id} | resto]
    else
      [participante | actualizar_participante_recursivo(resto, participante_id, equipo_id)]
    end
  end

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

  def buscar_equipo([], _id), do: nil
  def buscar_equipo([equipo | resto], id) do
    if equipo.id == id, do: equipo, else: buscar_equipo(resto, id)
  end

  def contar_miembros_recursivo([]), do: 0
  def contar_miembros_recursivo([_miembro | resto]) do
    1 + contar_miembros_recursivo(resto)
  end
end

# ============================================================================
# GESTIÓN DE PROYECTOS
# ============================================================================

defmodule Hackathon.GestionProyectos do
  alias Hackathon.Structs.Proyecto

  def registrar_proyecto(proyectos, id, equipo_id, nombre, descripcion, categoria) do
    nuevo_proyecto = Proyecto.nuevo(id, equipo_id, nombre, descripcion, categoria)
    [nuevo_proyecto | proyectos]
  end

  def actualizar_avance(proyectos, proyecto_id, avance) do
    actualizar_proyecto_recursivo(proyectos, proyecto_id, fn proyecto ->
      Proyecto.agregar_avance(proyecto, avance)
    end)
  end

  defp actualizar_proyecto_recursivo([], _id, _funcion), do: []
  defp actualizar_proyecto_recursivo([proyecto | resto], id, funcion) do
    if proyecto.id == id do
      [funcion.(proyecto) | resto]
    else
      [proyecto | actualizar_proyecto_recursivo(resto, id, funcion)]
    end
  end

  def buscar_proyecto([], _id), do: nil
  def buscar_proyecto([proyecto | resto], id) do
    if proyecto.id == id, do: proyecto, else: buscar_proyecto(resto, id)
  end

  def buscar_por_equipo([], _equipo_id), do: nil
  def buscar_por_equipo([proyecto | resto], equipo_id) do
    if proyecto.equipo_id == equipo_id, do: proyecto, else: buscar_por_equipo(resto, equipo_id)
  end

  def contar_avances([]), do: 0
  def contar_avances([_avance | resto]), do: 1 + contar_avances(resto)
end

# ============================================================================
# UTILIDADES
# ============================================================================

defmodule Hackathon.Utilidades do
  def contar_recursivo([]), do: 0
  def contar_recursivo([_elemento | resto]), do: 1 + contar_recursivo(resto)

  def estadisticas_sistema(participantes, equipos, proyectos) do
    %{
      total_participantes: contar_recursivo(participantes),
      total_equipos: contar_recursivo(equipos),
      total_proyectos: contar_recursivo(proyectos)
    }
  end

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

  defp generar_reporte_equipos_recursivo([], _proyectos, _contador), do: :ok
  defp generar_reporte_equipos_recursivo([equipo | resto], proyectos, contador) do
    proyecto = Hackathon.GestionProyectos.buscar_por_equipo(proyectos, equipo.id)

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
end

# ============================================================================
# DEMO AUTOMÁTICA
# ============================================================================

defmodule Hackathon.Demo do
  alias Hackathon.Structs.{Participante, Equipo, Proyecto}
  alias Hackathon.{GestionEquipos, GestionProyectos, Utilidades}

  def ejecutar do
    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("DEMOSTRACIÓN AUTOMÁTICA DEL SISTEMA")
    IO.puts(String.duplicate("=", 60) <> "\n")

    estado = %{participantes: [], equipos: [], proyectos: []}

    IO.puts("📋 Registrando participantes...")
    estado = registrar_participantes(estado)
    Process.sleep(300)

    IO.puts("\n🏆 Creando equipos...")
    estado = crear_equipos(estado)
    Process.sleep(300)

    IO.puts("\n👥 Asignando participantes a equipos...")
    estado = asignar_participantes(estado)
    Process.sleep(300)

    IO.puts("\n💡 Registrando proyectos...")
    estado = registrar_proyectos(estado)
    Process.sleep(300)

    IO.puts("\n📈 Agregando avances...")
    estado = agregar_avances(estado)
    Process.sleep(300)

    IO.puts("\n📊 Generando estadísticas...")
    mostrar_estadisticas(estado)

    # Guardar en el sistema
    Agent.update(:hackathon_sistema, fn _ -> estado end)

    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("✅ DEMOSTRACIÓN COMPLETADA")
    IO.puts(String.duplicate("=", 60) <> "\n")
  end

  defp registrar_participantes(estado) do
    participantes = [
      {1, "Ana García", "ana@email.com"},
      {2, "Carlos Rodríguez", "carlos@email.com"},
      {3, "María López", "maria@email.com"},
      {4, "Juan Pérez", "juan@email.com"},
      {5, "Laura Martínez", "laura@email.com"},
      {6, "Pedro Sánchez", "pedro@email.com"}
    ]

    nuevos_participantes = Enum.reduce(participantes, estado.participantes, fn {id, nombre, email}, acc ->
      GestionEquipos.registrar_participante(acc, id, nombre, email)
    end)

    Enum.each(participantes, fn {_id, nombre, _email} ->
      IO.puts("  ✓ #{nombre}")
    end)

    %{estado | participantes: nuevos_participantes}
  end

  defp crear_equipos(estado) do
    equipos = [
      {1, "EcoTech", "Medio Ambiente"},
      {2, "EduFuture", "Educación"},
      {3, "HealthAI", "Salud"}
    ]

    nuevos_equipos = Enum.reduce(equipos, estado.equipos, fn {id, nombre, tema}, acc ->
      GestionEquipos.crear_equipo(acc, id, nombre, tema)
    end)

    Enum.each(equipos, fn {_id, nombre, tema} ->
      IO.puts("  ✓ #{nombre} (#{tema})")
    end)

    %{estado | equipos: nuevos_equipos}
  end

  defp asignar_participantes(estado) do
    asignaciones = [{1, 1}, {2, 1}, {3, 2}, {4, 2}, {5, 3}, {6, 3}]

    {equipos, participantes} = Enum.reduce(asignaciones, {estado.equipos, estado.participantes},
      fn {p_id, e_id}, {equipos_acc, part_acc} ->
        GestionEquipos.asignar_a_equipo(equipos_acc, part_acc, p_id, e_id)
      end
    )

    Enum.each(asignaciones, fn {p_id, e_id} ->
      IO.puts("  ✓ Participante #{p_id} → Equipo #{e_id}")
    end)

    %{estado | equipos: equipos, participantes: participantes}
  end

  defp registrar_proyectos(estado) do
    proyectos = [
      {1, 1, "ReciclaApp", "App de reciclaje inteligente", "Medio Ambiente"},
      {2, 2, "LearnTogether", "Plataforma de aprendizaje", "Educación"},
      {3, 3, "MediTrack", "Seguimiento médico", "Salud"}
    ]

    nuevos_proyectos = Enum.reduce(proyectos, estado.proyectos,
      fn {id, equipo_id, nombre, desc, categoria}, acc ->
        GestionProyectos.registrar_proyecto(acc, id, equipo_id, nombre, desc, categoria)
      end
    )

    Enum.each(proyectos, fn {_id, _e_id, nombre, _desc, _cat} ->
      IO.puts("  ✓ #{nombre}")
    end)

    %{estado | proyectos: nuevos_proyectos}
  end

  defp agregar_avances(estado) do
    avances = [
      {1, "Interfaz completada"},
      {2, "Autenticación lista"},
      {3, "Base de datos implementada"}
    ]

    nuevos_proyectos = Enum.reduce(avances, estado.proyectos,
      fn {proyecto_id, avance}, acc ->
        GestionProyectos.actualizar_avance(acc, proyecto_id, avance)
      end
    )

    Enum.each(avances, fn {proyecto_id, _avance} ->
      IO.puts("  ✓ Proyecto #{proyecto_id}")
    end)

    %{estado | proyectos: nuevos_proyectos}
  end

  defp mostrar_estadisticas(estado) do
    stats = Utilidades.estadisticas_sistema(
      estado.participantes, estado.equipos, estado.proyectos
    )

    IO.puts("\n  Participantes: #{stats.total_participantes}")
    IO.puts("  Equipos: #{stats.total_equipos}")
    IO.puts("  Proyectos: #{stats.total_proyectos}")
  end
end

# ============================================================================
# SISTEMA INTERACTIVO
# ============================================================================

defmodule Hackathon.SistemaInteractivo do

  def iniciar do
    {:ok, _sistema_pid} = Agent.start_link(fn ->
      %{participantes: [], equipos: [], proyectos: [], mentores: []}
    end, name: :hackathon_sistema)

    {:ok, _chat_pid} = Agent.start_link(fn ->
      %{mensajes: []}
    end, name: :hackathon_chat)

    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("SISTEMA HACKATHON CODE4FUTURE - MODO INTERACTIVO")
    IO.puts(String.duplicate("=", 60) <> "\n")
    IO.puts("✓ Sistema iniciado correctamente")

    menu_principal()
  end

  defp menu_principal do
    IO.puts("\n" <> String.duplicate("-", 60))
    IO.puts("MENÚ PRINCIPAL")
    IO.puts(String.duplicate("-", 60))
    IO.puts("1. Gestión de Participantes")
    IO.puts("2. Gestión de Equipos")
    IO.puts("3. Gestión de Proyectos")
    IO.puts("4. Sistema de Chat")
    IO.puts("5. Comandos del Sistema")
    IO.puts("6. Ver Estadísticas")
    IO.puts("7. Ejecutar Demo Automática")
    IO.puts("0. Salir")
    IO.puts(String.duplicate("-", 60))

    opcion = IO.gets("Seleccione una opción: ") |> String.trim()

    case opcion do
      "1" -> menu_participantes()
      "2" -> menu_equipos()
      "3" -> menu_proyectos()
      "4" -> menu_chat()
      "5" -> menu_comandos()
      "6" -> ver_estadisticas()
      "7" -> Hackathon.Demo.ejecutar(); menu_principal()
      "0" -> IO.puts("\n¡Hasta luego!\n")
      _ -> IO.puts("\nOpción inválida"); menu_principal()
    end
  end

  # ===== MENÚ PARTICIPANTES =====
  defp menu_participantes do
    IO.puts("\n=== GESTIÓN DE PARTICIPANTES ===")
    IO.puts("1. Registrar nuevo participante")
    IO.puts("2. Listar participantes")
    IO.puts("0. Volver")

    case IO.gets("Opción: ") |> String.trim() do
      "1" -> registrar_participante_interactivo()
      "2" -> listar_participantes()
      "0" -> menu_principal()
      _ -> IO.puts("Opción inválida"); menu_participantes()
    end
  end

  defp registrar_participante_interactivo do
    id = IO.gets("ID del participante: ") |> String.trim() |> String.to_integer()
    nombre = IO.gets("Nombre: ") |> String.trim()
    email = IO.gets("Email: ") |> String.trim()

    Agent.update(:hackathon_sistema, fn estado ->
      nuevos = Hackathon.GestionEquipos.registrar_participante(
        estado.participantes, id, nombre, email
      )
      %{estado | participantes: nuevos}
    end)

    IO.puts("✓ Participante registrado exitosamente")
    menu_participantes()
  end

  defp listar_participantes do
    estado = Agent.get(:hackathon_sistema, & &1)
    IO.puts("\n=== PARTICIPANTES REGISTRADOS ===")
    if Enum.empty?(estado.participantes) do
      IO.puts("No hay participantes registrados")
    else
      Enum.each(estado.participantes, fn p ->
        equipo = if p.equipo_id, do: "Equipo #{p.equipo_id}", else: "Sin equipo"
        IO.puts("ID: #{p.id} | #{p.nombre} | #{p.email} | #{equipo}")
      end)
    end
    menu_participantes()
  end

  # ===== MENÚ EQUIPOS =====
  defp menu_equipos do
    IO.puts("\n=== GESTIÓN DE EQUIPOS ===")
    IO.puts("1. Crear nuevo equipo")
    IO.puts("2. Listar equipos")
    IO.puts("3. Unir participante a equipo")
    IO.puts("0. Volver")

    case IO.gets("Opción: ") |> String.trim() do
      "1" -> crear_equipo_interactivo()
      "2" -> listar_equipos()
      "3" -> unir_a_equipo_interactivo()
      "0" -> menu_principal()
      _ -> IO.puts("Opción inválida"); menu_equipos()
    end
  end

  defp crear_equipo_interactivo do
    id = IO.gets("ID del equipo: ") |> String.trim() |> String.to_integer()
    nombre = IO.gets("Nombre del equipo: ") |> String.trim()
    tema = IO.gets("Tema: ") |> String.trim()

    Agent.update(:hackathon_sistema, fn estado ->
      nuevos = Hackathon.GestionEquipos.crear_equipo(estado.equipos, id, nombre, tema)
      %{estado | equipos: nuevos}
    end)

    IO.puts("✓ Equipo creado exitosamente")
    menu_equipos()
  end

  defp listar_equipos do
    estado = Agent.get(:hackathon_sistema, & &1)
    IO.puts("\n=== EQUIPOS REGISTRADOS ===")
    if Enum.empty?(estado.equipos) do
      IO.puts("No hay equipos registrados")
    else
      equipos_activos = Hackathon.GestionEquipos.listar_equipos_activos(estado.equipos)
      Enum.each(equipos_activos, fn e ->
        IO.puts("ID: #{e.id} | #{e.nombre} | Tema: #{e.tema} | Miembros: #{e.cantidad_miembros}")
      end)
    end
    menu_equipos()
  end

  defp unir_a_equipo_interactivo do
    participante_id = IO.gets("ID del participante: ") |> String.trim() |> String.to_integer()
    equipo_id = IO.gets("ID del equipo: ") |> String.trim() |> String.to_integer()

    Agent.update(:hackathon_sistema, fn estado ->
      {equipos_act, participantes_act} = Hackathon.GestionEquipos.asignar_a_equipo(
        estado.equipos, estado.participantes, participante_id, equipo_id
      )
      %{estado | equipos: equipos_act, participantes: participantes_act}
    end)

    IO.puts("✓ Participante unido al equipo")
    menu_equipos()
  end

  # ===== MENÚ PROYECTOS =====
  defp menu_proyectos do
    IO.puts("\n=== GESTIÓN DE PROYECTOS ===")
    IO.puts("1. Registrar nuevo proyecto")
    IO.puts("2. Listar proyectos")
    IO.puts("3. Agregar avance a proyecto")
    IO.puts("0. Volver")

    case IO.gets("Opción: ") |> String.trim() do
      "1" -> registrar_proyecto_interactivo()
      "2" -> listar_proyectos()
      "3" -> agregar_avance_interactivo()
      "0" -> menu_principal()
      _ -> IO.puts("Opción inválida"); menu_proyectos()
    end
  end

  defp registrar_proyecto_interactivo do
    id = IO.gets("ID del proyecto: ") |> String.trim() |> String.to_integer()
    equipo_id = IO.gets("ID del equipo: ") |> String.trim() |> String.to_integer()
    nombre = IO.gets("Nombre del proyecto: ") |> String.trim()
    descripcion = IO.gets("Descripción: ") |> String.trim()
    categoria = IO.gets("Categoría: ") |> String.trim()

    Agent.update(:hackathon_sistema, fn estado ->
      nuevos = Hackathon.GestionProyectos.registrar_proyecto(
        estado.proyectos, id, equipo_id, nombre, descripcion, categoria
      )
      %{estado | proyectos: nuevos}
    end)

    IO.puts("✓ Proyecto registrado exitosamente")
    menu_proyectos()
  end

  defp listar_proyectos do
    estado = Agent.get(:hackathon_sistema, & &1)
    IO.puts("\n=== PROYECTOS REGISTRADOS ===")
    if Enum.empty?(estado.proyectos) do
      IO.puts("No hay proyectos registrados")
    else
      Enum.each(estado.proyectos, fn p ->
        IO.puts("ID: #{p.id} | #{p.nombre}")
        IO.puts("  Equipo: #{p.equipo_id} | Categoría: #{p.categoria}")
        IO.puts("  Estado: #{p.estado} | Avances: #{length(p.avances)}")
        IO.puts("")
      end)
    end
    menu_proyectos()
  end

  defp agregar_avance_interactivo do
    proyecto_id = IO.gets("ID del proyecto: ") |> String.trim() |> String.to_integer()
    avance = IO.gets("Descripción del avance: ") |> String.trim()

    Agent.update(:hackathon_sistema, fn estado ->
      nuevos = Hackathon.GestionProyectos.actualizar_avance(estado.proyectos, proyecto_id, avance)
      %{estado | proyectos: nuevos}
    end)

    IO.puts("✓ Avance agregado exitosamente")
    menu_proyectos()
  end

  # ===== MENÚ CHAT =====
  defp menu_chat do
    IO.puts("\n=== SISTEMA DE CHAT ===")
    IO.puts("1. Enviar mensaje a equipo")
    IO.puts("2. Ver mensajes de equipo")
    IO.puts("0. Volver")

    case IO.gets("Opción: ") |> String.trim() do
      "1" -> enviar_mensaje_interactivo()
      "2" -> ver_mensajes_interactivo()
      "0" -> menu_principal()
      _ -> IO.puts("Opción inválida"); menu_chat()
    end
  end

  defp enviar_mensaje_interactivo do
    autor_id = IO.gets("Tu ID: ") |> String.trim() |> String.to_integer()
    equipo_id = IO.gets("ID del equipo: ") |> String.trim() |> String.to_integer()
    contenido = IO.gets("Mensaje: ") |> String.trim()

    mensaje = %{
      id: :erlang.unique_integer([:positive]),
      autor_id: autor_id,
      equipo_id: equipo_id,
      contenido: contenido,
      timestamp: DateTime.utc_now()
    }

    Agent.update(:hackathon_chat, fn estado ->
      %{estado | mensajes: [mensaje | estado.mensajes]}
    end)

    IO.puts("✓ Mensaje enviado")
    menu_chat()
  end

  defp ver_mensajes_interactivo do
    equipo_id = IO.gets("ID del equipo: ") |> String.trim() |> String.to_integer()

    mensajes = Agent.get(:hackathon_chat, fn estado ->
      Enum.filter(estado.mensajes, fn m -> m.equipo_id == equipo_id end)
    end)

    IO.puts("\n=== MENSAJES DEL EQUIPO #{equipo_id} ===")
    if Enum.empty?(mensajes) do
      IO.puts("No hay mensajes")
    else
      Enum.reverse(mensajes)
      |> Enum.each(fn m ->
        IO.puts("[Usuario #{m.autor_id}]: #{m.contenido}")
      end)
    end
    menu_chat()
  end

  # ===== COMANDOS =====
  defp menu_comandos do
    IO.puts("\n=== COMANDOS DEL SISTEMA ===")
    IO.puts("Comandos disponibles:")
    IO.puts("  /teams - Listar equipos")
    IO.puts("  /project <id> - Info del proyecto")
    IO.puts("  /help - Ayuda")
    IO.puts("  salir - Volver al menú")

    comando = IO.gets("\n> ") |> String.trim()

    case comando do
      "salir" -> menu_principal()
      "/teams" -> ejecutar_comando_teams(); menu_comandos()
      "/help" -> ejecutar_comando_help(); menu_comandos()
      cmd ->
        if String.starts_with?(cmd, "/project ") do
          ejecutar_comando_project(cmd)
          menu_comandos()
        else
          IO.puts("Comando no reconocido")
          menu_comandos()
        end
    end
  end

  defp ejecutar_comando_teams do
    estado = Agent.get(:hackathon_sistema, & &1)
    IO.puts("\n=== EQUIPOS REGISTRADOS ===")
    equipos = Hackathon.GestionEquipos.listar_equipos_activos(estado.equipos)
    Enum.each(equipos, fn e ->
      IO.puts("ID: #{e.id} | #{e.nombre} | Tema: #{e.tema} | Miembros: #{e.cantidad_miembros}")
    end)
  end

  defp ejecutar_comando_project(comando) do
    id = String.replace(comando, "/project ", "") |> String.trim() |> String.to_integer()
    estado = Agent.get(:hackathon_sistema, & &1)
    proyecto = Hackathon.GestionProyectos.buscar_proyecto(estado.proyectos, id)

    if proyecto do
      IO.puts("\n=== PROYECTO ===")
      IO.puts("Nombre: #{proyecto.nombre}")
      IO.puts("Descripción: #{proyecto.descripcion}")
      IO.puts("Categoría: #{proyecto.categoria}")
      IO.puts("Estado: #{proyecto.estado}")
      IO.puts("Avances: #{length(proyecto.avances)}")
    else
      IO.puts("Proyecto no encontrado")
    end
  end

  defp ejecutar_comando_help do
    IO.puts("\n=== COMANDOS DISPONIBLES ===")
    IO.puts("/teams - Listar todos los equipos")
    IO.puts("/project <id> - Ver información del proyecto")
    IO.puts("/help - Mostrar esta ayuda")
  end

  # ===== ESTADÍSTICAS =====
  defp ver_estadisticas do
    estado = Agent.get(:hackathon_sistema, & &1)
    stats = Hackathon.Utilidades.estadisticas_sistema(
      estado.participantes, estado.equipos, estado.proyectos
    )

    IO.puts("\n=== ESTADÍSTICAS DEL SISTEMA ===")
    IO.puts("Total participantes: #{stats.total_participantes}")
    IO.puts("Total equipos: #{stats.total_equipos}")
    IO.puts("Total proyectos: #{stats.total_proyectos}")

    if stats.total_proyectos > 0 do
      Hackathon.Utilidades.generar_reporte(estado.equipos, estado.proyectos)
    end

    menu_principal()
  end
end

# ============================================================================
# INICIAR SISTEMA
# ============================================================================

Hackathon.SistemaInteractivo.iniciar()
