# 🤖 QA Agent Template — Guía de Operación

> **¿Primera vez aquí?** Empieza por la sección de Instalación.
> No necesitas saber programar para usar este agente.

---

## ¿Qué hace este agente?

Es un asistente de IA para equipos de QA. Funciona con **GitHub Copilot** (VS Code) y también con **Claude Code** (CLI de Anthropic). El mismo comando `npx` instala ambos.
Puedes pedirle cosas en lenguaje natural, por ejemplo:

- *"Analiza la US 9884 y prepara el test plan"*
- *"Ejecuta el Test Plan 10716, Suite 10717"*
- *"Registra 2 horas en Zoho para la US 9884, actividad Preparar TP"*

El agente entiende tu intención y ejecuta las acciones por ti en Azure DevOps, Zoho Projects
y la aplicación bajo prueba — todo sin que tengas que escribir código.

---

## ¿Qué puede hacer?

| Lo que le pides | Lo que hace |
|----------------|-------------|
| "Analiza esta US y crea los TCs" | Lee los criterios de aceptación, redacta Test Cases profesionales y los crea en Azure DevOps |
| "Ejecuta el Test Plan X" | Navega la app, ejecuta cada paso, toma screenshots y sube la evidencia a ADO |
| "Automatiza estos TCs con Playwright" | Genera código TypeScript reutilizable (archivos `.spec.ts`) para regresión |
| "Registra mis horas de hoy en Zoho" | Crea los time logs con el formato oficial aprobado en Zoho Projects |
| "Prepara el reporte del daily" | Genera el resumen de Logros + Trabajo del día listo para el standup |

---

## ✅ Requisitos previos

### Para GitHub Copilot (VS Code)

