import { After, AfterAll, Before, BeforeAll, Status } from "@cucumber/cucumber";
import { chromium, type Browser } from "playwright";
import * as fs from "fs";
import * as path from "path";
import type { QaWorld } from "./world";

// Un navegador para toda la ejecución y un contexto (sesión limpia) por escenario.
let browser: Browser;
const startedAt = new Date();
const EVIDENCE_DIR = "evidence";

type TestResult = {
  name: string;
  status: "passed" | "failed" | "skipped";
  duration_ms: number;
  role: string | null;
  error: string | null;
  evidence_path: string | null;
};
const results: TestResult[] = [];

const slug = (s: string) =>
  s.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase()
    .replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "").slice(0, 80);
const stripAnsi = (s: string) => s.replace(/\u001b\[[0-9;]*m/g, "");
// Defensa extra: si la contraseña QA apareciera en un error, no se publica.
const redact = (s: string) => {
  const pwd = process.env.QA_PASSWORD;
  return pwd ? s.split(pwd).join("***") : s;
};

/**
 * result.json en el formato común del lab (el mismo que qa-playwright y qa-selenium). Las
 * capturas van en evidence_path; shared/publish-results.js las sube y cierra el run. Se
 * reescribe tras cada escenario: si la ejecución se corta, lo que ya terminó no se pierde.
 */
function writeResults() {
  const finishedAt = new Date();
  const count = (s: TestResult["status"]) => results.filter((r) => r.status === s).length;
  fs.writeFileSync("result.json", JSON.stringify({
    tool: "cucumber",
    target: "tactical-calendar",
    suite: process.env.SUITE ?? "local",
    started_at: startedAt.toISOString(),
    finished_at: finishedAt.toISOString(),
    duration_ms: finishedAt.getTime() - startedAt.getTime(),
    summary: { total: results.length, passed: count("passed"), failed: count("failed"), skipped: count("skipped") },
    tests: results,
  }, null, 2));
}

BeforeAll(async () => {
  browser = await chromium.launch();
  fs.mkdirSync(EVIDENCE_DIR, { recursive: true });
});

AfterAll(async () => {
  await browser?.close();
});

// Cada suite (carpeta de features/) parte del seed, igual que en Playwright y Selenium. La
// reserva del staging ya la tiene with-staging.js (QA_LOCK_HELD=1): aquí solo se resetea.
let lastSuite: string | null = null;
Before(async function ({ pickle }) {
  const suite = path.basename(path.dirname(pickle.uri));
  if (suite !== lastSuite && process.env.STG_URL) {
    const { reset } = require(path.resolve(__dirname, "../../shared/reset-staging/reset.js"));
    await reset({ log: () => {} });
  }
  lastSuite = suite;
});

Before(async function (this: QaWorld) {
  (this as any).__start = Date.now();
  await this.open(browser);
});

// Captura JPEG al final de cada escenario (pase o falle): es la única evidencia que se publica,
// nunca trazas ni logs, que llevan la contraseña QA y tokens.
After(async function (this: QaWorld, { pickle, result }) {
  let evidence: string | null = null;
  try {
    const file = path.join(EVIDENCE_DIR, `${slug(pickle.name)}.jpg`);
    await this.page.screenshot({ path: file, type: "jpeg", quality: 60 });
    evidence = file;
  } catch {
    // sin captura (p. ej. el navegador ya se cerró)
  }
  await this.context?.close();

  const status = result?.status === Status.PASSED ? "passed"
    : result?.status === Status.SKIPPED ? "skipped" : "failed";
  results.push({
    name: pickle.name,
    status,
    duration_ms: Date.now() - (this as any).__start,
    role: this.role,
    error: status === "failed" && result?.message ? redact(stripAnsi(result.message).split("\n")[0]) : null,
    evidence_path: evidence,
  });
  writeResults();
});
