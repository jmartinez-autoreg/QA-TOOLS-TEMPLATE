# PLAN DE CONSOLIDACIÓN DE TEST CASES — Backlog S2 Entregable 3

**Fecha:** 2026-06-02  
**Objetivo:** Consolidar TCs fragmentados en TCs únicos, aprovechando resultados existentes  

---

## 📊 RESUMEN EJECUTIVO

| Métrica | Valor |
|---------|-------|
| **USs analizadas** | 7 |
| **Total TCs actuales** | 49 Test Cases |
| **TCs Design (obsoletos)** | 32 TCs → ❌ ELIMINAR |
| **TCs Closed (con resultados)** | 13 TCs → ✅ APROVECHAR EVIDENCIA |
| **TCs Ready** | 4 TCs → 🔄 CONSOLIDAR |
| **TCs consolidados finales** | ~7-10 TCs (estimado) |

**Reducción esperada:** De 49 TCs → ~10 TCs (**80% reducción**)

---

## 📋 PLAN DETALLADO POR US

### **US 9502 — Seguridad: Autenticación (DISTRIBUIDOR)**

| Métrica | Valor |
|---------|-------|
| TCs actuales | 1 TC |
| Estado | Closed |
| Acción | ✅ **MANTENER** — Solo 1 TC, ya ejecutado |

**Detalles:**
- TC 10049 (Closed): "Sesión permanece activa durante navegación" — 6 pasos
- **No requiere consolidación** — ya es atómico

---

### **US 9817 — Vehículos: Grid de Registros Asignación en Lote**

| Métrica | Valor |
|---------|-------|
| TCs actuales | 6 TCs |
| TCs Design | 6 TCs (TODOS) |
| TCs Closed | 0 |
| Acción | 🔄 **CONSOLIDAR TODO** → 1 TC único |

**TCs a ELIMINAR (Design):**
```
✗ 10283: "...muestra resultados con nombre..." (1 paso)
✗ 10284: "...confirmar asignación muestra mensaje..." (1 paso)
✗ 10285: "...sin seleccionar cliente muestra validación" (1 paso)
✗ 10286: "...cancelar cierra el popup" (1 paso)
✗ 10282: "...popup muestra cantidad de VIN" (1 paso)
✗ 10287: "...flujo es claro y usable" (1 paso)
```

**TC CONSOLIDADO (crear nuevo):**
```
9817 | VehicleDocs-Vehículos Importados-Asignación en Lote [Flujo Completo]

PRECOND 0: Datos en sistema [3 vehículos sin asignar]
PRECOND 1: Login - Usuario: admin - Rol: Administrador - Acceso portal: VehicleDocs - Acceso módulo: Vehículos Importados / Grid

STEP 1: Seleccionar 3 VINs en el grid
STEP 2: Clic en botón "Asignar en Lote"
  → Popup abierto mostrando cantidad de VINs (3) y clientes preferidos con tipo
  
STEP 3: Buscar cliente escribiendo "AutoReg"
  → Lista de resultados mostrando nombre "AutoReg Rental" y tipo "Rental"
  
STEP 4: Clic en "Guardar" sin seleccionar cliente
  → Mensaje de validación "Debe seleccionar un cliente"
  
STEP 5: Seleccionar cliente "AutoReg Rental" y clic en "Guardar"
  → Mensaje "Asignación exitosa" y grid actualizado
  
STEP 6: Verificar que los 3 VINs ahora muestran "AutoReg Rental" en columna Cliente
  → Cliente correcto visible en las 3 filas
  
STEP 7: Clic en botón "Asignar en Lote" nuevamente y clic en "Cancelar"
  → Popup cerrado y selección de VINs mantenida
```

**Screenshots requeridos:** 7 (uno por cada resultado esperado)

---

### **US 9856 — Vehículos: Grid de Registros NUEVOS Criterios de Búsqueda Pantalla**

| Métrica | Valor |
|---------|-------|
| TCs actuales | 10 TCs |
| TCs Design | 6 TCs → ❌ ELIMINAR |
| TCs Closed | 4 TCs → ✅ APROVECHAR |
| Acción | 🔄 **Consolidar 4 TCs Closed en 1** |

**TCs a ELIMINAR (Design - obsoletos):**
```
✗ 10233: "...Sección Más Filtros muestra campos" (1 paso)
✗ 10234: "...Buscar por Invoice filtra correctamente" (2 pasos)
✗ 10235: "...Validaciones muestran mensaje de error" (2 pasos)
✗ 10236: "...Filtro Rango de Fechas usa calendario" (3 pasos)
✗ 10237: "...Regresar conserva filtros" (2 pasos)
✗ 10238: "...Filtros visualmente claros" (1 paso)
```

