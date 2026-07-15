---
name: qa-environment-certification
description: Proceso de certificación de ambientes (RELEASE, PRE-PROD, PROD) previo a publicaciones. Genera templates de certificación de sprints y certificación de ambientes con pruebas de regresión e integrales. Gestiona desviaciones encontradas durante certificación. Usar cuando se necesite certificar un release antes de publicar a producción, documentar pruebas de regresión, o gestionar el proceso de validación en ambientes superiores.
argument-hint: 'ambiente a certificar (RELEASE/PRE-PROD/PROD), sprints incluidos, fecha de publicación'
---

# Certificación de Ambientes — Proceso Oficial

Skill para certificar funcionalidades antes de publicarlas en ambientes RELEASE, PRE-PROD y PROD, siguiendo el proceso oficial de calidad empresarial.

> **Fuente:** PROC-QA-Certificación de ambientes v1.00

---

## 1. Objetivo y Beneficios

**Objetivo:**  
Establecer las actividades y documentación en la certificación de las funcionalidades a ser publicadas en los distintos ambientes.

**Beneficios:**
- Manejar efectivamente los resultados de certificación en ambientes
- Reducir el tiempo de implementación en documentación
- Aumentar la excelencia en calidad del producto y entregables
- Mantener trazabilidad de pruebas de regresión pre-producción

**Actividades precursoras:**
- Review [QA] completado
- 1 o más sprints completados con historias aprobadas por cliente

---

## 2. Ambientes y Responsabilidades

| Ambiente | Responsable Ejecución | Responsable Documentación | Tipo de Pruebas |
|----------|----------------------|---------------------------|-----------------|
| **SPRINT TEST** | QAA | QAA | Manuales o exploratorias según test plan |
| **RELEASE** | QAA | QAA | Regresión (reutilizar TCs de sprints) |
| **PRE-PROD** | PO | PO | Regresión + integrales |
| **PROD** | PO | PO | Exploratorias |

---

## 3. Artefactos Generados

### 3.1 Certificación de Sprints

**Archivo:** `QA-CERT-Certificación Sprints {YYYYMMDD}.xlsx` (o CSV versionable en repo)

**Cuándo crear:**  
Al seleccionar historias de 1+ sprints completados para publicar en RELEASE o PRE-PROD.

**Estructura:**

| Columna | Descripción | Ejemplo |
|---------|-------------|---------|
| Num. | Número secuencial | 1, 2, 3... |
| Módulo / Pantalla | Módulo y pantalla afectados | `Mod 1 / Pant 1` |
| Historia | ID: Título de la historia | `12345: Crear pedido de vehículo` |
| ¿Exitoso? | SI / NO | `SI` |
| Fecha | Fecha de ejecución (YYYY-MM-DD) | `2026-07-15` |
| Rol | Responsable (QAA/PO) | `QAA` |
| Iniciales | Iniciales del ejecutor | `FCR` |
| Comentario | Enlace a bug/tarea si NO exitoso | `12345: Título de bug o tarea` |

**Cálculo automático en encabezado:**
- Total exitoso / Total no exitoso
- % exitoso = Exitoso / (Exitoso + No exitoso)

**Hojas por ambiente:**
- `Cert Sprint RELEASE`
- `Cert Sprint PRE-PROD`

---

### 3.2 Certificación de Ambientes

**Archivo:** `QA-CERT-Certificación Ambientes {YYYYMMDD}.xlsx` (o CSV versionable)

**Cuándo crear:**  
Después de certificar sprints, para documentar pruebas integrales y de regresión por Portal/Módulo/Pantalla.

**2 hojas por ambiente:**

#### Hoja 1: **Cert Resultado {AMBIENTE}**

Agrupa pruebas por jerarquía Portal > Módulo > Pantalla (filas combinadas), lista títulos de pruebas bajo cada pantalla.

| Columna | Descripción | Ejemplo |
|---------|-------------|---------|
| ¿Exitoso? | SI / NO | `NO` |
| Portal | Portal de la aplicación | `Finanzas` |
| Módulo | Módulo dentro del portal | `Módulo 2` |
| Pantalla | Pantalla específica | `Pantalla 3` |
| Título | Título de la prueba de regresión | `Título prueba regresión 3` |
| Criterios de Aceptación | Texto de criterios (multi-línea) | `Criterio 1`<br/>`Criterio 2`<br/>`Criterio 10` |
| Responsable | Quién ejecuta (AUTO/QAA/PO) | `QAA` |
| Fecha | Fecha de ejecución | `2026-07-15` |
| Iniciales | Iniciales del ejecutor | `FCR` |

