# Hackathon Code4Future - Sistema de Gestión

Sistema distribuido en Elixir para la organización y colaboración en hackathons.

## 📋 Descripción del Proyecto

Este proyecto implementa un sistema completo para gestionar la Hackathon Code4Future, permitiendo:
- Gestión de equipos y participantes
- Registro y seguimiento de proyectos
- Chat en tiempo real
- Sistema de mentoría
- Comandos interactivos

## 🏗️ Arquitectura del Sistema

### Módulos Principales

1. **Hackathon.Structs**: Define todas las estructuras de datos
   - Participante
   - Equipo
   - Proyecto
   - Mensaje
   - Mentor

2. **Hackathon.GestionEquipos**: Gestiona equipos y participantes
   - Registro de participantes
   - Creación de equipos
   - Asignación de participantes a equipos

3. **Hackathon.GestionProyectos**: Gestiona proyectos
   - Registro de proyectos
   - Actualización de avances
   - Consultas por categoría/estado

4. **Hackathon.ChatServer**: Sistema de chat con GenServer
   - Mensajes por equipo
   - Canal general de anuncios
   - Salas temáticas

5. **Hackathon.Mentoria**: Gestión de mentores
   - Registro de mentores
   - Asignación a equipos
   - Retroalimentación

6. **Hackathon.Sistema**: Coordinador principal con GenServer
   - Centraliza todas las operaciones
   - Mantiene el estado del sistema

7. **Hackathon.Supervisor**: Supervisor para tolerancia a fallos
   - Reinicio automático de procesos
   - Estrategia one_for_one

## 🚀 Instalación y Uso

### Requisitos
- Elixir 1.14 o superior
- Erlang/OTP 24 o superior

### Instalación

```bash
# Clonar el repositorio
cd hackathon

# Instalar dependencias
mix deps.get

# Compilar el proyecto
mix compile
```

### Ejecutar el Sistema

```bash
# Iniciar el sistema con IEx
iex -S mix

# Ejecutar la demostración completa
iex> Hackathon.Demo.ejecutar()

# Probar concurrencia
iex> Hackathon.Demo.simulacion_concurrente()
```

## 📝 Comandos Disponibles

El sistema incluye los siguientes comandos:

```elixir
# /teams - Listar equipos registrados
Hackathon.Comandos.procesar("/teams")

# /project <equipo_id> - Mostrar información del proyecto
Hackathon.Comandos.procesar("/project 1")

# /chat <equipo_id> - Ver mensajes del equipo
Hackathon.Comandos.procesar("/chat 1")

# /help - Mostrar ayuda
Hackathon.Comandos.procesar("/help")
```

## 🔧 Uso de la API

### Registrar Participante
```elixir
Hackathon.Sistema.registrar_participante(Hackathon.Sistema, 1, "Ana García", "ana@email.com")
```

### Crear Equipo
```elixir
Hackathon.Sistema.crear_equipo(Hackathon.Sistema, 1, "EcoTech", "Medio Ambiente")
```

### Unir Participante a Equipo
```elixir
Hackathon.Sistema.unir_a_equipo(Hackathon.Sistema, 1, 1)
```

### Registrar Proyecto
```elixir
Hackathon.Sistema.registrar_proyecto(
  Hackathon.Sistema,
  1,
  1,
  "ReciclaApp",
  "App para gestión de reciclaje",
  "Medio Ambiente"
)
```

### Agregar Avance
```elixir
Hackathon.Sistema.agregar_avance(Hackathon.Sistema, 1, "Diseño inicial completado")
```

### Registrar Mentor
```elixir
Hackathon.Sistema.registrar_mentor(Hackathon.Sistema, 1, "Dr. Silva", "Backend")
```

### Agregar Retroalimentación
```elixir
Hackathon.Sistema.agregar_retroalimentacion(
  Hackathon.Sistema,
  1,
  1,
  "Excelente progreso en el backend"
)
```

### Enviar Mensaje
```elixir
Hackathon.ChatServer.enviar_mensaje(
  Hackathon.ChatServer,
  1,
  "¡Hola equipo!",
  1,
  :equipo
)
```

## 🧪 Ejecutar Tests

```bash
# Ejecutar todos los tests
mix test

# Ejecutar tests con cobertura
mix test --cover

# Ejecutar tests en modo verbose
mix test --trace
```

## 📊 Características Técnicas Implementadas

### ✅ Requisitos Funcionales
- [x] Gestión de equipos (registro, creación, listado)
- [x] Gestión de proyectos (registro, avances, consultas)
- [x] Comunicación en tiempo real (chat por equipo, anuncios)
- [x] Sistema de mentoría (registro, consultas, retroalimentación)
- [x] Comandos del sistema (/teams, /project, /join, /chat, /help)

### ✅ Requisitos No Funcionales
- [x] Escalabilidad: Uso de GenServer y procesos concurrentes
- [x] Alto rendimiento: Actualizaciones en tiempo real
- [x] Tolerancia a fallos: Supervisor con estrategia one_for_one
- [x] Concurrencia: Múltiples equipos operando simultáneamente

### 🎯 Conceptos de Elixir Utilizados

1. **Structs**: Todas las estructuras de datos
2. **Recursividad**: Funciones de búsqueda y filtrado
3. **Enum**: Operaciones sobre listas (map, filter, sort_by)
4. **GenServer**: Chat y Sistema principal
5. **Supervisor**: Tolerancia a fallos
6. **Pattern Matching**: En todas las funciones
7. **Concurrencia**: Tasks para operaciones paralelas

## 📁 Estructura del Proyecto

```
hackathon/
├── lib/
│   ├── application.ex        # Módulo de aplicación
│   ├── supervisor.ex          # Supervisor principal
│   ├── sistema.ex             # Sistema coordinador
│   ├── structs.ex             # Estructuras de datos
│   ├── gestion_equipos.ex     # Gestión de equipos
│   ├── gestion_proyectos.ex   # Gestión de proyectos
│   ├── chat_server.ex         # Servidor de chat
│   ├── mentoria.ex            # Sistema de mentoría
│   ├── comandos.ex            # Procesador de comandos
│   ├── utilidades.ex          # Funciones auxiliares
│   └── demo.ex                # Demostración del sistema
├── test/
│   └── hackathon_test.exs     # Tests del sistema
├── mix.exs                     # Configuración del proyecto
└── README.md                   # Este archivo
```

## 🎓 Conceptos Académicos Aplicados

### Recursividad
- Búsqueda de elementos en listas
- Filtrado recursivo
- Conteo de elementos

### Enum y Programación Funcional
- Transformación de datos con map
- Filtrado con filter
- Ordenamiento con sort_by
- Agrupación con group_by

### Concurrencia y Distribución
- GenServer para estado compartido
- Task para operaciones paralelas
- Supervisor para tolerancia a fallos

### Pattern Matching
- Desestructuración de datos
- Guards en funciones
- Case statements

## 👥 Equipo de Desarrollo

Proyecto desarrollado como parte del curso de Programación III - 2025-2

## 📄 Licencia

Este proyecto es parte de un trabajo académico para la Hackathon Code4Future.

## 🔍 Notas Adicionales

- El sistema usa almacenamiento en memoria (no persistencia en base de datos)
- Los IDs se generan con `:erlang.unique_integer([:positive])`
- El sistema está diseñado para demostración y aprendizaje
- Implementa los conceptos de Elixir de manera didáctica

## 🚦 Estado del Proyecto

✅ Completado - Listo para evaluación y presentación