# Manual de Usuario - Sistema Hackathon Code4Future

## 📖 Introducción

Bienvenido al Sistema de Gestión de Hackathon Code4Future. Este manual te guiará paso a paso en el uso del sistema.

## 🎯 Inicio Rápido

### 1. Iniciar el Sistema

```bash
# Abrir terminal en la carpeta del proyecto
cd Proyecto final 3

# Iniciar Elixir con el proyecto
iex -S mix
```

Verás un mensaje:
```
Iniciando sistema Hackathon Code4Future...
```

### 2. Ejecutar la Demostración

Para ver el sistema en acción:

```elixir
iex> Hackathon.Demo.ejecutar()
```

Esto ejecutará una demostración completa con:
- Registro de 8 participantes
- Creación de 3 equipos
- Registro de 3 proyectos
- Mensajes de chat
- Retroalimentación de mentores
- Estadísticas del sistema

## 👥 Gestión de Participantes

### Registrar un Participante

```elixir
Hackathon.Sistema.registrar_participante(Hackathon.Sistema, id, nombre, email)
```

**Ejemplo:**
```elixir
Hackathon.Sistema.registrar_participante(Hackathon.Sistema, 1, "Ana García", "ana@email.com")
```

**Resultado:** `{:ok, "Participante registrado"}`

## 🏆 Gestión de Equipos

### Crear un Equipo

```elixir
Hackathon.Sistema.crear_equipo(Hackathon.Sistema, id, nombre, tema)
```

**Ejemplo:**
```elixir
Hackathon.Sistema.crear_equipo(Hackathon.Sistema, 1, "EcoTech", "Medio Ambiente")
```

### Unir Participante a Equipo

```elixir
Hackathon.Sistema.unir_a_equipo(Hackathon.Sistema, participante_id, equipo_id)
```

**Ejemplo:**
```elixir
# Unir participante 1 al equipo 1
Hackathon.Sistema.unir_a_equipo(Hackathon.Sistema, 1, 1)
```

### Listar Todos los Equipos

**Usando comando:**
```elixir
Hackathon.Comandos.procesar("/teams")
```

**Usando API:**
```elixir
Hackathon.Sistema.listar_equipos(Hackathon.Sistema)
```

**Resultado:**
```
=== EQUIPOS REGISTRADOS ===
ID: 1 | Nombre: EcoTech | Tema: Medio Ambiente | Miembros: 3
ID: 2 | Nombre: EduFuture | Tema: Educación | Miembros: 3
```

## 💡 Gestión de Proyectos

### Registrar un Proyecto

```elixir
Hackathon.Sistema.registrar_proyecto(
  Hackathon.Sistema,
  id,
  equipo_id,
  nombre,
  descripcion,
  categoria
)
```

**Ejemplo:**
```elixir
Hackathon.Sistema.registrar_proyecto(
  Hackathon.Sistema,
  1,
  1,
  "ReciclaApp",
  "Aplicación para gestión inteligente de reciclaje",
  "Medio Ambiente"
)
```

### Agregar Avance a un Proyecto

```elixir
Hackathon.Sistema.agregar_avance(Hackathon.Sistema, proyecto_id, avance)
```

**Ejemplo:**
```elixir
Hackathon.Sistema.agregar_avance(
  Hackathon.Sistema,
  1,
  "Diseño de interfaz completado"
)
```

### Ver Información de un Proyecto

**Usando comando:**
```elixir
Hackathon.Comandos.procesar("/project 1")
```

**Resultado:**
```
=== INFORMACIÓN DEL PROYECTO ===
Nombre: ReciclaApp
Descripción: Aplicación para gestión inteligente de reciclaje
Categoría: Medio Ambiente
Estado: en_progreso
Avances registrados: 2
```

## 💬 Sistema de Chat

### Enviar Mensaje a un Equipo

```elixir
Hackathon.ChatServer.enviar_mensaje(
  Hackathon.ChatServer,
  autor_id,
  contenido,
  equipo_id,
  :equipo
)
```

**Ejemplo:**
```elixir
Hackathon.ChatServer.enviar_mensaje(
  Hackathon.ChatServer,
  1,
  "¡Hola equipo! Comencemos a trabajar en el proyecto",
  1,
  :equipo
)
```

### Ver Mensajes de un Equipo

**Usando comando:**
```elixir
Hackathon.Comandos.procesar("/chat 1")
```

**Resultado:**
```
=== CHAT DEL EQUIPO 1 ===
[2025-11-03 15:30:00Z] Usuario 1: ¡Hola equipo! Comencemos a trabajar
[2025-11-03 15:35:00Z] Usuario 2: He subido el diseño inicial
```

### Enviar Anuncio General

```elixir
Hackathon.ChatServer.enviar_mensaje(
  Hackathon.ChatServer,
  0,
  "¡Bienvenidos a la Hackathon!",
  :general,
  :general
)
```

### Crear Sala Temática

```elixir
Hackathon.ChatServer.crear_sala(Hackathon.ChatServer, "Frontend")
```

### Listar Salas

```elixir
Hackathon.ChatServer.listar_salas(Hackathon.ChatServer)
```

## 👨‍🏫 Sistema de Mentoría

### Registrar un Mentor

```elixir
Hackathon.Sistema.registrar_mentor(Hackathon.Sistema, id, nombre, especialidad)
```

