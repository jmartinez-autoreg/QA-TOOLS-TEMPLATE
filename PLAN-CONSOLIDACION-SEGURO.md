# PLAN DE CONSOLIDACIÓN DE TEST CASES — ESTRATEGIA SEGURA

**Fecha:** 2026-06-02  
**Estrategia:** Marcar como obsoleto + Crear consolidado + Revisión manual antes de eliminar

---

## 🛡️ ESTRATEGIA CONSERVADORA

Esta estrategia **NO elimina ningún TC** hasta que tú los revises:

1. **FASE 1:** Renombrar TCs Design a `OBSOLETO-{US_ID} - {título}`
2. **FASE 2:** Crear 1 TC consolidado por US en el mismo Test Suite
3. **REVISIÓN MANUAL:** Tú revisas cada TC obsoleto:
   - ¿Tiene info necesaria? → Incorpora al TC consolidado
   - ¿No tiene nada útil? → Elimínalo
4. **EJECUCIÓN:** Ejecutar los TCs consolidados
5. **DOCUMENTACIÓN:** Publicar QA PASSED con evidencia

---

## 📊 RESUMEN POR US

### **US 9817 — Asignación en Lote**

**Estado actual:**
- 6 TCs Design (todos 1 paso)

**FASE 1:** Renombrar a obsoleto
```
10283 → OBSOLETO-9817 - ...muestra resultados con nombre...
10284 → OBSOLETO-9817 - ...confirmar asignación muestra mensaje...
10285 → OBSOLETO-9817 - ...sin seleccionar cliente muestra validación
10286 → OBSOLETO-9817 - ...cancelar cierra el popup
10282 → OBSOLETO-9817 - ...popup muestra cantidad de VIN
10287 → OBSOLETO-9817 - ...flujo es claro y usable
```

**FASE 2:** Crear TC consolidado
```
Título: 9817 | VehicleDocs-Vehículos Importados-Asignación en Lote [Flujo Completo]
Pasos: 7 pasos (combinar todos los escenarios)
```

---

### **US 9856 — Nuevos Filtros Grid**

**Estado actual:**
- 6 TCs Design (obsoletos)
- 4 TCs Closed (con evidencia ✅)

**FASE 1:** Renombrar Design a obsoleto
```
10233 → OBSOLETO-9856 - ...Sección Más Filtros muestra campos
10234 → OBSOLETO-9856 - ...Buscar por Invoice filtra correctamente
10235 → OBSOLETO-9856 - ...Validaciones muestran mensaje de error
10236 → OBSOLETO-9856 - ...Filtro Rango de Fechas usa calendario
10237 → OBSOLETO-9856 - ...Regresar conserva filtros
10238 → OBSOLETO-9856 - ...Filtros visualmente claros
```

**FASE 2:** Crear TC consolidado usando evidencia de los 4 Closed
```
Título: 9856 | VehicleDocs-Vehículos Importados-Grid-Nuevos Filtros [Flujo Completo]
Pasos: 11 pasos (consolidar 10666, 10667, 10668, 10669)
Evidencia: ✅ Screenshots ya existen de los 4 TCs Closed
```

---

### **US 9873 — Asignación LocationId**

**Estado actual:**
- 5 TCs Design (obsoletos)
- 3 TCs Closed (con evidencia ✅)

**FASE 1:** Renombrar Design a obsoleto
```
10625 → OBSOLETO-9873 - [Asignación Automática] - Prioridad Banco...
10626 → OBSOLETO-9873 - [Asignación Automática] - Asignación a Dealer...
10627 → OBSOLETO-9873 - [Asignación Automática] - Solo Banco...
10628 → OBSOLETO-9873 - [Asignación Automática] - Sin Dealer ni Banco...
10629 → OBSOLETO-9873 - [Interfaz] - Visualización de Inputs...
```

**FASE 2:** Los 3 TCs Closed ya están consolidados
```
Acción: Solo renombrar si no tienen formato correcto:
10670 → 9873 | VehicleDocs-Vehículos-Editar-LocationId [Asignación Automática]
10671 → 9873 | VehicleDocs-Vehículos-Editar-LocationId [Gestión Errores]
10672 → 9873 | VehicleDocs-Vehículos-Editar-LocationId [Interfaz]
```

---

### **US 9892 — Catálogos Documentos**

**Estado actual:**
- 7 TCs Design (todos)

**FASE 1:** Renombrar a obsoleto
```
10067 → OBSOLETO-9892 - ...Categoría Factura disponible...
10066 → OBSOLETO-9892 - ...Categorías existentes visibles...
10068 → OBSOLETO-9892 - ...Sin categorías duplicadas...
10069 → OBSOLETO-9892 - ...Categorías inactivas no aparecen...
10070 → OBSOLETO-9892 - ...Listado legible y accesible...
10678 → OBSOLETO-9892 - TC-9892-2: Validación inconsistencias...
10677 → OBSOLETO-9892 - TC-9892-1: Sincronización, Mapeo...
```

**FASE 2:** Crear 1-2 TCs consolidados
```
Revisar: Algunos TCs parecen ser de backend (sincronización)
Puede que sean Cobertura DEV en lugar de Test Cases QA
```

---

### **US 9940 — Roles**

**Estado actual:**
- 3 TCs Design (todos)

**FASE 1:** Renombrar a obsoleto
```
10086 → OBSOLETO-9940 - ...Pantalla de gestión muestra información...
10084 → OBSOLETO-9940 - ...Sección de roles disponible...
10085 → OBSOLETO-9940 - ...Asignar rol Distribuidor y acceso...
```

