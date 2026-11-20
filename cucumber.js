// Cucumber-JS + Playwright (biblioteca) contra Tactical Calendar (staging).
// Los .feature están en español (# language: es); una carpeta por suite, como en qa-playwright.
module.exports = {
  default: {
    requireModule: ["tsx/cjs"],
    require: ["src/support/**/*.ts", "src/steps/**/*.ts"],
    format: ["progress"],
    publishQuiet: true,
  },
};
