import { setDefaultTimeout, setWorldConstructor, World, type IWorldOptions } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import type { Browser, BrowserContext, Page } from "playwright";
import * as path from "path";
import { AppPage } from "./app-page";

// Cada escenario es un usuario entrando en la app: hasta 3 logins en los más largos.
setDefaultTimeout(90_000);

// Usuarios QA: la fuente única es users.json de ivan-qa-lab-shared (el mismo que usa el reset).
type QaUser = { key: string; email: string; nickname: string };
const users: QaUser[] = require(path.resolve(__dirname, "../../shared/reset-staging/users.json"));

/** Los .feature nombran a los usuarios como en la app ("QA Junta 2"), no por su clave interna. */
export function userByNickname(nickname: string): QaUser {
  const user = users.find((u) => u.nickname === nickname);
  if (!user) throw new Error(`No hay usuario QA con el nombre «${nickname}»`);
  return user;
}

export class QaWorld extends World {
  context!: BrowserContext;
  page!: Page;
  app!: AppPage;
  /** Rol con el que corre el escenario (columna "role" de la web): el primer usuario que entra. */
  role: string | null = null;

  constructor(options: IWorldOptions) {
    super(options);
  }

  async open(browser: Browser) {
    const baseURL = process.env.BASE_URL;
    if (!baseURL) throw new Error("Falta BASE_URL (el demo de staging)");
    // Mismo viewport que Playwright por defecto, para comparar capturas.
    this.context = await browser.newContext({ baseURL, viewport: { width: 1280, height: 720 }, locale: "es-ES" });
    this.page = await this.context.newPage();
    this.app = new AppPage(this.page);
  }

  /** Entra con un usuario QA. Admite cambiar de usuario dentro del mismo escenario. */
  async loginAs(nickname: string) {
    const password = process.env.QA_PASSWORD;
    if (!password) throw new Error("Falta QA_PASSWORD");
    const user = userByNickname(nickname);
    this.role ??= user.nickname;
    if (this.page.url().startsWith("http")) {
      await this.page.evaluate(() => { localStorage.clear(); sessionStorage.clear(); });
    }
    await this.app.goto();
    await this.app.login(user.email, password);
    await expect(this.app.loginButton).toBeHidden();
    await this.app.waitForQuietNetwork(); // carga inicial de datos tras el login
    return user;
  }
}

setWorldConstructor(QaWorld);