**TCs a CONSOLIDAR (Closed - ya ejecutados):**
```
✓ 10666: "TC-9856-1: Visualizar y buscar por nuevos filtros..." (4 pasos) ← YA TIENE SCREENSHOTS
✓ 10667: "TC-9856-2: Validar restricciones de entrada..." (2 pasos) ← YA TIENE SCREENSHOTS
✓ 10668: "TC-9856-3: Búsqueda y filtrado por rango de fechas..." (3 pasos) ← YA TIENE SCREENSHOTS
✓ 10669: "TC-9856-4: Persistencia y retención de filtros..." (2 pasos) ← YA TIENE SCREENSHOTS
```

**TC CONSOLIDADO (usar evidencia existente):**
```
9856 | VehicleDocs-Vehículos Importados-Grid-Nuevos Filtros de Búsqueda [Flujo Completo]

PRECOND 0: Datos en sistema [vehículos con invoices, credit letters, fechas variadas]
PRECOND 1: Login - Usuario: admin - Rol: Administrador - Acceso portal: VehicleDocs - Acceso módulo: Vehículos Importados / Grid

[Combinar los 11 pasos de los 4 TCs Closed en un solo flujo secuencial]

STEP 1-4: De TC 10666 (Visualizar y buscar)
STEP 5-6: De TC 10667 (Validaciones)
STEP 7-9: De TC 10668 (Rango de fechas)
STEP 10-11: De TC 10669 (Persistencia)
```

**Beneficio:** Usar los screenshots YA CAPTURADOS de los 4 TCs Closed

---

### **US 9873 — Importación Vehicular: Localidades - Asignar automáticamente LocationId**

| Métrica | Valor |
|---------|-------|
| TCs actuales | 8 TCs |
| TCs Design | 5 TCs → ❌ ELIMINAR |
| TCs Closed | 3 TCs → ✅ MANTENER |
| Acción | ⚠️ **Eliminar 5 Design, mantener 3 Closed** |

**TCs a ELIMINAR (Design - obsoletos):**
```
✗ 10625: "[Asignación Automática] - Prioridad Banco..." (2 pasos)
✗ 10626: "[Asignación Automática] - Asignación a Dealer..." (2 pasos)
✗ 10627: "[Asignación Automática] - Solo Banco..." (2 pasos)
✗ 10628: "[Asignación Automática] - Sin Dealer ni Banco..." (2 pasos)
✗ 10629: "[Interfaz] - Visualización de Inputs..." (2 pasos)
```

**TCs a MANTENER (Closed - ya ejecutados con evidencia):**
```
✓ 10670: "TC-9873-1: Asignación automática de LocationId..." (5 pasos)
✓ 10671: "TC-9873-2: Gestión de errores..." (4 pasos)
✓ 10672: "TC-9873-3: Interfaz de edición..." (2 pasos)
```

**Acción:** Solo eliminar 5 TCs Design. Los 3 Closed ya están bien consolidados.

**Opcional:** Renombrar con formato `9873 | VehicleDocs-...` si no lo tienen

---

### **US 9892 — Catálogos: Documentos - Portal de Distribuidor**

| Métrica | Valor |
|---------|-------|
| TCs actuales | 7 TCs |
| TCs Design | 7 TCs (TODOS) |
| TCs Closed | 0 |
| Acción | 🔄 **CONSOLIDAR TODO** → 1-2 TCs |

**TCs a ELIMINAR (Design):**
```
✗ 10067: "...Categoría Factura disponible..." (4 pasos)
✗ 10066: "...Categorías existentes visibles..." (6 pasos)
✗ 10068: "...Sin categorías duplicadas..." (4 pasos)
✗ 10069: "...Categorías inactivas no aparecen..." (4 pasos)
✗ 10070: "...Listado legible y accesible..." (4 pasos)
✗ 10678: "TC-9892-2: Validación inconsistencias..." (2 pasos)
✗ 10677: "TC-9892-1: Sincronización, Mapeo..." (3 pasos)
```

**TC CONSOLIDADO (crear nuevo):**
```
9892 | VehicleDocs-Catálogos-Documentos-Portal Distribuidor [Sincronización y Visualización]

[Combinar los ~27 pasos en un flujo lógico]
```

**Nota:** Algunos TCs parecen cubrir backend (sincronización) → verificar si son Cobertura DEV

---

### **US 9940 — Roles desde Motorambar**

| Métrica | Valor |
|---------|-------|
| TCs actuales | 3 TCs |
| TCs Design | 3 TCs (TODOS) |
| TCs Closed | 0 |
| Acción | 🔄 **CONSOLIDAR TODO** → 1 TC |