**Nota:** Las celdas Portal/Módulo/Pantalla se combinan (merge) cuando hay múltiples pruebas bajo la misma pantalla.

#### Hoja 2: **Cert Datos {AMBIENTE}**

Mismas pruebas que Cert Resultado, pero con datos de escenarios para ejecutar.

| Columna adicional | Descripción | Ejemplo |
|-------------------|-------------|---------|
| Num. | Número secuencial | 1, 2, 3... |
| Rol (Usuario) | Rol y usuario de prueba | `Administrador (admin)` |
| Datos Escenarios | Datos específicos del escenario | `SIE: 35277164, Año: 2026, PEI: 122625` |
| Tarea correctiva | Enlace a bug/tarea si NO exitoso | `12345: Título de mejora o bug` |

**Hojas por ambiente:**
- `Cert Resultado RELEASE` + `Cert Datos RELEASE`
- `Cert Resultado PRE-PROD` + `Cert Datos PRE-PROD`
- `Cert Resultado PROD` + `Cert Datos PROD`

---

## 4. Flujo del Proceso

```
┌─────────────────┐
│  SPRINT TEST    │  QAA ejecuta y documenta resultados en historias (skill qa_tester)
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────────┐
│  RELEASE (ambiente de pruebas de sprint)                            │
│  1. PO selecciona historias aprobadas de 1+ sprints                │
│  2. PO crea "Certificación de Sprints RELEASE"                     │
│  3. QAA evalúa TCs previos (reutilizar)                            │
│  4. QAA ejecuta pruebas de regresión                               │
│  5. QAA documenta en Cert Sprints: SI/NO + Iniciales               │
│     └─ Si NO → crear historia "Pruebas de regresión" + bug/tarea  │
│  6. PO establece pruebas integrales (con apoyo QAA)                │
│  7. PO crea "Certificación de Ambientes RELEASE" (2 hojas)         │
│  8. QAA ejecuta pruebas integrales/regresión                       │
│  9. QAA documenta en Cert Ambientes: SI/NO + Iniciales             │
│     └─ Si NO → bug/tarea + enlace en columna Tarea correctiva     │
└────────┬────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PRE-PROD (pre-producción)                                          │
│  1-2. PO crea "Certificación de Sprints PRE-PROD"                  │
│  3-5. PO ejecuta y documenta pruebas de regresión                  │
│  6-7. PO crea "Certificación de Ambientes PRE-PROD" (2 hojas)      │
│  8-9. PO ejecuta y documenta pruebas integrales/regresión          │
└────────┬────────────────────────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────────────────────────────────┐
│  PROD (producción)                                                  │
│  1. PO crea "Certificación de Ambientes PROD" (2 hojas)            │
│  2. PO ejecuta pruebas exploratorias                               │
│  3. PO documenta resultados: SI/NO + Iniciales                     │
│     └─ Si NO → bug/tarea + priorizar desarrollo                   │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 5. Gestión de Desviaciones

**Al encontrar una desviación (prueba NO exitosa) en CUALQUIER ambiente:**

### Paso 1 — Crear historia de regresión en sprint
1. En Azure DevOps, crear nueva historia con título: **`Pruebas de regresión`**
2. Dentro de esa historia, crear:
   - **Bug** (si es defecto de funcionalidad existente) con descripción completa del problema
   - **Tarea** (si es mejora o ajuste menor)

### Paso 2 — Documentar en certificación
1. Marcar **NO** en columna `¿Exitoso?`
2. En columna `Comentario` (Cert Sprints) o `Tarea correctiva` (Cert Ambientes):
   - Enlace al bug/tarea creado: `12345: Título de bug o tarea`

### Paso 3 — PO evalúa desviaciones
El PO revisa todos los bugs/tareas de regresión y:
- **Remover** las que no proceden → cambiar estatus a `Removed` en ADO
- **Agrupar** similares en nuevas historias
- **Asociar** bugs a historias existentes del backlog
- **Priorizar** desarrollo (añadir al siguiente sprint o release)

---

## 6. Comportamiento del Agente

Al recibir solicitud de certificación de ambiente:

### 6.1 PHASE 0 — Validar precondiciones

```
1. Verificar que existan sprints completados con historias en estado Closed
2. Confirmar que las historias han sido aprobadas por cliente (campo ApprovedProductOwner = True en ADO)
3. Si ambiente ≥ PRE-PROD, verificar que RELEASE ya está certificado
4. Si ambiente = PROD, verificar que PRE-PROD ya está certificado

