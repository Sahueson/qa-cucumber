import { Then, When, type DataTable } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import type { QaWorld } from "../support/world";
import { buttonText } from "../support/app-page";

// Suite E · Gobernanza FOE: votaciones y expedientes de la Junta Directiva.

const VOTE_BUTTONS = /^(A favor de sancionar|En contra de sancionar)/;

When(/^(?:abro|he abierto) las votaciones de la Junta Directiva$/, async function (this: QaWorld) {
  await this.app.openFoeSection("Votos · Junta Directiva");
});

When("convoco una votación de sanción con estos datos:", async function (this: QaWorld, table: DataTable) {
  const data = table.rowsHash() as Record<"operador" | "gravedad" | "artículo" | "hechos", string>;
  const page = this.app.page;
  await page.getByRole("button", { name: "+ Nueva votación" }).click();
  const form = page.locator("form").filter({ hasText: "Convocar votación en Junta Directiva" });
  await this.app.chooseOption(form.getByTestId("foe-poll-topic-select"), "Votación de sanción a operador");
  await this.app.chooseOption(form.getByTestId("foe-sanction-target-select"), data.operador);
  await this.app.chooseOption(form.getByTestId("foe-sanction-severity-select"), data.gravedad);
  await form.getByPlaceholder(/Art\. 51\.i/).fill(data["artículo"]);
  await form.getByPlaceholder(/Explica los hechos/).fill(data.hechos);
  await form.getByRole("button", { name: "Publicar votación" }).click();
});

When("voto {string} en el expediente {string}", async function (this: QaWorld, option: string, title: string) {
  await this.app.pollCard(title).getByRole("button", { name: new RegExp(`^${option}`) }).click();
});

When("pulso {string} en el expediente {string}", async function (this: QaWorld, name: string, title: string) {
  await buttonText(this.app.pollCard(title), name).click();
});

Then("el expediente {string} muestra {string}", async function (this: QaWorld, title: string, text: string) {
  await expect(this.app.pollCard(title).getByText(text, { exact: false }).first()).toBeVisible();
});

Then("puedo votar en el expediente {string}", async function (this: QaWorld, title: string) {
  const buttons = this.app.pollCard(title).getByRole("button", { name: VOTE_BUTTONS });
  await expect(buttons.first()).toBeEnabled();
});

Then("no puedo votar en el expediente {string}", async function (this: QaWorld, title: string) {
  const buttons = this.app.pollCard(title).getByRole("button", { name: VOTE_BUTTONS });
  await expect(buttons).toHaveCount(2);
  for (const b of await buttons.all()) await expect(b).toBeDisabled();
});

Then("no veo el botón {string} en el expediente {string}", async function (this: QaWorld, name: string, title: string) {
  await expect(buttonText(this.app.pollCard(title), name)).toBeHidden();
});
