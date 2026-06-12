# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## CODEBASE — DEVELOPER REFERENCE

### Install & run the template installer

```powershell
node index.js                   # install/update skills, agents and context/ scaffold in this project
node index.js --force           # also overwrite existing workspace files (never overwrites context/)
```

To publish a new version: `npm publish` (package name: `playwright-agent-template`).  
End users install via: `npx github:jmartinez-autoreg/QA-TOOLS-TEMPLATE`.

### Repository layout

| Path | What it is |
|------|-----------|
| `Template/` | Workspace files copied to the user's project dir on install (skipped if already exist, unless `--force`) |
| `AGENTS.md` | **The single brain** — all global agent rules. `CLAUDE.md` and `copilot-instructions.md` are thin entrypoints that point here. Mirrored to `Template/AGENTS.md`. |
| `Template/context/*.template.md` | Seed files for `<project>/context/CONTEXT.md` and `<project>/context/UI-UX.md` — created once, never overwritten by `--force` |
| `skills/` | SKILL.md files — always overwritten to `<project>/.claude/skills/` on every install/update |
| `agents/` | Sub-agent definitions (`QA-PRO.agent.md`, `PO-PRO.agent.md`) — copied to `<project>/.claude/agents/` (Claude Code) and `<project>/.github/agents/` (Copilot). Single source of each role's rules. |
| `models.config.yml` | Single source of truth for model-per-tier assignments (installer reads and displays this) |
| `.agent-state/*.schema.json` | JSON schemas for pipeline contracts — version these |
| `copilot-instructions.md` | Thin Copilot entrypoint → points to `AGENTS.md` + Copilot MCP tool-name map. Not a rule mirror. |

### Single-brain rule (replaces the old dual-platform sync rule)

Every rule lives in **exactly one file** — there are no copies to keep in sync:

| Rule type | Its only home |
|-----------|---------------|
| Global behaviour, routing, prohibitions | `AGENTS.md` |
| Role rules (QA / PO) | `agents/QA-PRO.agent.md` / `agents/PO-PRO.agent.md` |
| Task mechanics | `skills/<name>/SKILL.md` |
| Platform entry + MCP tool names | `CLAUDE.md` / `copilot-instructions.md` |

The **only** thing still mirrored is each sub-agent across the two platform dirs (`.claude/agents/` ↔ `.github/agents/`, same content) and the `Template/` copies the installer ships. Never put a behaviour rule in `CLAUDE.md`/`copilot-instructions.md` — they hold only the `@AGENTS.md` pointer, platform notes, and the tool-name map.

### Adding a new skill