→ Si alguna precondición falla, STOP y notificar al usuario qué falta
```

### 6.2 PHASE 1 — Recolectar información

Preguntar al usuario (si no se proporcionó):

| Dato | Obligatorio | Ejemplo |
|------|-------------|---------|
| **Ambiente a certificar** | Sí | `RELEASE` / `PRE-PROD` / `PROD` |
| **Sprints incluidos** | Sí | `10, 11, 12` |
| **Fecha de publicación** | Sí | `2026-07-20` |
| **Equipo/Iniciativa** | Sí | `Iniciativas 1` |
| **Nombre del PO** | Sí | `Fernando Calderon` |
| **Historias específicas** | No — extraer de ADO | IDs o query |

### 6.3 PHASE 2 — Generar Certificación de Sprints

```
1. Extraer historias de los sprints indicados:
   mcp_ado_wit_query_by_wiql(
     query: "SELECT [System.Id], [System.Title], [System.State]
             FROM WorkItems
             WHERE [System.WorkItemType] = 'User Story'
             AND [System.IterationPath] IN ('Sprint 10', 'Sprint 11', 'Sprint 12')
             AND [System.State] = 'Closed'
             AND [Custom.ApprovedProductOwner] = True"
   )

2. Para cada historia, extraer:
   - Módulo/Pantalla (del título o tags)
   - ID: Título

3. Generar CSV o Excel con estructura de §3.1:
   - Crear archivo en .workspace/certifications/
   - Nombre: QA-CERT-Certificación-Sprints-{YYYYMMDD}-{AMBIENTE}.csv
   - Inicializar columnas ¿Exitoso?, Fecha, Rol, Iniciales, Comentario vacías

4. Mostrar tabla al usuario con las historias a certificar
5. Preguntar: "¿Procedo a ejecutar/documentar las pruebas o prefieres llenar el archivo manualmente?"
```

### 6.4 PHASE 3 — Generar Certificación de Ambientes

```
1. Preguntar al PO/QAA: "¿Qué pruebas integrales y de regresión deben ejecutarse?"
   - Portal, Módulo, Pantalla afectados
   - Títulos de pruebas por pantalla
   - Criterios de aceptación de cada prueba
   - Rol/Usuario de prueba
   - Datos de escenarios (si aplica)

2. Generar 2 archivos CSV (o 2 hojas Excel):
   - Cert Resultado {AMBIENTE}
   - Cert Datos {AMBIENTE}
   - Nombre: QA-CERT-Certificación-Ambientes-{YYYYMMDD}-{AMBIENTE}.csv

3. Inicializar columnas ¿Exitoso?, Fecha, Iniciales, Tarea correctiva vacías

4. Mostrar al usuario y preguntar: "¿Deseas que registre los resultados conforme ejecutas o prefieres llenar manualmente?"
```

### 6.5 PHASE 4 — Documentar resultados (opcional, interactivo)

Si el usuario elige que el agente documente:

```
Para cada prueba:
1. Preguntar: "Resultado de [Título prueba] en [Pantalla]: ¿Exitosa? (SI/NO)"
2. Si NO:
   a. Preguntar: "¿Es bug o tarea de mejora?"
   b. Preguntar: "Describe el problema"
   c. Crear historia "Pruebas de regresión" en ADO (si no existe)
   d. Crear bug/tarea vinculado con descripción
   e. Registrar ID en columna Comentario/Tarea correctiva
3. Registrar fecha actual, rol (QAA o PO según ambiente), solicitar iniciales
4. Actualizar archivo CSV/Excel

Al finalizar todas las pruebas:
- Calcular % exitoso
- Mostrar resumen con bugs/tareas creados
- Confirmar: "✅ Certificación de {AMBIENTE} completada. Archivo guardado en .workspace/certifications/"
```

---

## 7. Integración con qa_tester

En `qa_tester/SKILL.md`, agregar nueva fase post-Review:

**PHASE 5 — Certificar ambiente (opcional, al cerrar sprint)**

```
Después de Post-Review, si el sprint será publicado a RELEASE:
1. Preguntar: "¿Deseas iniciar certificación de ambiente RELEASE para este sprint?"
2. Si SÍ → invocar skill qa-environment-certification con:
   - ambiente: RELEASE
   - sprints: [sprint actual]
   - fecha: próxima fecha de publicación (preguntar)
