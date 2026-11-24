import { Given, Then, When } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import type { QaWorld } from "../support/world";
import { buttonText } from "../support/app-page";

// Suite H (fechas sin partida del calendario) y suite I (PDF de Normas en el bucket privado).

const inDays = (days: number) => {
  const d = new Date();
  d.setDate(d.getDate() + days);
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
};

// ---------- Calendario: vacaciones / "No se juega" ----------

const MARK = 'Marcar vacaciones / "No se juega"';
const blackoutForm = (w: QaWorld) =>
  w.page.locator("form").filter({ has: w.page.getByRole("button", { name: "Guardar fechas sin partida" }) });
/** Fila del listado "Vacaciones / Sin partida": <fila><botón "fechas · motivo"/><Quitar/></fila>. */
const blackoutRow = (w: QaWorld, reason: string) =>
  w.page.getByRole("button", { name: new RegExp(`· ${reason.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}$`) }).locator("xpath=..");

When("abro el formulario de fechas sin partida", async function (this: QaWorld) {
  await this.app.openTab("Calendario");
  await this.page.getByRole("button", { name: MARK }).click();
});

When("marco sin partida del día +{int} al +{int} por {string}", async function (this: QaWorld, from: number, to: number, reason: string) {
  const form = blackoutForm(this);
  await form.locator('input[type="date"]').nth(0).fill(inDays(from));
  await form.locator('input[type="date"]').nth(1).fill(inDays(to));
  await form.getByPlaceholder("Ej. Vacaciones de verano / Puente").fill(reason);
  await form.getByRole("button", { name: "Guardar fechas sin partida" }).click();
});

Then("el listado de fechas sin partida tiene {string} para el día +{int} al +{int} de {string}",
  async function (this: QaWorld, reason: string, from: number, to: number, squad: string) {
    await expect(blackoutRow(this, reason)).toContainText(`[${squad}] ${inDays(from)} → ${inDays(to)}`);
  });

Then("el navegador no deja enviar el formulario porque el fin es anterior al inicio", async function (this: QaWorld) {
  // "Hasta" lleva min = "Desde": la validación del propio navegador impide el envío (el mensaje
  // de la app no llega a salir).
  const end = blackoutForm(this).locator('input[type="date"]').nth(1);
  expect(await end.evaluate((el: HTMLInputElement) => el.validity.rangeUnderflow)).toBe(true);
  await expect(blackoutForm(this)).toBeVisible();
});

Then("el formulario de fechas sin partida se cierra", async function (this: QaWorld) {
  await expect(blackoutForm(this)).toBeHidden();
});

Then("el equipo afectado solo puede ser:", async function (this: QaWorld, table) {
  expect(await this.app.dropdownOptions(blackoutForm(this).getByTestId("blackout-squad-select"))).toEqual(table.raw().map((r: string[]) => r[0]));
});

Then("en el calendario veo la fecha sin partida {string}", async function (this: QaWorld, reason: string) {
  await this.app.openTab("Calendario");
  await expect(blackoutRow(this, reason)).toBeVisible();
});

Then("en el calendario no veo la fecha sin partida {string}", async function (this: QaWorld, reason: string) {
  await this.app.openTab("Calendario");
  await expect(blackoutRow(this, reason)).toHaveCount(0);
});

Then("la fecha sin partida {string} no se puede quitar", async function (this: QaWorld, reason: string) {
  await expect(blackoutRow(this, reason).getByRole("button", { name: "Quitar" })).toHaveCount(0);
});

Then("no puedo marcar fechas sin partida", async function (this: QaWorld) {
  await expect(this.page.getByRole("button", { name: MARK })).toBeHidden();
});

When("quito la fecha sin partida {string}", async function (this: QaWorld, reason: string) {
  await this.app.openTab("Calendario");
  await blackoutRow(this, reason).getByRole("button", { name: "Quitar" }).click();
});

When("selecciono en el calendario la fecha sin partida {string}", async function (this: QaWorld, reason: string) {
  await this.app.openTab("Calendario");
  // Pulsar la fila lleva el calendario a ese mes y selecciona el primer día.
  await this.page.getByRole("button", { name: new RegExp(`· ${reason}$`) }).click();
});

Then("el día avisa {string} con el motivo {string}", async function (this: QaWorld, notice: string, reason: string) {
  const aviso = this.page.getByText(notice);
  await expect(aviso).toBeVisible();
  await expect(aviso.locator("xpath=..")).toContainText(reason);
});

// ---------- Normas: PDF en el bucket privado team-documents ----------

