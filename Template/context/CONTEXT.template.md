# Contexto del Proyecto

> ⚠️ Este archivo se auto-carga al inicio de cada sesión (vía `@context/CONTEXT.md` en `CLAUDE.md`).
> Completa cada sección con los datos reales del proyecto — el agente lo usa como **fuente de verdad** para TCs, USs y ejecución.
> NUNCA inventar datos de esta sección: si falta información, preguntar al usuario o usar el skill `project-onboarding`.

---

## Configuración del Agente

> Usado por el skill `activity-logger` (fecha/hora local + carpetas de bitácora), por la regla de
> idioma de interacción (AGENTS.md §8.9) y por el comando "actualiza el template" (AGENTS.md §6.1).
> Se completa una vez con `project-onboarding`, o se pregunta cuando se necesita por primera vez.

| Campo | Valor |
|-------|-------|
| Idioma de interacción | `[Ej: Español]` |
| Zona horaria | `[Ej: America/Caracas (UTC-4)]` |
| Sprint actual | `[Ej: Sprint 24]` |
| Ruta local de QA-TOOLS-TEMPLATE | `[Ej: C:\Users\Usuario\Documents\IA\QA-TOOLS-TEMPLATE]` |
| Ruta local de estándares oficiales | `[Ej: C:\Users\Usuario\Documents\IA\QA Informaciones\Estándares y Procesos]` |

> Actualiza "Sprint actual" al iniciar cada sprint nuevo — define el nombre de carpeta de la bitácora.
> "Ruta local de estándares oficiales" apunta a la carpeta con los documentos de la empresa
> (PROC-QA-*, GUÍA-QA-*, ceremoniales) — usada por AGENTS.md §8.13 para verificar convenciones
> antes de asumir que no existen. Si hay subcarpeta `markdown_output/`, preferirla (búsqueda por
> texto); ante extracción incompleta, ir al PDF original.

---

## Portales y URLs

| Portal | URL | Descripción |
|--------|-----|-------------|
| **[Portal 1]** | `https://...` | [Descripción corta] |
| **[Portal 2]** | `https://...` | [Descripción corta] |

---

## Login — Flujos Conocidos

### [Nombre del flujo de login]
- Pantalla: [campos y botones con nombres literales]
- Tras login exitoso: [qué se ve]
- Modales o pasos adicionales: [si aplica]

---

## Roles y Permisos

| Condición | Resultado visible |
|-----------|------------------|
| [Rol con permiso] | [Qué aparece en UI] |
| [Rol sin permiso] | [Qué NO aparece en UI] |

---

## Módulos Principales

- **[Módulo 1]** — [descripción breve]
- **[Módulo 2]** — [descripción breve]

---

## Organización ADO

- **Organización:** `[ORG_ADO]`
- **Proyecto:** `[PROYECTO_ADO]`
- **Usuario QA:** `[email@empresa.com]`

---

## Terminología Literal (NO cambiar nombres)

| Término en sistema | Descripción |
|--------------------|-------------|
| `[Término 1]` | [Qué es] |
| `[Término 2]` | [Qué es] |

---

## Tecnología Frontend

- **[Portal 1]:** [Framework / stack]
- **[Portal 2]:** [Framework / stack]
