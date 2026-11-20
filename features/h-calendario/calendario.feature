# language: es
@h-calendario
Característica: Fechas sin partida en el calendario
  Un admin marca vacaciones o días de "No se juega" para su equipo (el super admin, también
  para ambos) y cada equipo solo ve las suyas. Seed: "QA · Sin partida FOE" (+25 a +26) y
  "QA · Sin partida MAD" (+27). (Mismos casos que la suite H de qa-playwright y qa-selenium.)

  Escenario: TC-H01 Un admin marca fechas sin partida para su equipo
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando abro el formulario de fechas sin partida
    Y marco sin partida del día +40 al +42 por "QA E2E · Puente Cucumber"
    Entonces veo el aviso "Fechas de vacaciones / \"No se juega\" guardadas."
    Y el formulario de fechas sin partida se cierra
    Y el listado de fechas sin partida tiene "QA E2E · Puente Cucumber" para el día +40 al +42 de "MAD Irregulars"

  Escenario: TC-H02 La fecha de fin no puede ser anterior a la de inicio
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando abro el formulario de fechas sin partida
    Y marco sin partida del día +50 al +45 por "QA E2E · Fechas al revés"
    Entonces el navegador no deja enviar el formulario porque el fin es anterior al inicio
    Y en el calendario no veo la fecha sin partida "QA E2E · Fechas al revés"

  Escenario: TC-H03 Un admin de un solo equipo no puede marcar fechas para ambos
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando abro el formulario de fechas sin partida
    Entonces el equipo afectado solo puede ser:
      | MAD Irregulars |

  Escenario: TC-H04 El super admin puede marcar fechas para ambos equipos
    Dado que he iniciado sesión como "QA Super Admin"
    Cuando abro el formulario de fechas sin partida
    Entonces el equipo afectado solo puede ser:
      | MAD Irregulars                       |
      | FOE                                  |
      | Ambos equipos (MAD Irregulars y FOE) |
    Y en el calendario veo la fecha sin partida "QA · Sin partida FOE"
    Y en el calendario veo la fecha sin partida "QA · Sin partida MAD"

  Escenario: TC-H05 Cada equipo solo ve sus fechas y un jugador no puede quitarlas
    Dado que he iniciado sesión como "QA Jugador MAD"
    Entonces en el calendario veo la fecha sin partida "QA · Sin partida MAD"
    Y la fecha sin partida "QA · Sin partida MAD" no se puede quitar
    Y en el calendario no veo la fecha sin partida "QA · Sin partida FOE"
    Y no puedo marcar fechas sin partida

  Escenario: TC-H06 Un admin quita las fechas de su equipo y no persisten al recargar
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando quito la fecha sin partida "QA · Sin partida MAD"
    Entonces veo el aviso "Fechas eliminadas del calendario."
    Y en el calendario no veo la fecha sin partida "QA · Sin partida MAD"
    Cuando recargo la página
    Entonces en el calendario no veo la fecha sin partida "QA · Sin partida MAD"

  Escenario: TC-H07 Un día sin partida se avisa al seleccionarlo en el calendario
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando selecciono en el calendario la fecha sin partida "QA · Sin partida FOE"
    Entonces el día avisa "No se juega (FOE):" con el motivo "QA · Sin partida FOE"
