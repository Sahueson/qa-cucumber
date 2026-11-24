# language: es
@g-jugadores
Característica: Gestión de jugadores
  Solo el super admin cambia rol, bloqueo, equipos y órganos FOE de los jugadores; el efecto se
  comprueba entrando con el jugador afectado.

  Escenario: TC-G01 El super admin asciende a un jugador a admin y este gestiona partidas
    Dado que he iniciado sesión como "QA Super Admin"
    Cuando cambio el rol de "QA Jugador MAD" a "admin"
    Entonces veo el aviso "Ficha actualizada para QA Jugador MAD."
    Dado que he iniciado sesión como "QA Jugador MAD"
    Cuando abro la pestaña "Partidas"
    Entonces la partida "QA MAD · Partida próxima" muestra el botón "Editar"
    Y la partida "QA MAD · Partida próxima" muestra el botón "Eliminar"

  Escenario: TC-G02 El super admin bloquea a un jugador y este pierde el acceso
    Dado que he iniciado sesión como "QA Super Admin"
    Cuando pulso "Bloquear" en la ficha de "QA Jugador FOE"
    Entonces veo el aviso "Ficha actualizada para QA Jugador FOE."
    Y la ficha de "QA Jugador FOE" muestra el botón "Desbloquear"
    Y veo "QA Jugador FOE [BLOQUEADO]"
    Dado que he iniciado sesión como "QA Jugador FOE"
    Entonces veo el encabezado "Acceso denegado"
    Y no veo la navegación

  Escenario: TC-G03 Asignar equipo a un jugador sin equipo le da acceso a ese equipo
    Dado que he iniciado sesión como "QA Super Admin"
    Entonces veo la ficha de "QA Sin Equipo"
    Y la ficha de "QA Sin Equipo" muestra "Sin equipo asignado"
    Cuando asigno el equipo "FOE" a "QA Sin Equipo"
    Entonces veo el aviso "Ficha actualizada para QA Sin Equipo."
    Y la ficha de "QA Sin Equipo" permite quitarle el equipo "FOE"
    Dado que he iniciado sesión como "QA Sin Equipo"
    Entonces veo la navegación
    Y veo la pestaña "FOE · Votos y Faltas"
    Y en la lista de partidas veo:
      | QA FOE · Partida próxima |
    Y ninguna partida de la lista es de "QA MAD"

  Escenario: TC-G04 Quitar la Junta Directiva a un miembro le oculta sus votaciones
    Dado que he iniciado sesión como "QA Super Admin"
    Cuando pulso "✓ Junta Directiva" en la ficha de "QA Junta 2"
    Entonces veo el aviso "Ficha actualizada para QA Junta 2."
    Y la ficha de "QA Junta 2" muestra el botón "+ Junta Directiva"
    Dado que he iniciado sesión como "QA Junta 2"
    Cuando abro la pestaña "FOE · Votos y Faltas"
    Entonces veo el botón "Votos · Junta Operativa"
    Y no veo el botón "Votos · Junta Directiva"

  Escenario: TC-G05 Un admin que no es super admin no puede cambiar permisos
    Dado que he iniciado sesión como "QA Admin FOE"
    Entonces veo la ficha de "QA Junta 2"
    Y la ficha de "QA Junta 2" no permite cambiar el rol
    Y la ficha de "QA Junta 2" no muestra el botón "Bloquear"
    Y la ficha de "QA Junta 2" no permite quitarle el equipo "FOE"
    Y en la ficha de "QA Junta 2" el órgano "Junta Operativa" no se puede cambiar

  Escenario: TC-G06 El super admin no puede cambiarse el rol ni bloquearse a sí mismo
    Dado que he iniciado sesión como "QA Super Admin"
    Entonces veo la ficha de "QA Super Admin"
    Y la ficha de "QA Super Admin" no permite cambiar el rol
    Y la ficha de "QA Super Admin" no muestra el botón "Bloquear"

  Escenario: TC-G07 Un admin de equipo solo ve a los jugadores de su equipo
    Dado que he iniciado sesión como "QA Admin MAD"
    Entonces veo la ficha de "QA Jugador MAD"
    Y no veo la ficha de "QA Jugador FOE"
    Y no veo la ficha de "QA Admin FOE"
    Y no veo la ficha de "QA Sin Equipo"
