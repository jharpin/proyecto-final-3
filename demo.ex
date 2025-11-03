defmodule Hackathon.Demo do
  @moduledoc """
  Módulo de demostración del sistema
  Simula el uso de la Hackathon con datos de prueba
  """

  @doc """
  Ejecuta una demostración completa del sistema
  """
  def ejecutar do
    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("DEMOSTRACIÓN SISTEMA HACKATHON CODE4FUTURE")
    IO.puts(String.duplicate("=", 60) <> "\n")

    # Paso 1: Registrar participantes
    IO.puts("📋 PASO 1: Registrando participantes...")
    registrar_participantes()
    Process.sleep(500)

    # Paso 2: Crear equipos
    IO.puts("\n🏆 PASO 2: Creando equipos...")
    crear_equipos()
    Process.sleep(500)

    # Paso 3: Asignar participantes a equipos
    IO.puts("\n👥 PASO 3: Asignando participantes a equipos...")
    asignar_participantes()
    Process.sleep(500)

    # Paso 4: Registrar proyectos
    IO.puts("\n💡 PASO 4: Registrando proyectos...")
    registrar_proyectos()
    Process.sleep(500)

    # Paso 5: Registrar mentores
    IO.puts("\n👨‍🏫 PASO 5: Registrando mentores...")
    registrar_mentores()
    Process.sleep(500)

    # Paso 6: Agregar avances
    IO.puts("\n📈 PASO 6: Agregando avances a proyectos...")
    agregar_avances()
    Process.sleep(500)

    # Paso 7: Agregar retroalimentación
    IO.puts("\n💬 PASO 7: Agregando retroalimentación de mentores...")
    agregar_retroalimentacion()
    Process.sleep(500)

    # Paso 8: Enviar mensajes
    IO.puts("\n💌 PASO 8: Enviando mensajes de chat...")
    enviar_mensajes()
    Process.sleep(500)

    # Paso 9: Mostrar estadísticas
    IO.puts("\n📊 PASO 9: Generando estadísticas...")
    mostrar_estadisticas()
    Process.sleep(500)

    # Paso 10: Probar comandos
    IO.puts("\n⚡ PASO 10: Probando comandos del sistema...")
    probar_comandos()

    IO.puts("\n" <> String.duplicate("=", 60))
    IO.puts("✅ DEMOSTRACIÓN COMPLETADA")
    IO.puts(String.duplicate("=", 60) <> "\n")
  end

  defp registrar_participantes do
    participantes = [
      {1, "Ana García", "ana@email.com"},
      {2, "Carlos Rodríguez", "carlos@email.com"},
      {3, "María López", "maria@email.com"},
      {4, "Juan Pérez", "juan@email.com"},
      {5, "Laura Martínez", "laura@email.com"},
      {6, "Pedro Sánchez", "pedro@email.com"},
      {7, "Sofia Torres", "sofia@email.com"},
      {8, "Diego Ramírez", "diego@email.com"}
    ]

    Enum.each(participantes, fn {id, nombre, email} ->
      Hackathon.Sistema.registrar_participante(Hackathon.Sistema, id, nombre, email)
      IO.puts("  ✓ Registrado: #{nombre}")
    end)
  end

  defp crear_equipos do
    equipos = [
      {1, "EcoTech", "Medio Ambiente"},
      {2, "EduFuture", "Educación"},
      {3, "HealthAI", "Salud"}
    ]

    Enum.each(equipos, fn {id, nombre, tema} ->
      Hackathon.Sistema.crear_equipo(Hackathon.Sistema, id, nombre, tema)
      IO.puts("  ✓ Creado equipo: #{nombre} (#{tema})")
    end)
  end

  defp asignar_participantes do
    asignaciones = [
      {1, 1}, {2, 1}, {3, 1},  # EcoTech
      {4, 2}, {5, 2}, {6, 2},  # EduFuture
      {7, 3}, {8, 3}           # HealthAI
    ]

    Enum.each(asignaciones, fn {participante_id, equipo_id} ->
      Hackathon.Sistema.unir_a_equipo(Hackathon.Sistema, participante_id, equipo_id)
      IO.puts("  ✓ Participante #{participante_id} unido a equipo #{equipo_id}")
    end)
  end

  defp registrar_proyectos do
    proyectos = [
      {1, 1, "ReciclaApp", "App para gestión de reciclaje inteligente", "Medio Ambiente"},
      {2, 2, "LearnTogether", "Plataforma colaborativa de aprendizaje", "Educación"},
      {3, 3, "MediTrack", "Sistema de seguimiento de tratamientos médicos", "Salud"}
    ]

    Enum.each(proyectos, fn {id, equipo_id, nombre, desc, categoria} ->
      Hackathon.Sistema.registrar_proyecto(Hackathon.Sistema, id, equipo_id, nombre, desc, categoria)
      IO.puts("  ✓ Proyecto registrado: #{nombre}")
    end)
  end

  defp registrar_mentores do
    mentores = [
      {1, "Dr. Roberto Silva", "Backend"},
      {2, "Ing. Carmen Vega", "Frontend"},
      {3, "Dra. Patricia Ramos", "Machine Learning"}
    ]

    Enum.each(mentores, fn {id, nombre, especialidad} ->
      Hackathon.Sistema.registrar_mentor(Hackathon.Sistema, id, nombre, especialidad)
      IO.puts("  ✓ Mentor registrado: #{nombre} (#{especialidad})")
    end)
  end

  defp agregar_avances do
    avances = [
      {1, "Diseño inicial de la interfaz completado"},
      {1, "API de recolección de datos implementada"},
      {2, "Módulo de autenticación funcionando"},
      {2, "Sistema de salas de estudio creado"},
      {3, "Base de datos diseñada e implementada"},
      {3, "Módulo de recordatorios funcionando"}
    ]

    Enum.each(avances, fn {proyecto_id, avance} ->
      Hackathon.Sistema.agregar_avance(Hackathon.Sistema, proyecto_id, avance)
      IO.puts("  ✓ Avance agregado al proyecto #{proyecto_id}")
    end)
  end

  defp agregar_retroalimentacion do
    retroalimentaciones = [
      {1, 1, "Excelente progreso en la arquitectura del backend"},
      {2, 2, "La UX está muy intuitiva, buen trabajo"},
      {3, 3, "Consideren agregar notificaciones push"}
    ]

    Enum.each(retroalimentaciones, fn {proyecto_id, mentor_id, comentario} ->
      Hackathon.Sistema.agregar_retroalimentacion(Hackathon.Sistema, proyecto_id, mentor_id, comentario)
      IO.puts("  ✓ Retroalimentación agregada al proyecto #{proyecto_id}")
    end)
  end

  defp enviar_mensajes do
    mensajes = [
      {1, "¡Hola equipo! Comencemos a trabajar", 1},
      {2, "He subido el diseño inicial al repositorio", 1},
      {4, "¿Alguien puede revisar el módulo de autenticación?", 2},
      {7, "Completado el módulo de recordatorios", 3}
    ]

    Enum.each(mensajes, fn {autor_id, contenido, equipo_id} ->
      Hackathon.ChatServer.enviar_mensaje(Hackathon.ChatServer, autor_id, contenido, equipo_id, :equipo)
      IO.puts("  ✓ Mensaje enviado al equipo #{equipo_id}")
    end)

    # Mensaje general
    Hackathon.ChatServer.enviar_mensaje(Hackathon.ChatServer, 0, "¡Bienvenidos a la Hackathon Code4Future!", :general, :general)
    IO.puts("  ✓ Anuncio general enviado")
  end

  defp mostrar_estadisticas do
    case Hackathon.Sistema.obtener_estado(Hackathon.Sistema) do
      estado ->
        stats = Hackathon.Utilidades.estadisticas_sistema(
          estado.participantes,
          estado.equipos,
          estado.proyectos
        )

        IO.puts("\n  " <> String.duplicate("-", 50))
        IO.puts("  Total de participantes: #{stats.total_participantes}")
        IO.puts("  Total de equipos: #{stats.total_equipos}")
        IO.puts("  Total de proyectos: #{stats.total_proyectos}")
        IO.puts("  Participantes sin equipo: #{stats.participantes_sin_equipo}")
        IO.puts("  Equipos sin proyecto: #{stats.equipos_sin_proyecto}")
        IO.puts("  " <> String.duplicate("-", 50))

        # Generar reporte completo
        Hackathon.Utilidades.generar_reporte(estado.equipos, estado.proyectos)
    end
  end

  defp probar_comandos do
    IO.puts("\n  Probando comando /teams:")
    Hackathon.Comandos.procesar("/teams")

    IO.puts("\n  Probando comando /project 1:")
    Hackathon.Comandos.procesar("/project 1")

    IO.puts("\n  Probando comando /chat 1:")
    Hackathon.Comandos.procesar("/chat 1")

    IO.puts("\n  Probando comando /help:")
    Hackathon.Comandos.procesar("/help")
  end

  @doc """
  Simula múltiples equipos trabajando concurrentemente
  """
  def simulacion_concurrente do
    IO.puts("\n🔄 Iniciando simulación concurrente...")

    # Crear 10 equipos concurrentemente
    tareas = for i <- 1..10 do
      Task.async(fn ->
        Hackathon.Sistema.crear_equipo(Hackathon.Sistema, i + 100, "Equipo #{i}", "Tema #{i}")
        Process.sleep(Enum.random(100..500))
        IO.puts("  ✓ Equipo #{i} creado en proceso #{inspect(self())}")
      end)
    end

    # Esperar a que todas las tareas terminen
    Enum.each(tareas, &Task.await/1)

    IO.puts("✅ Simulación concurrente completada")
  end
end
