# language: es
@d-asistencia
Característica: Motor de asistencia anual del FOE
  El % se calcula sobre las partidas computables FOE del año (seed: finalizada 1, pasada abierta 1
  y MilSim pasada 1,5 = 3,5). La MilSim pesa x1,5 y las partidas durante una excedencia aprobada
  no restan (Art. 33 y 34). (Mismos casos que la suite D de qa-playwright y qa-selenium.)

  Escenario: TC-D01 El % anual se calcula sobre las partidas ya jugadas
    Dado que he iniciado sesión como "QA Admin FOE"
    Entonces la asistencia anual de "QA Jugador FOE" muestra "29% (1/3,5)"
    Y la asistencia anual de "QA Jugador FOE" muestra "Por debajo del mínimo anual FOE (60% · Art. 33)"

  Escenario: TC-D02 Una MilSim pesa x1,5 en la asistencia
    # QA Junta 2 solo fue a la MilSim pasada: suma 1,5, no 1.
    Dado que he iniciado sesión como "QA Admin FOE"
    Entonces la asistencia anual de "QA Junta 2" muestra "(1,5/"

  Escenario: TC-D03 Las partidas durante una excedencia aprobada no restan
    # Sin la excedencia serían 1,5/3,5 = 43 %; con ella la pasada abierta no computa.
    Dado que he iniciado sesión como "QA Admin FOE"
    Entonces la asistencia anual de "QA Junta 2" muestra "60% (1,5/2,5)"
    Y la asistencia anual de "QA Junta 2" muestra "Cumple mínimo anual FOE (60%)"

  Escenario: TC-D04 Cerrar el acta con asistencia actualiza el % del jugador
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto la partida "QA FOE · Partida pasada abierta"
    Cuando marco la asistencia de "QA Jugador FOE"
    Y pulso "Guardar asistencia y bloquear partida" en el detalle
    Entonces veo el aviso "Asistencia guardada y partida bloqueada."
    Cuando pulso "Cerrar" en el detalle
    Entonces la asistencia anual de "QA Jugador FOE" muestra "57% (2/3,5)"

  # Regresión del bug (c), corregido en bfdc0e2: la recarga al abrir el detalle reiniciaba el
  # borrador de asistencia y borraba lo ya marcado. La recarga se retrasa a propósito.
  Escenario: TC-D05 Una marca hecha nada más abrir la partida no se pierde con la recarga
    Dado que he iniciado sesión como "QA Junta 2"
    Y que la recarga del detalle de partida tarda 1500 ms
    Cuando abro el detalle de la partida "QA FOE · Partida finalizada" sin esperar a la recarga
    Y desmarco la asistencia de "QA Admin FOE" antes de que llegue la recarga
    Y espero a que llegue la recarga
    Entonces la asistencia de "QA Admin FOE" sigue desmarcada
    Cuando pulso "Guardar asistencia y bloquear partida" en el detalle
    Entonces veo el aviso "Asistencia guardada y partida bloqueada."
    Cuando recargo la página
    Entonces la asistencia anual de "QA Admin FOE" muestra "0% (0/3,5)"
