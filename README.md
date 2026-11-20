# qa-cucumber

**Cucumber-JS** con escenarios en **Gherkin en español** (`# language: es`) y **Playwright** como
navegador, contra **Tactical Calendar** (staging). Forma parte de Ivan QA Lab: la web lanza cada
suite en GitHub Actions y muestra resultados y capturas.

Cubre las 9 suites (70 escenarios), escritas para que las lea alguien que no programa:
acceso y roles, partidas, inscripciones, asistencia, gobernanza FOE, excedencias, jugadores,
calendario y normas.

Los escenarios tienen los mismos códigos y nombres que en qa-playwright, qa-selenium y
qa-cypress (`TC-C01 …`), así que en la web se comparan herramientas caso a caso. Hay ejemplos de
`Esquema del escenario` con `Ejemplos` (TC-C05/C06, TC-E04/E05), tablas de datos (TC-A01,
TC-E01, TC-H03) y escenarios con varios usuarios (TC-B10/B11, TC-G01…).

```
features/<suite>/*.feature     Gherkin en español
src/steps/*.steps.ts           pasos (app, comunes, inscripciones, gobernanza, calendario y normas)
src/support/world.ts           navegador, login QA por nombre ("QA Junta 2")
src/support/hooks.ts           reset por suite, captura JPEG y result.json común
src/support/app-page.ts        page object (copia del de qa-playwright)
```

## Ejecutar en local

```bash
ln -s ../ivan-qa-lab-shared shared   # en CI se clona
npm ci
set -a; . ~/.qa-lab.env; set +a
export BASE_URL=https://tactical-calendar-demo.vercel.app   # el demo, nunca PROD
SUITE=c-inscripciones,e-gobernanza ./run.sh
SUITE=c-inscripciones GREP='TC-C05' ./run.sh   # solo escenarios cuyo nombre encaja
```

`run.sh` reserva y resetea el staging con `shared/reset-staging/with-staging.js`; cada suite vuelve
a partir del seed. Nunca se publican trazas ni logs (llevan la contraseña QA): solo capturas.
