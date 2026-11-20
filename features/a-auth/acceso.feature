# language: es
@a-auth
Característica: Acceso y visibilidad por rol
  Cada usuario entra con su cuenta QA y solo ve lo que le corresponde: su equipo, su órgano de
  la Junta, o nada si está bloqueado o no tiene equipo. (Mismos casos que la suite A de
  qa-playwright y qa-selenium.)

  Escenario: TC-SMOKE La app carga y muestra el login QA
    Dado que abro la app sin iniciar sesión
    Entonces la página tiene título
    Y veo el formulario de acceso QA

  Escenario: TC-A01 Jugador con equipo entra y ve la navegación completa
    Dado que he iniciado sesión como "QA Jugador MAD"
    Entonces mi nombre aparece en el botón de mi ficha
    Y veo la navegación con las pestañas:
      | Calendario |
      | Partidas   |
      | Jugadores  |
      | Normas     |
    Y veo el botón "+ Nueva partida"

  Escenario: TC-A01b Usuario sin equipo queda pendiente de asignación
    Dado que he iniciado sesión como "QA Sin Equipo"
    Entonces veo el encabezado "Pendiente de asignación de equipo"
    Y no veo la navegación
    Y no veo el botón "+ Nueva partida"

  Escenario: TC-A02 Usuario bloqueado ve acceso denegado
    Dado que he iniciado sesión como "QA Bloqueado"
    Entonces veo el encabezado "Acceso denegado"

  Escenario: TC-A02b Usuario bloqueado no accede a ningún dato
    Dado que he iniciado sesión como "QA Bloqueado"
    Entonces veo "Acceso denegado"
    Y no veo la navegación
    Y no veo el botón "+ Nueva partida"
    Y la lista no tiene partidas

  Escenario: TC-A04 Contraseña incorrecta muestra error y no entra
    Dado que abro la app sin iniciar sesión
    Cuando intento entrar como "QA Jugador MAD" con la contraseña "contraseña-incorrecta"
    Entonces veo el aviso "Error al iniciar sesión"
    Y veo el formulario de acceso QA
    Y no veo la navegación

  Escenario: TC-A05 Cerrar sesión vuelve a la pantalla de login
    Dado que he iniciado sesión como "QA Jugador MAD"
    Cuando cierro sesión
    Entonces veo el formulario de acceso QA
    Y no veo la navegación

  Escenario: TC-A03 Editar la ficha de operador guarda equipaciones y roles
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando abro mi ficha de operador
    Y marco "MultiCam" en mi ficha
    Y marco "Médico" en mi ficha
    Y guardo mi ficha
    Entonces veo el aviso "Perfil actualizado: QA Jugador FOE."
    Y mi ficha está cerrada
    Cuando recargo la página
    Y abro mi ficha de operador
    Entonces mi ficha tiene marcado "MultiCam"
    Y mi ficha tiene marcado "Médico"

  Escenario: TC-A06 Jugador MAD solo ve partidas MAD y no tiene pestaña FOE
    Dado que he iniciado sesión como "QA Jugador MAD"
    Entonces en la lista de partidas veo:
      | QA MAD · Partida próxima       |
      | QA MAD · Partida en excedencia |
    Y todas las partidas de la lista son de "QA MAD"
    Y no veo la pestaña "FOE · Votos y Faltas"

  Escenario: TC-A07 Jugador FOE ve las partidas FOE y ninguna MAD
    Dado que he iniciado sesión como "QA Jugador FOE"
    Entonces en la lista de partidas veo:
      | QA FOE · Partida próxima          |
      | QA FOE · MilSim próxima           |
      | QA FOE · Partida en menos de 48 h |
      | QA FOE · Partida finalizada       |
      | QA FOE · Inscripción abierta      |
    Y todas las partidas de la lista son de "QA FOE"
    Y veo la pestaña "FOE · Votos y Faltas"

  Escenario: TC-A08 Super admin ve las partidas de ambos equipos
    Dado que he iniciado sesión como "QA Super Admin"
    Entonces en la lista de partidas veo:
      | QA MAD · Partida próxima          |
      | QA MAD · Partida en excedencia    |
      | QA FOE · Partida próxima          |
      | QA FOE · MilSim próxima           |
      | QA FOE · Partida en menos de 48 h |
      | QA FOE · Partida finalizada       |
      | QA FOE · Inscripción abierta      |

  Escenario: TC-A09 Jugador FOE sin cargo no ve la Junta Directiva
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando abro la pestaña "FOE · Votos y Faltas"
    Entonces veo el botón "Faltas y Sanciones"
    Y no veo el botón "Votos · Junta Directiva"
    Y no veo "QA · Votación de la Junta Directiva"

  Escenario: TC-A10 Miembro de la Junta Directiva ve su votación
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando abro las votaciones de la Junta Directiva
    Entonces veo "QA · Votación de la Junta Directiva"
