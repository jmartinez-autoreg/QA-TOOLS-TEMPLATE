# REGLAS OBLIGATORIAS PARA AGENTES DE IA

> ⚠️ **¡ALTO! LEE ESTO ANTES DE EJECUTAR CUALQUIER ACCIÓN O GENERAR CÓDIGO/TEST CASES.**

Como agente de IA, estás obligado a seguir estrictamente las siguientes directrices antes de interactuar con Azure DevOps, Zoho Projects, diseñar casos de prueba o modificar scripts en este entorno.

---

## 1. LECTURA OBLIGATORIA DE SKILLS

Antes de iniciar cualquier tarea, **DEBES** leer y asimilar por completo el archivo `SKILL.md` del directorio correspondiente. **No asumas que conoces las reglas; léelas.**

| Tarea | Skill a leer |
|-------|-------------|
| QA Testing / Test Cases / ADO | `qa_tester/SKILL.md` |
| Registrar horas en Zoho / Time Logs | `zoho_timelog/SKILL.md` |
| Automatizar TCs con Playwright (código) | `playwright-e2e/SKILL.md` |
| Ejecutar TCs y subir evidencia a ADO | `qa-execution-reporter/SKILL.md` |
| Crear Test Cases en ADO | `create-test-cases/SKILL.md` |
| Leer Test Cases de ADO sin ejecutar | `tc-reader/SKILL.md` |

---

## 1.1 PERFIL DE PROYECTO OBLIGATORIO (ANTI-DERIVA DE CONTEXTO)

Antes de crear o actualizar Test Cases, el agente DEBE construir un perfil corto del proyecto activo usando lo que ya entregó el usuario (US, criterios, pantallas, comentarios, evidencias):

- Portal origen y portal destino (ej: Autoreg -> Motorambar)
- Módulo y pantalla exacta bajo prueba
- Flujo funcional objetivo (1-2 líneas)
- Roles/permisos que habilitan o bloquean el flujo
- Términos literales de UI que NO deben ser reemplazados

Reglas:
- Si el perfil no está completo, el agente NO debe redactar TCs finales.
- El perfil debe mantenerse estable durante toda la sesión; no re-interpretar nombres ya confirmados.
- Si hay conflicto entre memoria larga y artefactos actuales (US/TC/pantallas), siempre gana el artefacto actual.

---

## 1.2 ANTI-SUPOSICIÓN DE UI (CONSULTAR `context/UI-UX.md` ANTES DE REDACTAR STEPS)

Antes de redactar los steps de un Test Case para una pantalla, el agente **DEBE** consultar `context/UI-UX.md`:

- **Si la pantalla SÍ está documentada** → usar los labels, botones, campos y estados **literales** ahí registrados. No parafrasear ni inventar textos de UI.
- **Si la pantalla NO está documentada** → el agente **NO debe suponer** el diseño, los labels ni el flujo. Debe elegir una de estas dos vías antes de redactar el TC:
  1. **Pedir un screenshot al usuario** de la pantalla, y procesarlo con el skill `project-onboarding` para alimentar `context/UI-UX.md`.
  2. **Inspeccionar la app real vía MCP Browser** (navegar a la pantalla, leer los elementos reales) antes de escribir los steps.

> ⛔ Redactar steps con labels/flujos inventados para una pantalla no documentada = fallo crítico. Es mejor pedir evidencia que adivinar.

- `context/CONTEXT.md` y `context/UI-UX.md` son la **fuente de verdad** del dominio y las pantallas. Si siguen con placeholders del template, ofrecer ejecutar `project-onboarding` antes de continuar con tareas que dependan de ese contexto.

---

## 2. VALIDACIÓN CONTRA ANTI-PATRONES

Bajo ninguna circunstancia ejecutarás una acción que viole los Anti-Patrones definidos en la Skill correspondiente.

### Reglas de Oro — QA Testing