**FASE 2:** Crear TC consolidado
```
Título: 9940 | VehicleDocs-Admin-Roles-Gestión de Roles [Flujo Completo]
Pasos: 11 pasos (combinar navegación → visualización → asignación → verificación)
```

---

### **US 9947 — Editar Vehículo**

**Estado actual:**
- 7 TCs Design (obsoletos)
- 3 TCs Ready (consolidar)

**FASE 1:** Renombrar Design a obsoleto
```
10206 → OBSOLETO-9947 - ...Oprimir Cancelar regresa...
10207 → OBSOLETO-9947 - ...Regresar conserva filtros...
10204 → OBSOLETO-9947 - ...Modificar y Guardar muestra confirmación...
10203 → OBSOLETO-9947 - ...Pantalla Editar muestra datos precargados...
10202 → OBSOLETO-9947 - ...Acceder a Revisión Completa redirige...
10208 → OBSOLETO-9947 - ...Pantalla de edición es clara...
10205 → OBSOLETO-9947 - ...Dejar campo vacío muestra validación...
```

**FASE 2:** Crear TC consolidado desde 3 Ready
```
Título: 9947 | VehicleDocs-Vehículos-Editar-Revisión Completa [Flujo Completo]
Pasos: 15 pasos (consolidar 10643, 10644, 10645)
```

---

## 🚀 FASES DE EJECUCIÓN

### **FASE 1: MARCAR OBSOLETOS** ⏱️ 5 min

**Script:** `FASE1-MARCAR-TCs-OBSOLETOS.ps1`

```powershell
.\FASE1-MARCAR-TCs-OBSOLETOS.ps1
```

**Qué hace:**
- Renombra 32 TCs Design a `OBSOLETO-{US_ID} - {título}`
- **NO elimina** ni desvincula nada
- Todos los TCs siguen en sus Suites

**Resultado:**
- 32 TCs renombrados visiblemente como obsoletos
- Fácil de identificar en ADO para revisión posterior

---

### **FASE 2: CREAR TCs CONSOLIDADOS** ⏱️ 1-2h

Para cada US, crear 1 TC consolidado en el mismo Test Suite.

**Prioridad:**

| US | TC Consolidado | Prioridad | Evidencia existente |
|----|----------------|-----------|---------------------|
| 9856 | Nuevos Filtros Grid | ⭐⭐⭐ ALTA | ✅ Sí (4 TCs Closed) |
| 9873 | LocationId | ⭐⭐⭐ ALTA | ✅ Sí (3 TCs Closed) |
| 9817 | Asignación en Lote | ⭐⭐ MEDIA | ❌ No (ejecutar nuevo) |
| 9947 | Editar Vehículo | ⭐⭐ MEDIA | ❌ No (ejecutar nuevo) |
| 9940 | Roles | ⭐ BAJA | ❌ No (ejecutar nuevo) |
| 9892 | Catálogos | ⭐ BAJA | ❌ No (revisar cobertura) |

---

### **FASE 3: REVISIÓN MANUAL** ⏱️ 1-2h

**Por cada TC marcado OBSOLETO:**

1. Abrir el TC en ADO
2. Revisar los pasos
3. Decidir:
   - ✅ **Tiene info valiosa:** Incorporar al TC consolidado
   - ❌ **No tiene nada útil:** Marcar para eliminar
4. Una vez revisado TODO, eliminar los TCs obsoletos sin valor

---

### **FASE 4: EJECUCIÓN DE TCs CONSOLIDADOS** ⏱️ 3-5h

Ejecutar cada TC consolidado nuevo:
- US 9817: 7 pasos → 7 screenshots
- US 9892: Verificar cobertura primero
- US 9940: 11 pasos → 11 screenshots
- US 9947: 15 pasos → 15 screenshots

---

### **FASE 5: DOCUMENTACIÓN** ⏱️ 1h

Publicar comentario en cada US:
```html
QA PASSED / Sprint Test

[placeholder]

<img screenshots apilados>
```

---

## ✅ VENTAJAS DE ESTA ESTRATEGIA

| Ventaja | Explicación |
|---------|-------------|
| 🛡️ **Sin pérdida de información** | Nada se elimina hasta revisión manual |
| 👁️ **Visibilidad clara** | Prefijo "OBSOLETO-{US_ID}" identifica fácilmente |
| 🔄 **Reversible** | Si un TC obsoleto tiene valor, se puede "rescatar" |
| ✅ **Consolidación paralela** | Crear TCs consolidados mientras revisas obsoletos |
| 📸 **Evidencia aprovechada** | USs con TCs Closed mantienen screenshots |

---

## 📁 SCRIPTS GENERADOS

1. ✅ **FASE1-MARCAR-TCs-OBSOLETOS.ps1** — Renombrar TCs Design
2. ⏳ **FASE2-CREAR-TCs-CONSOLIDADOS.ps1** — Por generar
3. ⏳ **FASE3-EJECUTAR-TCs.ps1** — Por generar

---

## 🎯 RESULTADO FINAL

**Antes:**
- 49 TCs mezclados (Design, Ready, Closed)
- Difícil saber cuáles sirven

**Después:**
- ~10 TCs consolidados ejecutados
- TCs obsoletos identificados con prefijo
- Backlog limpio y organizado
- Sin pérdida de información

---

**🤖 Generado por:** GitHub Copilot Agent QA-PRO  
**Fecha:** 2026-06-02