**TCs a ELIMINAR (Design):**
```
✗ 10086: "...Pantalla de gestión muestra información..." (3 pasos)
✗ 10084: "...Sección de roles disponible..." (3 pasos)
✗ 10085: "...Asignar rol Distribuidor y acceso..." (5 pasos)
```

**TC CONSOLIDADO (crear nuevo):**
```
9940 | VehicleDocs-Admin-Roles-Gestión de Roles [Flujo Completo]

[Combinar 11 pasos en flujo secuencial: Navegar → Visualizar → Asignar rol → Confirmar acceso]
```

---

### **US 9947 — Vehículos Revisión Completa: Click Revisión Completa editar**

| Métrica | Valor |
|---------|-------|
| TCs actuales | 10 TCs |
| TCs Design | 7 TCs → ❌ ELIMINAR |
| TCs Closed | 0 |
| TCs Ready | 3 TCs → 🔄 CONSOLIDAR |
| Acción | ⚠️ **Eliminar 7 Design, consolidar 3 Ready** |

**TCs a ELIMINAR (Design - obsoletos):**
```
✗ 10206: "...Oprimir Cancelar regresa..." (2 pasos)
✗ 10207: "...Regresar conserva filtros..." (2 pasos)
✗ 10204: "...Modificar y Guardar muestra confirmación..." (2 pasos)
✗ 10203: "...Pantalla Editar muestra datos precargados..." (2 pasos)
✗ 10202: "...Acceder a Revisión Completa redirige..." (2 pasos)
✗ 10208: "...Pantalla de edición es clara..." (2 pasos)
✗ 10205: "...Dejar campo vacío muestra validación..." (2 pasos)
```

**TCs Ready (consolidar en 1):**
```
🔵 10645: "TC: Validación de modo Read Only..." (5 pasos)
🔵 10644: "TC: Validación de información precargada..." (6 pasos)
🔵 10643: "TC: Acceso a pantalla Editar..." (4 pasos)
```

**TC CONSOLIDADO (crear nuevo):**
```
9947 | VehicleDocs-Vehículos Importados-Editar Vehículo-Revisión Completa [Flujo Completo]

[Combinar 15 pasos de los 3 TCs Ready]
```

---

## 🎯 PLAN DE EJECUCIÓN

### **FASE 1: LIMPIEZA (Eliminar TCs obsoletos)**

**Tiempo estimado:** 30 min

```powershell
# Desvincular TCs Design de sus USs
$tcsEliminar = @(
    # US 9817
    10283, 10284, 10285, 10286, 10282, 10287,
    # US 9856
    10233, 10234, 10235, 10236, 10237, 10238,
    # US 9873
    10625, 10626, 10627, 10628, 10629,
    # US 9892
    10067, 10066, 10068, 10069, 10070, 10678, 10677,
    # US 9940
    10086, 10084, 10085,
    # US 9947
    10206, 10207, 10204, 10203, 10202, 10208, 10205
)

# Total: 32 TCs a desvincular
```

**Acción:** Eliminar vínculo "Tested By" de cada US → TC

---

### **FASE 2: CONSOLIDACIÓN CON EVIDENCIA EXISTENTE**

**Tiempo estimado:** 2-3h

| US | Acción | Screenshots |
|----|--------|-------------|
| **9856** | Crear TC consolidado usando evidencia de 4 TCs Closed | ✅ Ya existen |
| **9873** | Solo renombrar 3 TCs Closed si es necesario | ✅ Ya existen |

---

### **FASE 3: CONSOLIDACIÓN CON EJECUCIÓN NUEVA**

**Tiempo estimado:** 4-6h

| US | TCs a crear | Screenshots nuevos |
|----|-------------|-------------------|
| **9817** | 1 TC (7 pasos) | 7 screenshots |
| **9892** | 1-2 TCs | Según análisis de cobertura |
| **9940** | 1 TC (11 pasos) | 11 screenshots |
| **9947** | 1 TC (15 pasos) | 15 screenshots |

---

### **FASE 4: DOCUMENTACIÓN EN USs**

**Tiempo estimado:** 1h

Publicar comentario "QA PASSED / Sprint Test" + screenshots en cada US.

---

## 📊 RESULTADO FINAL

| Antes | Después | Reducción |
|-------|---------|-----------|
| 49 TCs | ~10 TCs | **80%** |
| 32 TCs obsoletos | 0 TCs obsoletos | **100%** |
| 13 TCs con evidencia | Evidencia reutilizada | **Aprovechada** |

---

**✅ Backlog limpio, TCs atómicos, evidencia aprovechada**

**🤖 Generado por:** GitHub Copilot Agent QA-PRO  
**Fecha:** 2026-06-02