- **UNA PRECOND POR ROW/STEP.** Jamás fusiones múltiples PRECONDs en una sola fila.
- Los resultados esperados deben describir lo que es **visualmente verificable**, no comportamiento de backend.
- El login **nunca** lleva contraseña en las precondiciones.
- No crear TCs sin revisar la sección **Discussion** de la US — puede contener escenarios excluidos.

### Reglas de Oro — Zoho Time Logs

- **SIEMPRE registrar horas como tipo `"task"`**, nunca como `"general"`. Incluir siempre el Zoho Task ID de la US.
- **Notas con formato `• Actividad<br>• Actividad`** — usar `<br>` HTML, NUNCA `\n`.
- No superar **15 horas por día** (límite hard de la API de Zoho).
- Confirmar siempre la fecha — no asumir "hoy".

### Reglas de Oro — Playwright / Automatización

- No ejecutar código sin haber leído el skill completo primero.
- No subir evidencia sin screenshots — el skill define el formato exacto.
- No saltarse fases del pipeline — el orden existe por una razón.

---

## 3. VERIFICACIÓN DE SCRIPTS EXISTENTES

Si el usuario te proporciona un script existente, tu primer paso **NO ES EJECUTARLO**.  
Tu primer paso es **ANALIZARLO** contra las reglas del `SKILL.md` correspondiente.  
Si viola alguna regla → advertir al usuario y corregir antes de cualquier ejecución.

---

## 4. USO DE HERRAMIENTAS ADO (MCP)

Al actualizar pasos de Test Cases en Azure DevOps:
- Usar XML controlado a través de la REST API según lo define el skill.
- Ten cuidado con la fragmentación por saltos de línea `\n` en tools ADO.
- Confirmar cada llamada MCP — no dar ninguna por hecha sin ejecutarla.

---

## 5. USO DE HERRAMIENTAS ZOHO (MCP)

Al crear o actualizar time logs en Zoho Projects:
- No se puede cambiar `general` → `task` via API (eliminar + recrear).
- No se puede mover un log entre tareas via API (eliminar + recrear).
- Límite de 15 horas por día: verificar siempre antes de crear logs en fechas pasadas.
- No existe endpoint de eliminación en el MCP: el usuario debe eliminar manualmente desde la UI.

---

## 6. COMUNICACIÓN CON EL USUARIO

- Si falta información → **PREGUNTAR**, nunca asumir ni inventar datos.
- Responder siempre en el idioma que el usuario esté usando.
- Al completar una fase de trabajo → generar siempre el **resumen de lo que se hizo** con los IDs creados/modificados.

---

## 7. WORKSPACE SCRATCH — ARCHIVOS TEMPORALES VAN A `.workspace/`

Todo output exploratorio o temporal **DEBE** escribirse dentro de `.workspace/` (carpeta gitignored), **nunca** como archivos sueltos en la raíz del repo:

- CSVs / JSONs de análisis ad-hoc
- Scripts `.ps1` / `.js` de un solo uso (parches, migraciones puntuales, pruebas rápidas)
- Reportes `.md` exploratorios, borradores, notas de sesión
- Dumps de datos, capturas intermedias, resultados de WIQL crudos

Reglas:
- `.workspace/` ya está en `.gitignore` — su contenido no se versiona ni se sube al remoto.
- Los artefactos "oficiales" del proyecto (TCs, `context/`, skills, agentes) **no** van a `.workspace/` — van a su ruta versionada correspondiente.
- Antes de crear un archivo nuevo en la raíz, preguntarse: *"¿esto es un artefacto permanente del proyecto o es scratch?"* — si es scratch, va a `.workspace/`.

> ⛔ Dejar archivos de análisis/temporales sueltos en la raíz contamina el repo y arriesga commits accidentales de contenido que no pertenece al template. Es un anti-patrón.

---

> **Cualquier desviación de estas reglas es considerada un fallo crítico en la ejecución del agente.**
