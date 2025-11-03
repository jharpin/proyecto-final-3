defmodule HackathonTest do
  use ExUnit.Case
  doctest Hackathon

  alias Hackathon.Structs.{Participante, Equipo, Proyecto}
  alias Hackathon.GestionEquipos
  alias Hackathon.GestionProyectos
  alias Hackathon.Utilidades

  describe "Structs" do
    test "crear participante" do
      participante = Participante.nuevo(1, "Juan", "juan@email.com")
      assert participante.id == 1
      assert participante.nombre == "Juan"
      assert participante.equipo_id == nil
    end

    test "crear equipo" do
      equipo = Equipo.nuevo(1, "TechTeam", "Tecnología")
      assert equipo.id == 1
      assert equipo.nombre == "TechTeam"
      assert equipo.miembros == []
      assert equipo.activo == true
    end

    test "agregar miembro a equipo" do
      equipo = Equipo.nuevo(1, "TechTeam", "Tecnología")
      equipo_actualizado = Equipo.agregar_miembro(equipo, 1)
      assert length(equipo_actualizado.miembros) == 1
      assert 1 in equipo_actualizado.miembros
    end

    test "crear proyecto" do
      proyecto = Proyecto.nuevo(1, 1, "MiApp", "Descripción", "Web")
      assert proyecto.id == 1
      assert proyecto.equipo_id == 1
      assert proyecto.estado == :en_progreso
      assert proyecto.avances == []
    end
  end

  describe "Gestión de Equipos" do
    test "registrar participante" do
      participantes = []
      nuevos = GestionEquipos.registrar_participante(participantes, 1, "Ana", "ana@email.com")
      assert length(nuevos) == 1
    end

    test "crear equipo" do
      equipos = []
      nuevos = GestionEquipos.crear_equipo(equipos, 1, "TeamA", "IoT")
      assert length(nuevos) == 1
    end

    test "buscar equipo por ID" do
      equipos = [
        Equipo.nuevo(1, "Team1", "Web"),
        Equipo.nuevo(2, "Team2", "Mobile")
      ]
      equipo = GestionEquipos.buscar_equipo(equipos, 1)
      assert equipo.nombre == "Team1"
    end

    test "listar equipos activos" do
      equipos = [
        Equipo.nuevo(1, "Team1", "Web"),
        Equipo.nuevo(2, "Team2", "Mobile")
      ]
      activos = GestionEquipos.listar_equipos_activos(equipos)
      assert length(activos) == 2
    end

    test "contar miembros recursivamente" do
      miembros = [1, 2, 3, 4, 5]
      total = GestionEquipos.contar_miembros_recursivo(miembros)
      assert total == 5
    end
  end

  describe "Gestión de Proyectos" do
    test "registrar proyecto" do
      proyectos = []
      nuevos = GestionProyectos.registrar_proyecto(
        proyectos, 1, 1, "App", "Desc", "Mobile"
      )
      assert length(nuevos) == 1
    end

    test "buscar proyecto por ID" do
      proyectos = [
        Proyecto.nuevo(1, 1, "App1", "Desc1", "Web"),
        Proyecto.nuevo(2, 2, "App2", "Desc2", "Mobile")
      ]
      proyecto = GestionProyectos.buscar_proyecto(proyectos, 1)
      assert proyecto.nombre == "App1"
    end

    test "consultar por categoría" do
      proyectos = [
        Proyecto.nuevo(1, 1, "App1", "Desc1", "Web"),
        Proyecto.nuevo(2, 2, "App2", "Desc2", "Web"),
        Proyecto.nuevo(3, 3, "App3", "Desc3", "Mobile")
      ]
      web_projects = GestionProyectos.consultar_por_categoria(proyectos, "Web")
      assert length(web_projects) == 2
    end

    test "contar avances" do
      avances = [
        %{texto: "Avance 1", timestamp: DateTime.utc_now()},
        %{texto: "Avance 2", timestamp: DateTime.utc_now()},
        %{texto: "Avance 3", timestamp: DateTime.utc_now()}
      ]
      total = GestionProyectos.contar_avances(avances)
      assert total == 3
    end
  end

  describe "Utilidades" do
    test "contar recursivamente" do
      lista = [1, 2, 3, 4, 5]
      total = Utilidades.contar_recursivo(lista)
      assert total == 5
    end

    test "validar email correcto" do
      assert Utilidades.validar_email("test@email.com") == true
    end

    test "validar email incorrecto" do
      assert Utilidades.validar_email("testemail.com") == false
    end

    test "promedio de miembros" do
      equipos = [
        %Equipo{id: 1, nombre: "T1", tema: "Web", miembros: [1, 2, 3], proyecto_id: nil, activo: true},
        %Equipo{id: 2, nombre: "T2", tema: "Mobile", miembros: [4, 5], proyecto_id: nil, activo: true}
      ]
      promedio = Utilidades.promedio_miembros(equipos)
      assert promedio == 2.5
    end

    test "estadísticas del sistema" do
      participantes = [
        %Participante{id: 1, nombre: "Ana", email: "ana@email.com", equipo_id: 1},
        %Participante{id: 2, nombre: "Carlos", email: "carlos@email.com", equipo_id: nil}
      ]
      equipos = [
        %Equipo{id: 1, nombre: "T1", tema: "Web", miembros: [1], proyecto_id: nil, activo: true}
      ]
      proyectos = []

      stats = Utilidades.estadisticas_sistema(participantes, equipos, proyectos)

      assert stats.total_participantes == 2
      assert stats.total_equipos == 1
      assert stats.participantes_sin_equipo == 1
    end
  end

  describe "Concurrencia" do
    test "crear múltiples equipos concurrentemente" do
      {:ok, pid} = Hackathon.Sistema.start_link()

      tareas = for i <- 1..5 do
        Task.async(fn ->
          Hackathon.Sistema.crear_equipo(pid, i, "Equipo #{i}", "Tema #{i}")
        end)
      end

      resultados = Enum.map(tareas, &Task.await/1)
      assert length(resultados) == 5
      assert Enum.all?(resultados, fn {:ok, _} -> true end)

      GenServer.stop(pid)
    end
  end
end
