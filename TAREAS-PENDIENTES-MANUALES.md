# TAREAS PENDIENTES MANUALES — Backlog S2 Entregable 3

**Fecha:** 2026-06-02  
**Total de correcciones automáticas aplicadas:** ~80 cambios  
**Total de tareas pendientes:** 3 categorías principales  

---

## 📋 1. NOMENCLATURA DE TEST CASES (Agregar US_ID)

### **Objetivo:**
Agregar el ID de la User Story al inicio del título de cada Test Case para facilitar el filtrado.

### **Formato estándar:**
```
[US_ID] | Portal-Módulo-Pantalla-Funcionalidad [Escenario]
```

### **Valores fijos:**
- **Portal:** VehicleDocs
- **Módulo:** Vehículos Importados
- **Pantallas conocidas:** Ver todo, Editar Vehículo, Detalle VIN expandido, Grid de vehículos

### **Ejemplos de corrección:**

| Título Actual | Título Corregido |
|---------------|------------------|
| `Validación de modo Read Only en campos...` | `9947 \| VehicleDocs-Vehículos Importados-Editar Vehículo-Validación modo Read Only [Happy Path]` |
| `[Asignación Automática] - Asignación a Dealer (Sin Banco)` | `9873 \| VehicleDocs-Vehículos Importados-Grid-Asignación Automática [Dealer Sin Banco]` |

### **TCs afectados:**
- Total: ~118 Test Cases de las 44 USs del backlog
- **Prioridad alta:** TCs de USs cerradas (para mantener consistencia histórica)

### **⚠️ Criterio:**
Si no tienes suficiente información para determinar la pantalla/funcionalidad correcta → **dejar como está**.

---

## 🔧 2. USs DE INFRAESTRUCTURA — Limpieza de Test Cases

### **Objetivo:**
Las USs de Infraestructura/Backend **NO deben tener Test Plan formal** porque no hay UI que probar.

### **USs afectadas:**

| US ID | Título | TCs vinculados | Acción requerida |
|-------|--------|----------------|------------------|
| **9547** | Infraestructura Azure: | 0 TCs | ✅ OK — No requiere acción |
| **9851** | Infraestructura Azure: Crear Sistema de encolado | 1 TC (ID 10176) | ❌ **DESVINCULAR TC** |
| **9852** | Infraestructura Azure: Sistema extracción data con IA | 1 TC (ID 10193) | ❌ **DESVINCULAR TC** |
| **10799** | INFRA: Integración SDK Azure KeyVault | ¿TCs? | ⚠️ **VERIFICAR** si tiene TCs vinculados |

### **Pasos por cada US de Infraestructura:**

#### **Paso 1: Desvincular Test Cases**
1. Abrir la US en Azure DevOps
2. Ir a la pestaña "Links" o "Related Work"
3. Eliminar el vínculo "Tested By" con cada TC
4. **NO eliminar el TC** — solo desvincular (puede ser reutilizado en otra US)

#### **Paso 2: Verificar tareas QA existentes**
Cada US de Infraestructura debe tener **SOLO estas 2 tareas:**

| Tarea | Horas |
|-------|-------|
| **QA - Ejecutar Pruebas** | 0.25h |
| **QA - Demo** | 0.25h |

**NO debe tener:**
- ❌ "QA - Preparar Test Plan" (no hay Test Plan)
- ❌ "QA - Ejecutar Test Plan" (no hay Test Plan)

#### **Paso 3: Crear tareas faltantes (si no existen)**
Si la US no tiene las tareas "QA - Ejecutar Pruebas" y "QA - Demo":

1. Crear tarea: **"QA - Ejecutar Pruebas"**
   - Type: Task
   - Parent: La US correspondiente
   - Assigned To: [tu usuario QA]
   - Activity: Testing
   - Original Estimate: 0.25
   - Remaining Work: 0.25 (si no está cerrada)
   - Completed Work: 0.25 (si está cerrada)

2. Crear tarea: **"QA - Demo"**
   - Type: Task
   - Parent: La US correspondiente
   - Assigned To: [tu usuario QA]
   - Activity: Testing
   - Original Estimate: 0.25
   - Remaining Work: 0.25 (si no está cerrada)
   - Completed Work: 0.25 (si está cerrada)

---

## 📝 3. USs SIN DOCUMENTACIÓN QA (Requieren refinación)

