# language: es
@b-eventos
Característica: Ciclo de vida de las partidas
  Un admin crea, edita, cancela, reactiva y elimina las partidas de su equipo, y cierra el acta.
  Un acta cerrada solo se reabre si la aprueban los demás responsables del equipo.
  (Mismos casos que la suite B de qa-playwright y qa-selenium.)

  Escenario: TC-B01 Crear partida valida los campos obligatorios
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando abro el formulario de nueva partida
    Y vacío la fecha de la partida
    Y pulso "Crear partida" en el formulario
    Entonces el formulario avisa "El título de la partida es obligatorio."
    Cuando escribo el título de partida "QA E2E · Validación"
    Y pulso "Crear partida" en el formulario
    Entonces el formulario avisa "Selecciona la fecha de la partida."
    Cuando pongo la fecha de la partida dentro de 15 días
    Y pulso "Crear partida" en el formulario
    Entonces el formulario avisa "Indica el campo de juego."

  Escenario: TC-B01b Un admin crea una partida y aparece en la lista
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando abro el formulario de nueva partida
    Y escribo el título de partida "QA E2E · Partida creada con Cucumber"
    Y pongo la fecha de la partida dentro de 15 días
    Y pongo la hora "10:00"
    Y escribo el campo de juego "Campo QA E2E"
    Y pulso "Crear partida" en el formulario
    Entonces veo el aviso "Partida creada para MAD Irregulars."
    Y el formulario se cierra
    Y en la lista está la partida "QA E2E · Partida creada con Cucumber"

  Escenario: TC-B02 Cancelar una partida sin contar asistencia
    Dado que he iniciado sesión como "QA Admin MAD"
    Y he abierto la partida "QA MAD · Partida próxima"
    Cuando cancelo la partida sin contar asistencia por "Lluvia (QA)"
    Entonces veo el aviso "Partida cancelada y descontada del total de partidas."
    Y veo "CANCELADA · NO CUENTA" en el detalle
    Y veo el botón "Reactivar partida" en el detalle

  Escenario: TC-B02b Cancelar una partida contando asistencia permite pasar lista
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto la partida "QA FOE · Partida próxima"
    Cuando cancelo la partida contando asistencia
    Entonces veo el aviso "Partida cancelada (cuenta asistencia"
    Y veo "CANCELADA · CUENTA ASISTENCIA" en el detalle

  Escenario: TC-B03 Cerrar el acta bloquea la partida en solo lectura
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto la partida "QA FOE · Partida finalizada"
    Cuando pulso "Guardar asistencia y bloquear partida" en el detalle
    Entonces veo el aviso "Asistencia guardada y partida bloqueada."
    Y veo "Partida cerrada y bloqueada" en el detalle
    Y no veo el botón "Editar partida" en el detalle
    Y no veo el botón "Cancelar partida" en el detalle

  Escenario: TC-B04 Un jugador no puede editar ni cancelar partidas ajenas
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando abro la partida "QA FOE · MilSim próxima"
    Entonces no veo el botón "Editar partida" en el detalle
    Y no veo el botón "Cancelar partida" en el detalle

  Escenario: TC-B05 Un admin edita una partida de su equipo
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando pulso "Editar" en la partida "QA MAD · Partida a editar"
    Y escribo el título de partida "QA MAD · Partida editada con Cucumber"
    Y pulso "Guardar cambios" en el formulario
    Entonces veo el aviso "Partida actualizada."
    Y el formulario se cierra
    Y en la lista está la partida "QA MAD · Partida editada con Cucumber"
    Y en la lista no está la partida "QA MAD · Partida a editar"

  Escenario: TC-B06 Reactivar una partida cancelada
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto la partida "QA FOE · Partida cancelada"
    Cuando pulso "Reactivar partida" en el detalle
    Entonces veo el aviso "Partida reactivada."
    Y no veo "CANCELADA · NO CUENTA" en el detalle
    Y veo el botón "Cancelar partida" en el detalle

  Escenario: TC-B07 Eliminar una partida pide confirmación y la borra del servidor
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando pulso "Eliminar" en la partida "QA MAD · Partida a eliminar"
    Entonces la partida "QA MAD · Partida a eliminar" muestra el botón "Cancelar"
    Cuando pulso "Confirmar eliminar partida" en la partida "QA MAD · Partida a eliminar"
    Entonces veo el aviso "Partida eliminada."
    Y en la lista no está la partida "QA MAD · Partida a eliminar"
    Cuando recargo la página
    Entonces en la lista está la partida "QA MAD · Partida próxima"
    Y en la lista no está la partida "QA MAD · Partida a eliminar"

  Escenario: TC-B08 Una partida cerrada no se puede editar ni eliminar desde la lista
    Dado que he iniciado sesión como "QA Admin MAD"
    Cuando abro la pestaña "Partidas"
    Entonces la partida "QA MAD · Partida cerrada" muestra el botón "Ver acta / Desbloquear"
    Y la partida "QA MAD · Partida cerrada" no muestra el botón "Editar"
    Y la partida "QA MAD · Partida cerrada" no muestra el botón "Eliminar"

  Escenario: TC-B09 Un jugador no puede pedir el desbloqueo de un acta
    Dado que he iniciado sesión como "QA Jugador MAD"
    Cuando abro la partida "QA MAD · Partida cerrada"
    Entonces veo "Partida cerrada y bloqueada" en el detalle
    Y no veo el botón "Solicitar desbloqueo para editar" en el detalle

  Escenario: TC-B10 Desbloquear un acta MAD: la pide su admin y la aprueba el super admin
    Dado que he iniciado sesión como "QA Admin MAD"
    Y he abierto la partida "QA MAD · Partida cerrada"
    Cuando pulso "Solicitar desbloqueo para editar" en el detalle
    Entonces veo el aviso "Solicitud enviada. Pendiente de aprobación por 1 responsable."
    Y veo "Solicitud de desbloqueo activa (iniciada por QA Admin MAD)" en el detalle
    Y veo "Aprobaciones necesarias (0/1):" en el detalle
    Dado que he iniciado sesión como "QA Super Admin"
    Y he abierto la partida "QA MAD · Partida cerrada"
    Cuando pulso "Aceptar desbloqueo" en el detalle
    Entonces veo el aviso "Todos han aprobado. Partida desbloqueada."
    Y no veo "Partida cerrada y bloqueada" en el detalle
    Y veo el botón "Editar partida" en el detalle

  Escenario: TC-B11 Desbloquear un acta FOE necesita a los otros dos responsables y se puede cancelar
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto la partida "QA FOE · Partida pasada abierta"
    Cuando pulso "Guardar asistencia y bloquear partida" en el detalle
    Entonces veo el aviso "Asistencia guardada y partida bloqueada."
    Cuando pulso "Solicitar desbloqueo para editar" en el detalle
    Entonces veo el aviso "Solicitud enviada. Pendiente de aprobación por 2 responsables."
    Dado que he iniciado sesión como "QA Junta 2"
    Y he abierto la partida "QA FOE · Partida pasada abierta"
    Entonces no veo el botón "Cancelar solicitud" en el detalle
    Cuando pulso "Aceptar desbloqueo" en el detalle
    Entonces veo el aviso "Tu aprobación ha quedado registrada."
    Y veo "Aprobaciones necesarias (1/2):" en el detalle
    Y veo "Partida cerrada y bloqueada" en el detalle
    Dado que he iniciado sesión como "QA Admin FOE"
    Y he abierto la partida "QA FOE · Partida pasada abierta"
    Cuando pulso "Cancelar solicitud" en el detalle
    Entonces veo el aviso "Solicitud de desbloqueo cancelada."
    Y veo el botón "Solicitar desbloqueo para editar" en el detalle
    Y veo "Partida cerrada y bloqueada" en el detalle
