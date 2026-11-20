import { Given, Then, When, type DataTable } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import { userByNickname, type QaWorld } from "../support/world";

// Pasos generales de la app: acceso, navegación, partidas, fichas de jugador, excedencias,
// calendario y normas. Lo específico de inscripciones y gobernanza está en sus ficheros.

const inDays = (days: number) => {
  const d = new Date();
  d.setDate(d.getDate() + days);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
};

// ---------- Acceso ----------

Given("que abro la app sin iniciar sesión", async function (this: QaWorld) {
  this.role ??= "Visitante";
  await this.app.goto();
});

When("intento entrar como {string} con la contraseña {string}", async function (this: QaWorld, nickname: string, password: string) {
  this.role ??= "Visitante";
  await this.app.login(userByNickname(nickname).email, password);
});

Then("la página tiene título", async function (this: QaWorld) {
  await expect(this.page).toHaveTitle(/.+/);
});

Then("veo el formulario de acceso QA", async function (this: QaWorld) {
  await expect(this.app.loginButton).toBeVisible();
});

Then("veo la navegación con las pestañas:", async function (this: QaWorld, table: DataTable) {
  for (const [tab] of table.raw()) await expect(this.app.navTab(tab)).toBeVisible();
});

Then("no veo la navegación", async function (this: QaWorld) {
  await expect(this.app.nav).toBeHidden();
});

Then("veo la navegación", async function (this: QaWorld) {
  await expect(this.app.nav).toBeVisible();
});

Then("veo la pestaña {string}", async function (this: QaWorld, tab: string) {
  await expect(this.app.navTab(tab)).toBeVisible();
});

Then("no veo la pestaña {string}", async function (this: QaWorld, tab: string) {
  await expect(this.app.navTab(tab)).toBeHidden();
});

Then("mi nombre aparece en el botón de mi ficha", async function (this: QaWorld) {
  const nickname = this.role!;
  await expect(this.app.profileButton).toContainText(nickname);
});

When("cierro sesión", async function (this: QaWorld) {
  await this.app.logoutButton.click();
});

// ---------- Pantalla en general ----------

When("abro la pestaña {string}", async function (this: QaWorld, tab: string) {
  await this.app.openTab(tab);
});

When("pulso {string}", async function (this: QaWorld, name: string) {
  await this.page.getByRole("button", { name, exact: true }).click();
});

When("recargo la página", async function (this: QaWorld) {
  await this.page.reload();
  await this.app.waitForQuietNetwork();
});

Then("veo el encabezado {string}", async function (this: QaWorld, text: string) {
  await expect(this.page.getByRole("heading", { name: text })).toBeVisible();
});

Then("veo {string}", async function (this: QaWorld, text: string) {
  await expect(this.page.getByText(text).first()).toBeVisible();
});

Then("no veo {string}", async function (this: QaWorld, text: string) {
  await expect(this.page.getByText(text)).toHaveCount(0);
});

Then("veo el botón {string}", async function (this: QaWorld, name: string) {
  await expect(this.page.getByRole("button", { name, exact: true }).first()).toBeVisible();
});

Then("no veo el botón {string}", async function (this: QaWorld, name: string) {
  await expect(this.page.getByRole("button", { name, exact: true })).toHaveCount(0);
});

// ---------- Mi ficha de operador ----------

const ficha = (w: QaWorld) => w.app.modal.filter({ has: w.page.getByRole("heading", { name: "Tu ficha de operador" }) });

When("abro mi ficha de operador", async function (this: QaWorld) {
  await this.app.profileButton.click();
  await expect(ficha(this)).toBeVisible();
});

When("marco {string} en mi ficha", async function (this: QaWorld, option: string) {
  await ficha(this).getByRole("button", { name: new RegExp(`^${option}`) }).click();
});

When("guardo mi ficha", async function (this: QaWorld) {
  await ficha(this).getByRole("button", { name: "Guardar perfil" }).click();
});

Then("mi ficha tiene marcado {string}", async function (this: QaWorld, option: string) {
  await expect(ficha(this).getByRole("button", { name: new RegExp(`^${option} ✓`) })).toBeVisible();
});

Then("mi ficha está cerrada", async function (this: QaWorld) {
  await expect(ficha(this)).toBeHidden();
});

// ---------- Partidas ----------

Then("en la lista de partidas veo:", async function (this: QaWorld, table: DataTable) {
  const titles = await this.app.visibleEventTitles();
  for (const [t] of table.raw()) expect(titles.some((x) => x.includes(t)), `ve «${t}»`).toBe(true);
});

Then("todas las partidas de la lista son de {string}", async function (this: QaWorld, prefix: string) {
  const titles = await this.app.visibleEventTitles();
  expect(titles.every((x) => x.includes(prefix)), `solo «${prefix}»: ${titles.join(" | ")}`).toBe(true);
});

Then("ninguna partida de la lista es de {string}", async function (this: QaWorld, prefix: string) {
  const titles = await this.app.visibleEventTitles();
  expect(titles.every((x) => !x.includes(prefix)), `ninguna «${prefix}»: ${titles.join(" | ")}`).toBe(true);
});

