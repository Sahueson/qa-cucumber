# qa-cucumber

**Cucumber-JS** con escenarios en **Gherkin en español** (`# language: es`) y **Playwright** como
navegador, contra **Tactical Calendar** (staging). Forma parte de Ivan QA Lab: la web lanza cada
suite en GitHub Actions y muestra resultados y capturas.

Cubre las suites con más reglas de negocio, escritas para que las lea alguien que no programa:

- `features/c-inscripciones/` — plazo de 48 h, excedencias, equipación preseleccionada…
- `features/e-gobernanza/` — expedientes de la Junta Directiva, recusación, cuórum y escalado de faltas.

Los escenarios tienen los mismos códigos y nombres que en qa-playwright y qa-selenium
(`TC-C01 …`), así que en la web se comparan herramientas caso a caso. Hay ejemplos de
`Esquema del escenario` con `Ejemplos` (TC-C05/C06, TC-E04/E05) y de tabla de datos (TC-E01).

```
features/<suite>/*.feature     Gherkin en español
src/steps/*.steps.ts           pasos (comunes, inscripciones, gobernanza)
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
