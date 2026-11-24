# language: es
@f-excedencias
Característica: Excedencias FOE
  Las solicita el jugador, las concede la Junta Directiva y nadie se concede la suya. Duran
  entre 1 mes y 1 año (Art. 18 y 19).

  Escenario: TC-F01 Un jugador solicita una excedencia y queda pendiente de la Junta
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando solicito una excedencia del día +40 al +80 por "Excedencia E2E · lesión"
    Entonces veo el aviso "Solicitud de excedencia enviada."
    Y la excedencia "Excedencia E2E · lesión" está "PENDIENTE DE JUNTA"
    Y la excedencia "Excedencia E2E · lesión" no se puede conceder

  Escenario: TC-F02 Una excedencia de menos de 1 mes se rechaza
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando solicito una excedencia del día +40 al +45 por "Excedencia E2E · corta"
    Entonces veo el aviso "La excedencia debe tener una duración mínima de 1 mes"
    Y no veo "Excedencia E2E · corta"

  Escenario: TC-F03 La Junta Directiva concede una solicitud pendiente
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando abro el panel de excedencias
    Entonces la excedencia "Solicitud QA pendiente" está "PENDIENTE DE JUNTA"
    Cuando concedo la excedencia "Solicitud QA pendiente"
    Entonces veo el aviso "Excedencia concedida."
    Y la excedencia "Solicitud QA pendiente" está "CONCEDIDA"

  Escenario: TC-F04 Nadie puede concederse su propia excedencia
    # QA Admin FOE es de la Junta Directiva, pero la solicitud es suya.
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando abro el panel de excedencias
    Entonces la excedencia "Solicitud QA propia" está "PENDIENTE DE JUNTA"
    Y la excedencia "Solicitud QA propia" no se puede conceder

  Escenario: TC-F05 Un jugador sin cargo no puede conceder excedencias
    Dado que he iniciado sesión como "QA Jugador FOE"
    Cuando abro el panel de excedencias
    Entonces no veo el botón "Conceder"
    Y no veo el botón "Conceder y aplicar excedencia"