const PDF = Buffer.from(
  "%PDF-1.4\n1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n2 0 obj<</Type/Pages/Kids[3 0 R]/Count 1>>endobj\n" +
    "3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 200 200]>>endobj\ntrailer<</Root 1 0 R>>\n%%EOF\n",
);
const uploadForm = (w: QaWorld) =>
  w.page.locator("form").filter({ has: w.page.getByRole("button", { name: "Publicar PDF" }) });
type NormasWorld = QaWorld & { docHref?: string; apikey?: string };

Given("que recojo las credenciales con las que la app habla con Supabase", async function (this: NormasWorld) {
  this.page.on("request", (r) => { this.apikey ||= r.headers()["apikey"] ?? ""; });
});

When("abro el formulario para subir un PDF", async function (this: QaWorld) {
  await this.app.openTab("Normas");
  await this.page.getByRole("button", { name: "+ Subir PDF" }).click();
});

When("subo unos estatutos en PDF titulados {string}", async function (this: QaWorld, title: string) {
  await this.app.openTab("Normas");
  await this.page.getByRole("button", { name: "+ Subir PDF" }).click();
  const form = uploadForm(this);
  await form.locator('input[type="file"]').setInputFiles({ name: "normas-qa.pdf", mimeType: "application/pdf", buffer: PDF });
  await form.getByPlaceholder("Ej. Estatutos Oficiales FOE").fill(title);
  await form.getByRole("button", { name: "Publicar PDF" }).click();
  await this.app.expectToast("Documento PDF publicado correctamente.");
  await expect(form).toBeHidden();
});

When("elijo un fichero que no es PDF", async function (this: QaWorld) {
  await uploadForm(this).locator('input[type="file"]').setInputFiles({ name: "notas.txt", mimeType: "text/plain", buffer: Buffer.from("hola") });
});

When("escribo el título de documento {string}", async function (this: QaWorld, title: string) {
  await uploadForm(this).getByPlaceholder("Ej. Estatutos Oficiales FOE").fill(title);
});

When("pulso {string} en el formulario del PDF", async function (this: QaWorld, name: string) {
  await buttonText(uploadForm(this), name).click();
});

Then("el formulario del PDF avisa {string}", async function (this: QaWorld, text: string) {
  await expect(uploadForm(this).locator(".modal__error")).toHaveText(text);
});

Then("veo el documento {string}", async function (this: QaWorld, title: string) {
  await this.app.openTab("Normas");
  await expect(this.page.getByText(title, { exact: true }).first()).toBeVisible();
});

Then("no veo el documento {string}", async function (this: QaWorld, title: string) {
  await expect(this.page.getByText(title, { exact: true })).toHaveCount(0);
});

Then("el enlace del documento es un enlace firmado del bucket privado que sirve el PDF", async function (this: NormasWorld) {
  const href = await this.page.getByRole("link", { name: "Pantalla completa" }).getAttribute("href");
  expect(href).toMatch(/\/storage\/v1\/object\/sign\/team-documents\/foe\/statutes\/.+\.pdf\?token=/);
  const res = await this.page.request.get(href!);
  expect(res.status()).toBe(200);
  expect((await res.body()).subarray(0, 5).toString()).toBe("%PDF-");
  this.docHref = href!;
});

Then("la URL pública del documento no lo sirve", async function (this: NormasWorld) {
  const publicUrl = this.docHref!.replace("/object/sign/", "/object/public/").replace(/\?.*$/, "");
  expect((await this.page.request.get(publicUrl)).ok()).toBe(false);
});

When("guardo el enlace del documento", async function (this: NormasWorld) {
  this.docHref = (await this.page.getByRole("link", { name: "Pantalla completa" }).getAttribute("href"))!;
});

Then("Storage ya no tiene el fichero del documento", async function (this: NormasWorld) {
  // No se reutiliza el enlace firmado (la CDN puede seguir sirviéndolo ~60 s tras borrar): se pide
  // al servidor un enlace NUEVO para esa ruta; si el fichero no existe, lo rechaza.
  const url = new URL(this.docHref!);
  const objectPath = url.pathname.replace(/^.*\/object\/sign\/team-documents\//, "");
  const token = await this.page.evaluate(() => {
    const key = Object.keys(localStorage).find((k) => k.endsWith("-auth-token"));
    return key ? JSON.parse(localStorage.getItem(key)!).access_token : null;
  });
  expect(token).toBeTruthy();
  expect(this.apikey).toBeTruthy();
  const res = await this.page.request.post(`${url.origin}/storage/v1/object/sign/team-documents/${objectPath}`, {
    headers: { apikey: this.apikey!, Authorization: `Bearer ${token}` },
    data: { expiresIn: 60 },
  });
  expect(res.ok(), `Storage aún firma ${objectPath}`).toBe(false);
});