**Ejemplo:**
```elixir
Hackathon.Sistema.registrar_mentor(
  Hackathon.Sistema,
  1,
  "Dr. Roberto Silva",
  "Backend"
)
```

### Agregar Retroalimentación

```elixir
Hackathon.Sistema.agregar_retroalimentacion(
  Hackathon.Sistema,
  proyecto_id,
  mentor_id,
  comentario
)
```

**Ejemplo:**
```elixir
Hackathon.Sistema.agregar_retroalimentacion(
  Hackathon.Sistema,
  1,
  1,
  "Excelente progreso en la arquitectura del backend. Sugiero optimizar las consultas."
)
```

## ⚡ Comandos del Sistema

### /teams
Lista todos los equipos registrados

```elixir
Hackathon.Comandos.procesar("/teams")
```

### /project <equipo_id>
Muestra información del proyecto de un equipo

```elixir
Hackathon.Comandos.procesar("/project 1")
```

### /chat <equipo_id>
Muestra los mensajes del chat de un equipo

```elixir
Hackathon.Comandos.procesar("/chat 1")
```

### /help
Muestra la ayuda con todos los comandos disponibles

```elixir
Hackathon.Comandos.procesar("/help")
```

## 📊 Estadísticas y Reportes

### Ver Estadísticas del Sistema

```elixir
estado = Hackathon.Sistema.obtener_estado(Hackathon.Sistema)

stats = Hackathon.Utilidades.estadisticas_sistema(
  estado.participantes,
  estado.equipos,
  estado.proyectos
)
```

### Generar Reporte Completo

```elixir
estado = Hackathon.Sistema.obtener_estado(Hackathon.Sistema)

Hackathon.Utilidades.generar_reporte(estado.equipos, estado.proyectos)
```

**Resultado:**
```
==================================================
REPORTE DE LA HACKATHON CODE4FUTURE
==================================================

Total de equipos: 3
Total de proyectos: 3

Detalle de equipos:

1. Equipo: EcoTech
   Tema: Medio Ambiente
   Miembros: 3
   Proyecto: ReciclaApp
   Categoría: Medio Ambiente
   Avances: 2
```

## 🧪 Simulación de Concurrencia

Para probar el sistema con múltiples equipos trabajando simultáneamente:

```elixir
Hackathon.Demo.simulacion_concurrente()
```

Esto creará 10 equipos de forma concurrente usando Tasks.

## 📋 Ejemplo Completo de Uso

```elixir
# 1. Registrar participantes
Hackathon.Sistema.registrar_participante(Hackathon.Sistema, 1, "Ana", "ana@email.com")
Hackathon.Sistema.registrar_participante(Hackathon.Sistema, 2, "Carlos", "carlos@email.com")

# 2. Crear equipo
Hackathon.Sistema.crear_equipo(Hackathon.Sistema, 1, "DevTeam", "Web")

# 3. Unir participantes al equipo
Hackathon.Sistema.unir_a_equipo(Hackathon.Sistema, 1, 1)
Hackathon.Sistema.unir_a_equipo(Hackathon.Sistema, 2, 1)

# 4. Registrar proyecto
Hackathon.Sistema.registrar_proyecto(
  Hackathon.Sistema,
  1,
  1,
  "MyApp",
  "Aplicación web innovadora",
  "Web"
)

# 5. Agregar avance
Hackathon.Sistema.agregar_avance(
  Hackathon.Sistema,
  1,
  "Primera versión del frontend completada"
)

# 6. Registrar mentor
Hackathon.Sistema.registrar_mentor(Hackathon.Sistema, 1, "Dra. López", "Frontend")

# 7. Agregar retroalimentación
Hackathon.Sistema.agregar_retroalimentacion(
  Hackathon.Sistema,
  1,
  1,
  "Muy buen diseño de interfaz"
)

# 8. Enviar mensaje
Hackathon.ChatServer.enviar_mensaje(
  Hackathon.ChatServer,
  1,
  "¡Proyecto avanzando bien!",
  1,
  :equipo
)

# 9. Ver equipo
Hackathon.Comandos.procesar("/teams")

# 10. Ver proyecto
Hackathon.Comandos.procesar("/project 1")
```

## ❓ Solución de Problemas

### El sistema no inicia
```bash
# Verificar que Elixir esté instalado
elixir --version

# Recompilar el proyecto
mix clean
mix compile
```

### Error al ejecutar comandos
Asegúrate de que el sistema esté iniciado:
```elixir
iex -S mix
```

### Ver estado completo del sistema
```elixir
Hackathon.Sistema.obtener_estado(Hackathon.Sistema)
```

## 📞 Soporte

Para más información sobre el proyecto:
- Ver README.md
- Ejecutar: `Hackathon.Comandos.procesar("/help")`
- Revisar los tests en test/hackathon_test.exs

## 🎓 Notas para Estudiantes

Este manual cubre todas las funciones principales del sistema. Para la sustentación:

1. Conoce cómo ejecutar la demostración: `Hackathon.Demo.ejecutar()`
2. Practica los comandos principales: /teams, /project, /chat
3. Entiende el flujo: registrar participante → crear equipo → unir → registrar proyecto
4. Conoce cómo funciona la concurrencia: `Hackathon.Demo.simulacion_concurrente()`

¡Buena suerte con tu presentación! 🚀