### **Problema detectado:**
Estas USs están `Closed` pero **NO tienen comentario QA PASSED/NOT PASSED** ni screenshots.

Además, tienen **múltiples Test Cases** que probablemente no se ejecutaron formalmente en ADO.

### **USs afectadas:**

| US ID | Test Cases | Estado | Problema |
|-------|-----------|--------|----------|
| **9502** | 11 TCs | Closed | Sin documentación QA, múltiples TCs sin ejecutar |
| **9803** | 1 TC | Closed | Sin documentación QA, NO se corrió el Test Plan |
| **9817** | 6 TCs | Closed | Sin documentación QA, múltiples TCs en Design |
| **9856** | 10 TCs | Closed | Sin documentación QA, múltiples TCs sin ejecutar |
| **9873** | 8 TCs | Closed | Sin documentación QA, múltiples TCs sin ejecutar |
| **9892** | 7 TCs | Closed | Sin documentación QA, múltiples TCs en Design |
| **9940** | 3 TCs | Closed | Sin documentación QA, múltiples TCs en Design |
| **9947** | 10 TCs | Closed | Sin documentación QA, múltiples TCs sin ejecutar |
| **10305** | 2 TCs | Closed | Sin documentación QA |
| **10447** | 0 TCs | Closed | Sin documentación QA, sin Test Cases |
| **10451** | 0 TCs | Closed | Sin documentación QA, sin Test Cases |

### **Estrategia de corrección:**

#### **OPCIÓN A — Refinación + Ejecución (Recomendado para USs con múltiples TCs)**

**Para:** 9502, 9817, 9856, 9873, 9892, 9940, 9947

**Pasos:**
1. **Revisar los múltiples TCs** de la US
2. **Consolidar** — Si varios TCs cubren la misma pantalla/flujo → combinarlos en 1 TC único
3. **Eliminar TCs redundantes** (desvincular + archivar)
4. **Ejecutar el TC consolidado** (Escenario B — ejecución directa con screenshots)
5. **Documentar** con comentario:
   ```
   QA PASSED / Sprint Test
   
   [Link del Test Run — si existe]
   
   [Screenshot 1 por cada criterio de aceptación]
   ```

#### **OPCIÓN B — Documentación retroactiva (Si ya se verificó manualmente)**

**Para:** 9803, 10305, 10447, 10451

**Pasos:**
1. **Verificar manualmente** la funcionalidad en el ambiente de producción/QA
2. **Capturar screenshots** de los criterios de aceptación
3. **Publicar comentario** en la US con evidencia:
   ```
   QA PASSED / Sprint Test
   
   Verificado manualmente en [fecha]
   
   [Screenshots de criterios de aceptación]
   ```

---

## 📊 4. RESUMEN DE PRIORIDADES

| Prioridad | Tarea | Esfuerzo estimado |
|-----------|-------|-------------------|
| 🔴 **ALTA** | Desvincular TCs de USs de Infraestructura (9851, 9852) | 10 min |
| 🔴 **ALTA** | Crear tareas QA faltantes en USs de Infraestructura | 15 min |
| 🟡 **MEDIA** | Documentar USs sin evidencia QA (Opción B) | 1-2h |
| 🟢 **BAJA** | Refinar Test Plans de USs con múltiples TCs (Opción A) | 4-6h |
| 🟢 **BAJA** | Renombrar TCs con formato US_ID \| Nomenclatura | 2-3h |

---

## ✅ VALIDACIÓN FINAL

Una vez completadas estas tareas, el backlog debe cumplir:

- ✅ Todas las USs `Closed` tienen comentario QA PASSED con screenshots
- ✅ USs de Infraestructura NO tienen Test Cases vinculados
- ✅ USs de Infraestructura tienen solo 2 tareas: "Ejecutar Pruebas" y "Demo"
- ✅ Todos los TCs están en estado "Ready"
- ✅ Nomenclatura de TCs incluye US_ID para filtrado
- ✅ TestPlanCompleted = True solo para USs con UI
- ✅ Tareas QA cerradas si la US está cerrada

---

**🤖 Generado por:** GitHub Copilot Agent QA-PRO  
**📁 Archivos de referencia:**
- `HALLAZGOS-FINAL-CONSOLIDADO.csv` — Hallazgos completos
- `REPORTE-CORRECCIONES.txt` — Resumen de correcciones automáticas