1. Create `skills/<name>/SKILL.md` (installer always overwrites to `.claude/skills/<name>/SKILL.md` in the user's project)
2. Add a keyword → skill row to the PASO 0 routing table in **`AGENTS.md`** (the only routing table)
3. Add the skill under the appropriate tier in `models.config.yml`

### Changing model assignments

Edit `models.config.yml` — the installer reads it at runtime and prints the tier table. Tier structure:

| Tier | Rol | Default model |
|------|-----|---------------|
| T1 | PO / Backlog Planner | `claude-sonnet-4-6` + extended thinking |
| T2 | QA Planner | `claude-sonnet-4-6` + extended thinking |
| T3 | Code Builder | `claude-haiku-4-5-20251001` |
| T4 | Browser Executor | `claude-haiku-4-5-20251001` |
| TOps | Operations (Zoho/ADO) | `claude-haiku-4-5-20251001` |

---

# Entrada para Claude Code

> ⚠️ **Este archivo se lee automáticamente en cada sesión.**
> Las reglas del agente **no viven aquí** — viven en `AGENTS.md` (el cerebro, fuente única).
> Aquí solo está: el puntero al cerebro, el contexto del proyecto, y el mapeo de tools MCP de Claude Code.

---

## Cerebro y contexto (auto-cargados)

@AGENTS.md
@context/CONTEXT.md
@context/UI-UX.md

Si `context/CONTEXT.md` sigue con placeholders o `context/UI-UX.md` no tiene pantallas documentadas,
ofrecer ejecutar el skill `project-onboarding` (`.claude/skills/project-onboarding/SKILL.md`) antes de
redactar TCs o USs que dependan de esa información.

---

## Específico de Claude Code

- **Subagentes:** se despachan desde `.claude/agents/` — `QA-PRO.agent.md` (QA) y `PO-PRO.agent.md` (PO).
  `QA-PRO.agent.md` es además la capa de autoridad: si un skill contradice una regla de rol, gana el subagente.
- **Skills:** se leen con la herramienta `Read` desde `.claude/skills/<skill>/SKILL.md`.
- **Reglas globales, routing y prohibiciones:** todas en `AGENTS.md`. No repetirlas aquí.

---

## Mapeo de tools MCP (Claude Code)

`AGENTS.md` y los subagentes usan **verbos genéricos**. En Claude Code se traducen así:

### Azure DevOps

| Verbo genérico | Tool MCP (Claude Code) |
|---|---|
| obtener work item | `mcp__azure-devops-Autoreg__wit_get_work_item` |
| actualizar work item | `mcp__azure-devops-Autoreg__wit_update_work_item` |
| crear work item | `mcp__azure-devops-Autoreg__wit_create_work_item` |
| comentar work item | `mcp__azure-devops-Autoreg__wit_add_work_item_comment` |
| consultar WIQL | `mcp__azure-devops-Autoreg__wit_query_by_wiql` |
| batch work items por IDs | `mcp__azure-devops-Autoreg__wit_get_work_items_batch_by_ids` |
| historial de revisiones | `mcp__azure-devops-Autoreg__wit_list_work_item_revisions` |
| adjunto de work item | `mcp__azure-devops-Autoreg__wit_get_work_item_attachment` |
| listar test plans / suites / cases | `mcp__azure-devops-Autoreg__testplan_list_test_plans` / `_test_suites` / `_test_cases` |
| crear test plan / suite / case | `mcp__azure-devops-Autoreg__testplan_create_test_plan` / `_suite` / `_case` |
| actualizar pasos de TC | `mcp__azure-devops-Autoreg__testplan_update_test_case_steps` |
| agregar TCs a suite | `mcp__azure-devops-Autoreg__testplan_add_test_cases_to_suite` |

### Zoho Projects

| Verbo genérico | Tool MCP (Claude Code) |
|---|---|
| registrar time log | `mcp__claude_ai_Zhoho__ZohoProjects_add_time_log` |
| registrar time logs en lote | `mcp__claude_ai_Zhoho__ZohoProjects_add_bulk_time_logs` |
| time logs por proyecto / portal | `mcp__claude_ai_Zhoho__ZohoProjects_get_time_logs_by_project` / `_by_portal` |
| tareas por proyecto | `mcp__claude_ai_Zhoho__ZohoProjects_get_tasks_by_project` |
| actualizar time log | `mcp__claude_ai_Zhoho__ZohoProjects_update_single_time_log` |
| portales / proyectos / usuario | `mcp__claude_ai_Zhoho__ZohoProjects_get_portals` / `_get_projects_list` / `_get_current_user_details` |

### Ejecución no-bloqueante (anti-bloqueo)

| Verbo genérico | Mecanismo (Claude Code) |
|---|---|
| despachar subagente en background | Tool `Agent` con `subagent_type: "QA-PRO"` / `"PO-PRO"` y `run_in_background: true`. Claude Code notifica automáticamente al completarse — mostrar entonces el resumen de resultados (AGENTS.md §8.9). |
| lanzar el mismo subagente varias veces en paralelo | Varias llamadas a `Agent` (una por tarea independiente), cada una con `run_in_background: true`, en el mismo turno |

> Claude Code soporta esto de forma nativa. AGENTS.md §3.1 decide cuándo proponerlo.

> Cambiar de plataforma solo toca esta tabla — ninguna regla de `AGENTS.md` ni de los subagentes.
