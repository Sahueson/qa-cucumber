// No imprime nada: cuenta los escenarios que se van a ejecutar y lo avisa a la pantalla en vivo
// de la web (barra de progreso). El inicio y el resultado de cada escenario salen de hooks.ts.
// Es .cjs porque cucumber carga los formatters con import() y no pasan por tsx.
const path = require("path");
const { Formatter } = require("@cucumber/cucumber");
const live = require(path.resolve(__dirname, "../../shared/live-events.js"));

class LiveFormatter extends Formatter {
  constructor(options) {
    super(options);
    let total = 0;
    options.eventBroadcaster.on("envelope", (envelope) => {
      if (envelope.pickle) total++;
      if (envelope.testRunStarted) live.emit("plan", String(total));
    });
  }
}
module.exports = LiveFormatter;