Then("la lista no tiene partidas", async function (this: QaWorld) {
  await expect(this.page.locator("article.event-card")).toHaveCount(0);
});

When("pulso {string} en la partida {string}", async function (this: QaWorld, name: string, title: string) {
  await this.app.openTab("Partidas");
  await this.app.eventCard(title).getByRole("button", { name, exact: true }).click();
});

Then("la partida {string} muestra el botón {string}", async function (this: QaWorld, title: string, name: string) {
  await expect(this.app.eventCard(title).getByRole("button", { name, exact: true })).toBeVisible();
});

Then("la partida {string} no muestra el botón {string}", async function (this: QaWorld, title: string, name: string) {
  await expect(this.app.eventCard(title).getByRole("button", { name, exact: true })).toHaveCount(0);
});

Then("en la lista está la partida {string}", async function (this: QaWorld, title: string) {
  await this.app.openTab("Partidas");
  await expect(this.app.eventCard(title)).toBeVisible();
});

Then("en la lista no está la partida {string}", async function (this: QaWorld, title: string) {
  await this.app.openTab("Partidas");
  await expect(this.app.eventCard(title)).toHaveCount(0);
});

// Formularios de partida (nueva y edición).
const eventForm = (w: QaWorld, heading: string) => w.app.modal.filter({ has: w.page.getByRole("heading", { name: heading }) });
const openForm = (w: QaWorld) => eventForm(w, "Nueva partida").or(eventForm(w, "Editar partida"));

When("abro el formulario de nueva partida", async function (this: QaWorld) {
  await this.app.newEventButton.click();
});

When("vacío la fecha de la partida", async function (this: QaWorld) {
  await openForm(this).locator('input[type="date"]').fill("");
});

When("escribo el título de partida {string}", async function (this: QaWorld, title: string) {
  await openForm(this).getByPlaceholder("Ej. Dominical CQB / Operación Tormenta").fill(title);
});

When("pongo la fecha de la partida dentro de {int} días", async function (this: QaWorld, days: number) {
  await openForm(this).locator('input[type="date"]').fill(inDays(days));
});

When("pongo la hora {string}", async function (this: QaWorld, hour: string) {
  await openForm(this).locator('input[type="time"]').fill(hour);
});

When("escribo el campo de juego {string}", async function (this: QaWorld, field: string) {
  await openForm(this).getByPlaceholder("Ej. El Cortijo / Bunker / Campo Norte").fill(field);
});

When("pulso {string} en el formulario", async function (this: QaWorld, name: string) {
  await openForm(this).getByRole("button", { name, exact: true }).click();
});

Then("el formulario avisa {string}", async function (this: QaWorld, text: string) {
  await expect(openForm(this).locator(".modal__error")).toHaveText(text);
});

Then("el formulario se cierra", async function (this: QaWorld) {
  await expect(openForm(this)).toHaveCount(0);
});

When("cancelo la partida sin contar asistencia por {string}", async function (this: QaWorld, reason: string) {
  await this.app.modal.getByRole("button", { name: "Cancelar partida" }).click();
  await this.app.modal.getByLabel(/No contar asistencia/).check();
  await this.app.modal.getByPlaceholder("Ej. Lluvia / Campo cerrado / Falta de jugadores").fill(reason);
  await this.app.modal.getByRole("button", { name: "Confirmar cancelación" }).click();
});

When("cancelo la partida contando asistencia", async function (this: QaWorld) {
  await this.app.modal.getByRole("button", { name: "Cancelar partida" }).click();
  await this.app.modal.getByLabel(/Sí, contar asistencia/).check();
  await this.app.modal.getByRole("button", { name: "Confirmar cancelación" }).click();
});

// ---------- Asistencia ----------

const regCheckbox = (w: QaWorld, nickname: string) =>
  w.app.modal.locator(".event-detail__reg-row").filter({ hasText: nickname }).getByRole("checkbox");

When("marco la asistencia de {string}", async function (this: QaWorld, nickname: string) {
  await regCheckbox(this, nickname).check();
  await expect(regCheckbox(this, nickname)).toBeChecked();
});

Then("la asistencia anual de {string} muestra {string}", async function (this: QaWorld, nickname: string, text: string) {
  await this.app.openTab("Jugadores");
  await expect(this.app.attendanceOf(nickname)).toContainText(text);
});

// TC-D05: la recarga del detalle se retrasa a propósito para que llegue SIEMPRE después de la marca.
Given("que la recarga del detalle de partida tarda {int} ms", async function (this: QaWorld, ms: number) {
  const w = this as QaWorld & { reloadDone?: boolean };
  w.reloadDone = false;
  await this.page.route(/\/rest\/v1\/event_registrations/, async (route) => {
    if (route.request().method() !== "GET") return route.continue();
    await new Promise((r) => setTimeout(r, ms));
    await route.continue();
    w.reloadDone = true;
  });
});

When("abro el detalle de la partida {string} sin esperar a la recarga", async function (this: QaWorld, title: string) {
  await this.app.openTab("Partidas");
  await this.app.eventCard(title).locator(".tactical-btn--blue").click();
});

