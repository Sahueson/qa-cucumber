import { Given, Then, When } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import type { QaWorld } from "../support/world";

// Pasos comunes a todas las features: login, abrir partidas y comprobar lo que se ve.

Given("que he iniciado sesión como {string}", async function (this: QaWorld, nickname: string) {
  await this.loginAs(nickname);
});

When(/^(?:abro|he abierto) la partida "([^"]+)"$/, async function (this: QaWorld, title: string) {
  await this.app.openEvent(title);
});

Then("veo el aviso {string}", async function (this: QaWorld, text: string) {
  await this.app.expectToast(text);
});

When("pulso {string} en el detalle", async function (this: QaWorld, name: string) {
  await this.app.modal.getByRole("button", { name, exact: true }).click();
});

Then("veo {string} en el detalle", async function (this: QaWorld, text: string) {
  await expect(this.app.modal.getByText(text).first()).toBeVisible();
});

Then("no veo {string} en el detalle", async function (this: QaWorld, text: string) {
  await expect(this.app.modal.getByText(text)).toHaveCount(0);
});

Then("veo el botón {string} en el detalle", async function (this: QaWorld, name: string) {
  await expect(this.app.modal.getByRole("button", { name, exact: true })).toBeVisible();
});

Then("no veo el botón {string} en el detalle", async function (this: QaWorld, name: string) {
  await expect(this.app.modal.getByRole("button", { name, exact: true })).toBeHidden();
});