| Requisito | Cómo verificarlo | Dónde instalarlo si falta |
|-----------|-----------------|--------------------------|
| **Node.js 18+** | Terminal → `node -v` | [nodejs.org](https://nodejs.org) |
| **VS Code** | Abre VS Code | [code.visualstudio.com](https://code.visualstudio.com) |
| **GitHub Copilot** (extensión) | `Ctrl+Shift+X` → busca "GitHub Copilot" | Marketplace de VS Code |
| **MCP Azure DevOps** configurado | El agente conecta a ADO sin errores | Pide ayuda a tu equipo de IT |
| **MCP Playwright (Browser)** configurado | El agente puede abrir navegador | Pide ayuda a tu equipo de IT |
| **MCP Zoho Projects** configurado | Solo si registras horas en Zoho | Pide ayuda a tu equipo de IT |

### Para Claude Code (CLI)

| Requisito | Cómo verificarlo | Dónde instalarlo si falta |
|-----------|-----------------|--------------------------|
| **Node.js 18+** | Terminal → `node -v` | [nodejs.org](https://nodejs.org) |
| **Claude Code CLI** | Terminal → `claude --version` | `npm install -g @anthropic-ai/claude-code` |
| **MCP Azure DevOps** configurado | `~/.claude/settings.json` o `.claude/settings.json` | Pide ayuda a tu equipo de IT |
| **MCP Zoho Projects** configurado | Solo si registras horas en Zoho | Pide ayuda a tu equipo de IT |

> **¿Qué es un MCP?** Es una conexión que permite al agente comunicarse con sistemas externos
> (Azure DevOps, Zoho, el navegador). Tu equipo de IT o el administrador puede configurarlos.

---

## 🚀 Instalación en 2 minutos

### Paso 1 — Crea una carpeta para tu proyecto de QA

```
Windows:   C:\QA\mi-proyecto\
Mac/Linux: ~/QA/mi-proyecto/
```

### Paso 2 — Abre esa carpeta en la terminal y ejecuta

```bash
npx github:jmartinez-autoreg/QA-TOOLS-TEMPLATE
```

Esto instala automáticamente:
- Los archivos de configuración del agente en tu carpeta del proyecto (incluyendo `CLAUDE.md` para Claude Code y `copilot-instructions.md` para Copilot)
- Los skills en `~/.agents/skills/` — compartidos entre ambos agentes
- El agente QA-PRO en `~/.copilot/agents/` y en `~/.claude/agents/`

### Paso 3a — Usar con GitHub Copilot

```bash
code .
```

- Presiona `Ctrl+Shift+I` (Windows/Linux) o `Cmd+Shift+I` (Mac)
- Asegúrate de que aparezca **"Agent"** en el panel de chat

### Paso 3b — Usar con Claude Code

```bash
claude
```

`CLAUDE.md` se carga automáticamente — no necesitas hacer nada más. El agente QA-PRO está activo desde el primer mensaje.

### Paso 4 — ¡Listo! Escríbele al agente

```
Analiza la US 9884 y prepara el test plan
```

```
Ejecuta el Test Plan 10716, Suite 10717
URL: https://mi-aplicacion.com
```

```
Registra 2 horas para la US 9884, actividad: Preparar TP, fecha: hoy
```

---

## ⚙️ Configuración inicial (una sola vez por equipo)

### Si usas Zoho Projects para registrar horas

Abre el archivo: `~/.agents/skills/zoho_timelog/SKILL.md`

Busca la sección **"Contexto del Proyecto"** y reemplaza los valores entre `{{}}` con los de tu empresa:

```
{{ZOHO_PORTAL_ID}}   → Tu ID numérico de portal en Zoho
{{ZOHO_PROJECT_ID}}  → ID del proyecto en Zoho
{{NOMBRE_PROYECTO}}  → Nombre de tu proyecto
{{ZOHO_OWNER_ID}}    → Tu ID de usuario en Zoho
```

### Actualizar el mapeo de User Stories cada sprint

Al inicio de cada sprint, actualiza la tabla de mapeo en `zoho_timelog/SKILL.md`.
Esta tabla relaciona el número de US de ADO con el ID de tarea en Zoho
(son sistemas distintos — el número de ADO **no** sirve directamente en Zoho).

---

## 🗣️ Cómo hablarle al agente — ejemplos reales

### Para crear y preparar Test Cases

```
Analiza la US 9884 y dime cuántos TCs necesita
```

```
Prepara el test plan completo para la US 9884
```

```
Crea los TCs de la US 9884 en ADO con el Test Plan 10716
```

### Para ejecutar Tests (genera evidencia en ADO)

```
Ejecuta el Test Plan 10716, Suite 10717
URL: https://mi-app.com
```

```
Ejecuta los TCs 10712 y 10713
URL: https://mi-app.com
Usuario: admin / Contraseña: [la que uses]
```

### Para automatizar (genera código Playwright reutilizable)

```
Automatiza el TC 10712 del Plan 10716
URL: https://mi-app.com
```

### Para registrar horas en Zoho

```
Registra mis horas de hoy:
- US 9884: 1.5h Preparar TP, 1h Ejecutar TP
- US 9805: 0.5h QA Demo
Fecha: 2026-05-19
```

### Para el standup daily

```
Prepara el reporte del daily de hoy
US cerradas: 9884, 9805
US en progreso: 9876
Total horas: 4h
```

---

## ❓ Primera pregunta del agente (solo para ejecutar/automatizar TCs)

Cuando pides ejecutar o automatizar TCs, el agente pregunta:

```
¿Qué escenario necesitas?

  A — Proyecto Playwright completo
      Genera archivos .spec.ts reutilizables en TPlans/
      Los tests quedan como código para repetirlos después (regresión)

  B — Ejecución directa, sin archivos
      Navega la app, ejecuta los pasos y sube screenshots a ADO
      No genera código. Solo evidencia. Listo en minutos.
```

**¿Cuál elegir?**
- Elige **A** si quieres que los tests queden como código para repetirlos en cada release
- Elige **B** si solo necesitas la evidencia para hoy (la opción más usada día a día)

---

## 🤖 Copilot vs Claude Code — Diferencias

| Aspecto | GitHub Copilot | Claude Code |
|---------|---------------|-------------|
| Configuración principal | `copilot-instructions.md` | `CLAUDE.md` (se lee automáticamente) |
| Archivo de agente | `~/.copilot/agents/QA-PRO.agent.md` | `~/.claude/agents/QA-PRO-claude.md` |
| Skills compartidos | `~/.agents/skills/` | `~/.agents/skills/` (mismo directorio) |
| Activación | `Ctrl+Shift+I` en VS Code | `claude` en terminal |
| MCP ADO | Nombres internos de Copilot | `mcp__azure-devops-Autoreg__*` |
| MCP Zoho | Nombres internos de Copilot | `mcp__claude_ai_Zhoho__ZohoProjects_*` |
| Auto-aprendizaje | Actualiza archivos de skill | Notifica y actualiza **ambas versiones** en sincronía |

> Los SKILL.md son **idénticos** para ambos agentes — actualizar uno actualiza los dos.

---

## 🧠 Auto-aprendizaje

Cuando algo no funciona como esperas o corriges al agente, el agente **debe notificarlo automáticamente**:

```
⚠️ AUTO-APRENDIZAJE DETECTADO
 Problema   : [qué salió mal]
 Causa raíz : [por qué ocurrió]
 Fix         : [qué cambiaría en las instrucciones]
```

Luego propone actualizar los archivos afectados (SKILL.md y/o CLAUDE.md + copilot-instructions.md) y pide tu confirmación antes de escribir cualquier cambio. Esto garantiza que el mismo error **no ocurra en el futuro** en ninguna de las dos versiones del agente.

---

## 📂 Archivos que se crean en tu carpeta

```
mi-proyecto/
├── CLAUDE.md                      ← Instrucciones del agente para Claude Code (automático)
├── copilot-instructions.md        ← Instrucciones del agente para Copilot
├── .agent-state/                  ← Estado interno del agente — no editar
├── TPlans/                        ← Tests generados (Escenario A)
├── 00_AGENT_RULES.md              ← Reglas globales (compartidas Copilot + Claude)
├── playwright.config.ts           ← Config de Playwright
├── playwright-guide.md            ← Referencia técnica
├── execution-rules.md             ← Reglas para escribir tests
├── selector-strategy.md           ← Estrategia de selectores
└── agent-architecture.md          ← Arquitectura del pipeline
```

---

## 🔠 Datos que necesitas tener a mano

```
Para TCs / Test Plans (Azure DevOps):
  Test Plan ID  →  Número del plan en ADO       (ej: 10716)  [OBLIGATORIO]
  Suite ID      →  Número de la suite en ADO    (ej: 10717)  [opcional]
  TC IDs        →  Números de TCs específicos   (ej: 10712)  [opcional]

Para la aplicación bajo prueba:
  URL           →  Dirección web de la app      (ej: https://mi-app.com)  [OBLIGATORIO]
  Usuario       →  Si la app tiene login
  Contraseña    →  Si la app tiene login  [nunca guardar esto en archivos del repo]

Para Zoho (registro de horas):
  US IDs        →  Números de US trabajadas     (ej: 9884)
  Horas         →  Horas por actividad          (ej: 1.5h Preparar TP)
  Fecha         →  Fecha del registro           (ej: 2026-05-19)
```

---

## 🧩 Skills disponibles

Los skills son las "capacidades" del agente. Se instalan automáticamente en `~/.agents/skills/`.

| Skill | ¿Para qué sirve? | El agente lo usa cuando dices... |
|-------|-----------------|----------------------------------|
| `qa_tester` | Analizar US, crear TCs, documentar resultados, registrar bugs | "analizar US", "crear TC", "preparar test plan" |
| `zoho_timelog` | Registrar horas en Zoho, generar reporte daily | "registrar horas", "zoho", "daily", "time log" |
| `playwright-e2e` | Automatizar TCs con código Playwright (Escenario A) | "automatizar", "crear tests E2E" |
| `qa-execution-reporter` | Ejecutar TCs y subir evidencia a ADO (Escenario B) | "ejecutar TC", "correr Suite" |
| `tc-reader` | Leer y analizar TCs desde ADO | "leer TCs", "mostrar pasos del TC" |
| `debugger` | Diagnosticar y corregir tests fallidos | "el test falla", "debug este test" |
| `create-test-cases` | Crear TCs básicos en ADO | "crear test case rápido en ADO" |
| `find-skills` | Descubrir capacidades disponibles | "¿qué puedes hacer?", "¿tienes skill para X?" |

---

## 🔄 Actualizar el template y skills

Si hay una nueva versión disponible:

```bash
npx github:jmartinez-autoreg/QA-TOOLS-TEMPLATE --force
```

Esto actualiza tanto los archivos del workspace como los skills instalados en `~/.agents/skills/`.

---

## 🆘 Problemas comunes y soluciones

| Problema | Solución |
|----------|----------|
| El agente no encuentra los TCs | Verifica que tengas el Test Plan ID y Suite ID correctos en ADO |
| "MCP ADO no responde" (Copilot) | Verifica el MCP de Azure DevOps en VS Code |
| "MCP ADO no responde" (Claude) | Verifica `~/.claude/settings.json` → clave `azure-devops-Autoreg` |
| "El browser no abre" | Verifica que el MCP de Playwright (Browser) esté activo |
| "Node.js no encontrado" | Instala Node.js 18+ desde [nodejs.org](https://nodejs.org) |
| `claude` no se reconoce como comando | Instala Claude Code: `npm install -g @anthropic-ai/claude-code` |
| `CLAUDE.md` no se carga en Claude Code | Ejecuta `claude` desde la carpeta raíz del proyecto (donde está el CLAUDE.md) |
| Los skills no funcionan | Vuelve a ejecutar `npx github:jmartinez-autoreg/QA-TOOLS-TEMPLATE` |
| Error en PowerShell (Windows) | Ejecuta los comandos así: `cmd /c "npx ..."` en la terminal |
| El agente no registra en Zoho | Verifica que Portal ID y Project ID estén configurados en `zoho_timelog/SKILL.md` |
| "Límite de 15 horas en Zoho" | Es un límite de la API de Zoho. Distribuye el exceso al día siguiente |
| El agente no habla español | Escríbele en español — responde en el idioma que uses |
| El agente repite un error ya corregido | El Auto-aprendizaje no se activó — pide al agente que lo haga: "actualiza las instrucciones" |

---

*Generado por [QA-TOOLS-TEMPLATE](https://github.com/jmartinez-autoreg/QA-TOOLS-TEMPLATE)*

