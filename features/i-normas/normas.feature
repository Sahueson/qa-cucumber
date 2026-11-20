# language: es
@i-normas
Característica: Normas del equipo (PDF en un bucket privado)
  Los admins publican los estatutos en PDF; se sirven con un enlace firmado y temporal, nunca
  por una URL pública, y al borrarlos desaparece también el fichero. Cada equipo solo ve los
  suyos. (Mismos casos que la suite I de qa-playwright y qa-selenium.)

  Escenario: TC-I01 Subir unos estatutos: se ven con enlace firmado y la URL pública no los sirve
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando subo unos estatutos en PDF titulados "QA E2E · Estatutos Cucumber"
    Entonces veo el documento "QA E2E · Estatutos Cucumber"
    Y el enlace del documento es un enlace firmado del bucket privado que sirve el PDF
    Y la URL pública del documento no lo sirve

  Escenario: TC-I02 Eliminar un documento borra también el fichero
    Dado que recojo las credenciales con las que la app habla con Supabase
    Y que he iniciado sesión como "QA Admin FOE"
    Cuando subo unos estatutos en PDF titulados "QA E2E · Estatutos a borrar"
    Y guardo el enlace del documento
    Y pulso "Eliminar"
    Entonces veo el aviso "Documento eliminado."
    Y no veo el documento "QA E2E · Estatutos a borrar"
    Y Storage ya no tiene el fichero del documento

  Escenario: TC-I03 El formulario exige título y solo acepta PDF
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando abro el formulario para subir un PDF
    Y pulso "Publicar PDF" en el formulario del PDF
    Entonces el formulario del PDF avisa "Indica un título para el documento."
    Cuando elijo un fichero que no es PDF
    Entonces el formulario del PDF avisa "Solo se permiten archivos en formato PDF (.pdf)."
    Cuando escribo el título de documento "QA E2E · Sin fichero"
    Y pulso "Publicar PDF" en el formulario del PDF
    Entonces el formulario del PDF avisa "Selecciona un archivo PDF."

  Escenario: TC-I04 Un jugador ve las normas de su equipo pero no puede subir ni borrar
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando subo unos estatutos en PDF titulados "QA E2E · Normas para jugadores"
    Dado que he iniciado sesión como "QA Jugador FOE"
    Entonces veo el documento "QA E2E · Normas para jugadores"
    Y no veo el botón "+ Subir PDF"
    Y no veo el botón "Eliminar"

  Escenario: TC-I05 Un jugador de otro equipo no ve las normas del FOE
    Dado que he iniciado sesión como "QA Admin FOE"
    Cuando subo unos estatutos en PDF titulados "QA E2E · Normas solo FOE"
    Dado que he iniciado sesión como "QA Jugador MAD"
    Cuando abro la pestaña "Normas"
    Entonces veo "Todavía no hay estatutos o normativa publicados para MAD Irregulars."
    Y no veo el documento "QA E2E · Normas solo FOE"