When("desmarco la asistencia de {string} antes de que llegue la recarga", async function (this: QaWorld, nickname: string) {
  // El borrador se rellena justo después de pintar el modal (en el primer instante sale vacío).
  await expect(regCheckbox(this, nickname)).toBeChecked();
  await regCheckbox(this, nickname).uncheck();
  expect((this as QaWorld & { reloadDone?: boolean }).reloadDone, "la marca va antes de la recarga").toBe(false);
});

When("espero a que llegue la recarga", async function (this: QaWorld) {
  await expect.poll(() => (this as QaWorld & { reloadDone?: boolean }).reloadDone, { timeout: 15_000 }).toBe(true);
  await this.app.waitForQuietNetwork();
  await this.page.unroute(/\/rest\/v1\/event_registrations/);
});

Then("la asistencia de {string} sigue desmarcada", async function (this: QaWorld, nickname: string) {
  await expect(regCheckbox(this, nickname)).not.toBeChecked();
});

// ---------- Fichas de jugador (pestaña Jugadores) ----------

const roleSelect = (w: QaWorld, nickname: string) =>
  w.app.playerCard(nickname).locator("select").filter({ has: w.page.locator('option[value="super_admin"]') });

When("cambio el rol de {string} a {string}", async function (this: QaWorld, nickname: string, role: string) {
  await this.app.openTab("Jugadores");
  await roleSelect(this, nickname).selectOption(role);
});

When("pulso {string} en la ficha de {string}", async function (this: QaWorld, name: string, nickname: string) {
  await this.app.openTab("Jugadores");
  await this.app.playerCard(nickname).getByRole("button", { name, exact: true }).click();
});

When("asigno el equipo {string} a {string}", async function (this: QaWorld, squad: string, nickname: string) {
  await this.app.openTab("Jugadores");
  await this.app.playerCard(nickname).locator("select").filter({ hasText: "+ Añadir otro equipo" }).selectOption(squad);
});

Then("veo la ficha de {string}", async function (this: QaWorld, nickname: string) {
  await this.app.openTab("Jugadores");
  await expect(this.app.playerCard(nickname)).toBeVisible();
});

Then("no veo la ficha de {string}", async function (this: QaWorld, nickname: string) {
  await expect(this.app.playerCard(nickname)).toHaveCount(0);
});

Then("la ficha de {string} muestra el botón {string}", async function (this: QaWorld, nickname: string, name: string) {
  await expect(this.app.playerCard(nickname).getByRole("button", { name, exact: true })).toBeVisible();
});

Then("la ficha de {string} no muestra el botón {string}", async function (this: QaWorld, nickname: string, name: string) {
  await expect(this.app.playerCard(nickname).getByRole("button", { name, exact: true })).toHaveCount(0);
});

Then("la ficha de {string} muestra {string}", async function (this: QaWorld, nickname: string, text: string) {
  await expect(this.app.playerCard(nickname).getByText(text).first()).toBeVisible();
});

Then("la ficha de {string} no permite cambiar el rol", async function (this: QaWorld, nickname: string) {
  await expect(roleSelect(this, nickname)).toHaveCount(0);
});

Then("la ficha de {string} permite quitarle el equipo {string}", async function (this: QaWorld, nickname: string, squad: string) {
  await expect(this.app.playerCard(nickname).getByTitle(`Quitar de ${squad}`)).toBeVisible();
});

Then("la ficha de {string} no permite quitarle el equipo {string}", async function (this: QaWorld, nickname: string, squad: string) {
  await expect(this.app.playerCard(nickname).getByTitle(`Quitar de ${squad}`)).toHaveCount(0);
});

Then("en la ficha de {string} el órgano {string} no se puede cambiar", async function (this: QaWorld, nickname: string, organ: string) {
  await expect(this.app.playerCard(nickname).getByRole("button", { name: new RegExp(organ) })).toBeDisabled();
});

// ---------- Excedencias ----------

When("abro el panel de excedencias", async function (this: QaWorld) {
  await this.app.openLeavesPanel();
});

When("solicito una excedencia del día +{int} al +{int} por {string}", async function (this: QaWorld, from: number, to: number, reason: string) {
  await this.app.openLeavesPanel();
  const dates = this.page.locator('form input[type="date"]');
  await dates.nth(0).fill(inDays(from));
  await dates.nth(1).fill(inDays(to));
  await this.page.getByPlaceholder(/Motivos laborales \/ Lesión/).fill(reason);
  await this.page.getByRole("button", { name: "Solicitar excedencia a Junta Directiva" }).click();
});

Then("la excedencia {string} está {string}", async function (this: QaWorld, reason: string, state: string) {
  await expect(this.app.leaveRow(reason)).toContainText(state);
});

Then("la excedencia {string} no se puede conceder", async function (this: QaWorld, reason: string) {
  await expect(this.app.leaveRow(reason).getByRole("button", { name: "Conceder" })).toBeHidden();
});

When("concedo la excedencia {string}", async function (this: QaWorld, reason: string) {
  await this.app.leaveRow(reason).getByRole("button", { name: "Conceder" }).click();
});
