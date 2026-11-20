# language: es
@c-inscripciones
Característica: Inscripciones y reglas de negocio
  Como jugador quiero apuntarme a las partidas de mi equipo, con mi equipación y mi rol, sin
  saltarme las reglas: plazo de 48 h, excedencias, partidas finalizadas o canceladas.
  (Mismos casos que la suite C de qa-playwright y qa-selenium.)

  Escenario: TC-C01 Inscribirse preselecciona la equipación de la partida y avisa si no la tienes
    # QA Junta 2 tiene Árido en su ficha; la partida recomienda Tiger Stripe.
    Dado que he iniciado sesión como "QA Junta 2"
    Cuando abro la partida "QA FOE · Inscripción abierta"
    Entonces la equipación preseleccionada es "Tiger Stripe"
    Y veo "No tienes «Tiger Stripe» marcada en tu ficha" en el detalle
    Cuando pulso "Apuntarse" en el detalle
    Entonces veo el aviso "Inscripción guardada en la nube."
    Y veo "Inscritos (1)" en el detalle
    Y veo "QA Junta 2 (Tú)" en el detalle
    Y veo el botón "Actualizar inscripción" en el detalle

  Escenario: TC-C07 Sin equipación en la partida se preselecciona la de la ficha del jugador
    Dado que he iniciado sesión como "QA Junta 2"
    Cuando abro la partida "QA FOE · MilSim próxima"
    Entonces la equipación preseleccionada es "Árido"
    Y el rol preseleccionado es "medico"
    Y no veo ningún aviso de equipación

  Escenario: TC-C04 Darse de baja a más de 48 h libera la plaza
    Dado que he iniciado sesión como "QA Jugador FOE"
    Y he abierto la partida "QA FOE · Inscripción abierta"
    Cuando pulso "Apuntarse" en el detalle
    Entonces veo el aviso "Inscripción guardada en la nube."
    Cuando pulso "Darse de baja" en el detalle
    Entonces veo el aviso "Has cancelado tu inscripción."
    Y no veo "QA Jugador FOE (Tú)" en el detalle
    Y veo el botón "Apuntarse" en el detalle

  Escenario: TC-C02 A menos de 48 h no se permite darse de baja
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando abro la partida "QA FOE · Partida en menos de 48 h"
    Entonces veo "Faltan menos de 48 horas para la partida" en el detalle
    Y no veo el botón "Darse de baja" en el detalle
    Pero veo el botón "Actualizar inscripción" en el detalle

  Escenario: TC-C03 Con una excedencia aprobada no se puede inscribir en esas fechas
    Dado que he iniciado sesión como "QA Jugador MAD"
    Entonces en la lista de partidas "QA MAD · Partida en excedencia" muestra el botón "En excedencia"
    Cuando abro la partida "QA MAD · Partida en excedencia"
    Entonces veo "Tienes una excedencia concedida" en el detalle
    Y no veo el botón "Apuntarse" en el detalle

  Esquema del escenario: <caso> Una partida <estado> no admite inscripciones
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando abro la partida "<partida>"
    Entonces veo "<aviso>" en el detalle
    Y no veo el botón "Apuntarse" en el detalle

    Ejemplos:
      | caso   | estado          | partida                        | aviso                                                      |
      | TC-C05 | ya finalizada   | QA FOE · Partida pasada abierta | ya ha finalizado; las inscripciones y bajas están cerradas |
      | TC-C06 | cancelada       | QA FOE · Partida cancelada      | está cancelada; no se permiten inscripciones               |
