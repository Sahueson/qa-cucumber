# language: es
@j-demo-fallos
Característica: Demo de fallos
  Escenarios que FALLAN A PROPÓSITO (requisitos que la app no cumple) para enseñar cómo sale un fallo y su
  reporte de bug. No modifican nada. Mismos casos que la suite J de qa-playwright y qa-selenium.

  Escenario: TC-J01 El jugador MAD ve las partidas del equipo FOE (requisito inexistente)
    Dado que he iniciado sesión como "QA Jugador MAD"
    Entonces veo "QA FOE · Partida próxima"

  Escenario: TC-J02 El jugador FOE ve las partidas del equipo MAD (requisito inexistente)
    Dado que he iniciado sesión como "QA Jugador FOE"
    Entonces veo "QA MAD · Partida próxima"

  Escenario: TC-J03 El super admin dispone de un panel de métricas
    Dado que he iniciado sesión como "QA Super Admin"
    Entonces veo el encabezado "Panel de métricas"

  Escenario: TC-J04 El jugador sin equipo puede crear partidas
    Dado que he iniciado sesión como "QA Sin Equipo"
    Entonces veo el botón "Crear partida"

  Escenario: TC-J05 El jugador bloqueado sigue viendo el calendario de su equipo
    Dado que he iniciado sesión como "QA Bloqueado"
    Entonces veo "QA MAD · Partida próxima"

  Escenario: TC-J06 El admin MAD tiene una pestaña de Facturación
    Dado que he iniciado sesión como "QA Admin MAD"
    Entonces veo el botón "Facturación"

  Escenario: TC-J07 El jugador MAD puede exportar el calendario a PDF
    Dado que he iniciado sesión como "QA Jugador MAD"
    Entonces veo el botón "Exportar calendario (PDF)"