```

---

## 8. Formato de Archivos

### Opción A — CSV versionable (recomendado para repos)

```csv
Num.,Módulo / Pantalla,Historia,¿Exitoso?,Fecha,Rol,Iniciales,Comentario
1,Mod 1 / Pant 1,12345: Título de Historia en el Sprint,SI,2026-07-15,QAA,FCR,
2,Mod 1 / Pant 2,12346: Otra Historia,NO,2026-07-15,QAA,FCR,12450: Bug en validación de campo
```

### Opción B — Excel (si el equipo lo prefiere)

Usar biblioteca Python (openpyxl) para generar archivos .xlsx con:
- Formato condicional (SI = verde, NO = rojo)
- Celdas combinadas en Cert Resultado
- Fórmulas automáticas para cálculo de %

---

## 9. Reglas Globales

1. **Nunca certificar sin historias aprobadas** — campo `ApprovedProductOwner` debe ser `True`
2. **Respetar secuencia de ambientes** — RELEASE → PRE-PROD → PROD (no saltar)
3. **Crear historia "Pruebas de regresión" por sprint** — no mezclar bugs de diferentes sprints en la misma historia
4. **Enlazar siempre bugs/tareas** — columna Comentario/Tarea correctiva nunca debe decir solo "NO" sin ID
5. **Actualizar campo en ADO al certificar** — considerar agregar campo custom `EnvironmentCertified` con valores RELEASE/PRE-PROD/PROD

---

## 10. Ejemplo Completo

**Escenario:** Certificar RELEASE con sprints 10, 11, 12 para publicar el 2026-07-20.

```
Usuario: "Necesito certificar RELEASE con los sprints 10, 11 y 12 para publicar el 20 de julio"

Agente:
[PHASE 0] Verificando precondiciones...
✅ Sprints 10-12 tienen historias Closed
✅ 42 historias con ApprovedProductOwner = True
✅ No hay certificación previa de RELEASE para estos sprints

[PHASE 1] Recolectando información...
- Ambiente: RELEASE
- Sprints: 10, 11, 12
- Publicación: 2026-07-20
- Equipo: [preguntar]
Usuario: "Iniciativas 1"

- PO: [preguntar]
Usuario: "Fernando Calderon"

[PHASE 2] Generando Certificación de Sprints...
Consulta WIQL ejecutada: 42 historias encontradas

Historias a certificar:
| Num. | Módulo / Pantalla | Historia |
|------|-------------------|----------|
| 1    | Mod 1 / Pant 1    | 12345: Crear pedido de vehículo |
| 2    | Mod 1 / Pant 1    | 12346: Validar stock disponible |
| ...  | ...               | ... (40 más) |

Archivo creado: .workspace/certifications/QA-CERT-Certificación-Sprints-20260715-RELEASE.csv

¿Procedo a registrar resultados conforme ejecutas? (S/N)
Usuario: "S"

[PHASE 4] Documentando resultados...
Prueba 1 — 12345: Crear pedido de vehículo → ¿Exitosa? (SI/NO)
Usuario: "SI"
✅ Registrado: SI, 2026-07-15, QAA, [tus iniciales]
Usuario: "JMR"

Prueba 2 — 12346: Validar stock disponible → ¿Exitosa? (SI/NO)
Usuario: "NO"
⚠️ ¿Es bug o tarea de mejora? (bug/tarea)
Usuario: "bug"
Describe el problema:
Usuario: "No valida correctamente cuando hay 0 unidades disponibles"

Creando historia "Pruebas de regresión" en sprint 10...
[ADO] Historia creada: 12450
[ADO] Bug creado en historia 12450: "Validación incorrecta de stock en 0"
✅ Registrado: NO, 2026-07-15, QAA, JMR, Comentario: "12451: Validación incorrecta de stock en 0"

[... continúa con las 40 pruebas restantes ...]

[RESUMEN]
✅ Certificación de Sprints RELEASE completada
- Exitosas: 39 (92.86%)
- No exitosas: 3 (7.14%)
- Bugs creados: 2 (IDs: 12451, 12455)
- Tareas creadas: 1 (ID: 12458)
- Archivo: .workspace/certifications/QA-CERT-Certificación-Sprints-20260715-RELEASE.csv

¿Deseas continuar con Certificación de Ambientes RELEASE? (S/N)
```

---

## Referencias

- **PROC-QA-Certificación de ambientes v1.00** — Proceso oficial completo
- **QA-CERT-Certificación Ambientes YYYYMMDD.xlsx** — Template oficial Excel
- **QA-CERT-Certificación Sprints YYYYMMDD.xlsx** — Template oficial Excel
- **PROC-QA-Generales de calidad v1.07 §20-21** — Checkpoint/Review y Post-Review
