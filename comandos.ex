defmodule Hackathon.Comandos do
  @moduledoc """
  Módulo que procesa comandos del usuario
  Implementa los comandos requeridos del sistema
  """

  @doc """
  Procesa un comando ingresado por el usuario
  """
  def procesar(comando) do
    comando
    |> String.trim()
    |> String.split(" ", parts: 2)
    |> ejecutar_comando()
  end

  # /teams → Listar equipos registrados
  defp ejecutar_comando(["/teams"]) do
    case Hackathon.Sistema.listar_equipos(Hackathon.Sistema) do
      {:ok, equipos} ->
        IO.puts("\n=== EQUIPOS REGISTRADOS ===")
        mostrar_equipos_recursivo(equipos)
        :ok
      {:error, mensaje} ->
        IO.puts("Error: #{mensaje}")
        :error
    end
  end

  # /project nombre_equipo → Mostrar información del proyecto
  defp ejecutar_comando(["/project", equipo_id_str]) do
    equipo_id = String.to_integer(equipo_id_str)

    case Hackathon.Sistema.info_proyecto(Hackathon.Sistema, equipo_id) do
      {:ok, proyecto} ->
        IO.puts("\n=== INFORMACIÓN DEL PROYECTO ===")
        IO.puts("Nombre: #{proyecto.nombre}")
        IO.puts("Descripción: #{proyecto.descripcion}")
        IO.puts("Categoría: #{proyecto.categoria}")
        IO.puts("Estado: #{proyecto.estado}")
        IO.puts("Avances registrados: #{proyecto.avances}")
        :ok
      {:error, mensaje} ->
        IO.puts("Error: #{mensaje}")
        :error
    end
  end

  # /join equipo_id → Unirse a un equipo (requiere participante_id)
  defp ejecutar_comando(["/join", params]) do
    IO.puts("Para unirte a un equipo usa: Hackathon.Sistema.unir_a_equipo(pid, participante_id, equipo_id)")
    IO.puts("Ejemplo: Hackathon.Sistema.unir_a_equipo(Hackathon.Sistema, 1, #{params})")
    :ok
  end

  # /chat equipo_id → Ingresar al canal de chat
  defp ejecutar_comando(["/chat", equipo_id_str]) do
    equipo_id = String.to_integer(equipo_id_str)

    case Hackathon.ChatServer.obtener_mensajes(Hackathon.ChatServer, equipo_id) do
      {:ok, mensajes} ->
        IO.puts("\n=== CHAT DEL EQUIPO #{equipo_id} ===")
        mostrar_mensajes_recursivo(mensajes)
        :ok
      {:error, mensaje} ->
        IO.puts("Error: #{mensaje}")
        :error
    end
  end

  # /help → Mostrar comandos disponibles
  defp ejecutar_comando(["/help"]) do
    mostrar_ayuda()
    :ok
  end

  # Comando no reconocido
  defp ejecutar_comando(_) do
    IO.puts("Comando no reconocido. Usa /help para ver los comandos disponibles.")
    :error
  end

  # Funciones auxiliares recursivas

  defp mostrar_equipos_recursivo([]), do: IO.puts("No hay equipos registrados.")

  defp mostrar_equipos_recursivo([equipo | resto]) do
    IO.puts("ID: #{equipo.id} | Nombre: #{equipo.nombre} | Tema: #{equipo.tema} | Miembros: #{equipo.cantidad_miembros}")
    mostrar_equipos_recursivo(resto)
  end

  defp mostrar_mensajes_recursivo([]), do: IO.puts("No hay mensajes en este chat.")

  defp mostrar_mensajes_recursivo([mensaje | resto]) do
    timestamp = DateTime.to_string(mensaje.timestamp)
    IO.puts("[#{timestamp}] Usuario #{mensaje.autor_id}: #{mensaje.contenido}")
    mostrar_mensajes_recursivo(resto)
  end

  defp mostrar_ayuda do
    IO.puts("""

    === COMANDOS DISPONIBLES ===

    /teams
      → Lista todos los equipos registrados

    /project <equipo_id>
      → Muestra información del proyecto de un equipo
      → Ejemplo: /project 1

    /join <equipo_id>
      → Información para unirse a un equipo
      → Ejemplo: /join 1

    /chat <equipo_id>
      → Muestra los mensajes del chat de un equipo
      → Ejemplo: /chat 1

    /help
      → Muestra este mensaje de ayuda

    === FUNCIONES ADICIONALES ===

    Puedes usar directamente las funciones del módulo Sistema:
    - Hackathon.Sistema.registrar_participante(pid, id, nombre, email)
    - Hackathon.Sistema.crear_equipo(pid, id, nombre, tema)
    - Hackathon.Sistema.registrar_proyecto(pid, id, equipo_id, nombre, desc, cat)
    - Y muchas más...

    """)
  end
end
