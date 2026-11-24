import { Then } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import type { QaWorld } from "../support/world";
import { buttonText } from "../support/app-page";

// Suite C · Inscripciones: formulario de inscripción del detalle de partida.

Then("la equipación preseleccionada es {string}", async function (this: QaWorld, gear: string) {
  await expect(this.app.registrationGear).toContainText(gear);
});

Then("el rol preseleccionado es {string}", async function (this: QaWorld, role: string) {
  await expect(this.app.registrationRole).toContainText(role);
});

Then("no veo ningún aviso de equipación", async function (this: QaWorld) {
  await expect(this.app.modal.getByText(/No tienes «.*» marcada/)).toBeHidden();
});

Then("en la lista de partidas {string} muestra el botón {string}", async function (this: QaWorld, title: string, name: string) {
  await this.app.openTab("Partidas");
  await expect(buttonText(this.app.eventCard(title), name)).toBeVisible();
});
