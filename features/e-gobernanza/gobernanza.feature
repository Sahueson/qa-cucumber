# language: es
@e-gobernanza
Característica: Gobernanza y régimen disciplinario FOE
  La Junta Directiva (QA Super Admin, QA Admin FOE y QA Junta 2) vota las sanciones. El
  recuento, el cierre y el escalado de faltas los decide el servidor. El seed deja cada
  expediente a falta del voto de QA Junta 2, salvo el de recusación.


  Escenario: TC-E01 La Junta Directiva abre un expediente sancionador
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto las votaciones de la Junta Directiva
    Cuando convoco una votación de sanción con estos datos:
      | operador  | QA Jugador FOE                                   |
      | gravedad  | Falta Grave                                      |
      | artículo  | Art. 36.2 — Baja < 48h                           |
      | hechos    | Baja sin aviso en la partida del domingo (E2E). |
    Entonces el expediente "Propuesta de Falta Grave a QA Jugador FOE" muestra "Art. 36.2 — Baja < 48h"
    Y puedo votar en el expediente "Propuesta de Falta Grave a QA Jugador FOE"

  Escenario: TC-E02 El propuesto para sanción queda recusado y no puede votar
    Dado que he iniciado sesión como "QA Junta 2"
    Cuando abro las votaciones de la Junta Directiva
    Entonces el expediente "QA · Sanción a QA Junta 2 (recusación)" muestra "Recusación (Art. 53.4)"
    Y no puedo votar en el expediente "QA · Sanción a QA Junta 2 (recusación)"

  Escenario: TC-E03 El expediente se cierra solo al votar el último miembro habilitado
    Dado que he iniciado sesión como "QA Junta 2"
    Y he abierto las votaciones de la Junta Directiva
    Cuando voto "A favor de sancionar" en el expediente "QA · Sanción con cuórum pendiente"
    Entonces veo el aviso "Sanción aprobada (2 a favor vs 0 en contra) y registrada"
    Y el expediente "QA · Sanción con cuórum pendiente" muestra "SANCIÓN APROBADA Y REGISTRADA"

  Esquema del escenario: <caso> La 3ª falta <gravedad> en un año se escala a <escala>
    Dado que he iniciado sesión como "QA Junta 2"
    Y he abierto las votaciones de la Junta Directiva
    Cuando voto "A favor de sancionar" en el expediente "<expediente>"
    Entonces veo el aviso "<aviso>"

    Ejemplos:
      | caso   | gravedad | escala    | expediente               | aviso                                                       |
      | TC-E04 | leve     | Grave     | QA · Tercera falta leve  | Escalada a Grave por 3ª falta leve en 1 año · Art. 51.k     |
      | TC-E05 | grave    | Muy Grave | QA · Tercera falta grave | Escalada a Muy Grave por 3ª falta grave en 1 año · Art. 50.m |

  Escenario: TC-E06 Con mayoría en contra el expediente se cierra sin sanción
    Dado que he iniciado sesión como "QA Junta 2"
    Y he abierto las votaciones de la Junta Directiva
    Cuando voto "En contra de sancionar" en el expediente "QA · Sanción a desestimar"
    Entonces veo el aviso "Votación cerrada (0 a favor vs 3 en contra). No se aplica sanción"
    Y el expediente "QA · Sanción a desestimar" muestra "SANCIÓN DESESTIMADA"

  Escenario: TC-E07 Solo quien convoca (o el super admin) puede cerrar una votación a mano
    # QA Junta 2 no convocó la votación del seed.
    Dado que he iniciado sesión como "QA Junta 2"
    Cuando abro las votaciones de la Junta Directiva
    Entonces no veo el botón "Cerrar y resolver" en el expediente "QA · Votación de la Junta Directiva"

  Escenario: TC-E08 Quien convocó la votación puede cerrarla a mano
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto las votaciones de la Junta Directiva
    Cuando pulso "Cerrar y resolver" en el expediente "QA · Votación de la Junta Directiva"
    Entonces veo el aviso "Votación cerrada y resultado fijado."
    Y no veo el botón "Cerrar y resolver" en el expediente "QA · Votación de la Junta Directiva"
