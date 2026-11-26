// Cucumber-JS + Playwright (biblioteca) contra Tactical Calendar (staging).
// Los .feature están en español (# language: es); una carpeta por suite, como en qa-playwright.
module.exports = {
  default: {
    requireModule: ["tsx/cjs"],
    require: ["src/support/**/*.ts", "src/steps/**/*.ts"],
    // allure-results: lo lee Allure para el informe (pasos de Gherkin + captura final).
    format: ["progress", "allure-cucumberjs/reporter", "./src/support/live-formatter.cjs"],
    formatOptions: { resultsDir: "allure-results" },
    publishQuiet: true,
  },
};
