# FASE 2: PROGRESO DE CREACIÓN DE TCs CONSOLIDADOS

**Fecha inicio:** 2026-06-02  
**Total USs:** 6  
**TCs consolidados creados:** 1 / 6  

---

## ✅ US 9856 — Nuevos Filtros Grid (COMPLETADA + DOCUMENTADA)

**TC Consolidado:** [11231](https://dev.azure.com/AutoregPR/Motorambar/_workitems/edit/11231)  
**Título:** `9856 | VehicleDocs-Vehículos Importados-Grid-Nuevos Filtros de Búsqueda [Flujo Completo]`  
**Estado:** Ready  
**Total pasos:** 11 pasos  
**Test Plan:** [10659](https://dev.azure.com/AutoregPR/Motorambar/_testManagement/runs?planId=10659)  
**Test Suite:** [10660](https://dev.azure.com/AutoregPR/Motorambar/_testManagement/runs?planId=10659&suiteId=10660)  

### 📋 Documentación QA
- ✅ Comentario [QA PASSED](https://dev.azure.com/AutoregPR/Motorambar/_workitems/edit/9856) publicado
- ✅ Referencias a TCs con evidencia (10666, 10667, 10668, 10669)
- ✅ US en estado Closed
- ✅ Sprint Test completado

### TCs originales consolidados:
- ✅ TC 10666 (4 pasos) — Visualizar y buscar por nuevos filtros
- ✅ TC 10667 (2 pasos) — Validar restricciones de entrada
- ✅ TC 10668 (3 pasos) — Búsqueda por rango de fechas
- ✅ TC 10669 (2 pasos) — Persistencia y retención

### Evidencia existente:
**✅ Los 4 TCs Closed YA tienen screenshots capturados**  
No requiere ejecución nueva, solo copiar las imágenes de los TCs originales.

### TCs obsoletos marcados:
- [OBSOLETO-9856] TC 10233 → Más Filtros muestra Invoice y Credit Letter
- [OBSOLETO-9856] TC 10234 → Buscar filtra correctamente
- [OBSOLETO-9856] TC 10235 → Validaciones de Invoice
- [OBSOLETO-9856] TC 10236 → Rango Fechas usa calendario
- [OBSOLETO-9856] TC 10237 → Regresar conserva filtros
- [OBSOLETO-9856] TC 10238 → Filtros claros y usables

---

## ⏳ US 9873 — Asignación LocationId (PENDIENTE)

**Acción:** Solo renombrar los 3 TCs Closed existentes con formato correcto.

### TCs Closed a mantener:
- TC 10670 → Renombrar a: `9873 | VehicleDocs-Vehículos-Editar-LocationId [Asignación Automática]`
- TC 10671 → Renombrar a: `9873 | VehicleDocs-Vehículos-Editar-LocationId [Gestión Errores]`
- TC 10672 → Renombrar a: `9873 | VehicleDocs-Vehículos-Editar-LocationId [Interfaz]`

### TCs obsoletos marcados:
- [OBSOLETO-9873] TC 10625 → Prioridad Banco sobre Dealer
- [OBSOLETO-9873] TC 10626 → Asignación a Dealer
- [OBSOLETO-9873] TC 10627 → Solo Banco
- [OBSOLETO-9873] TC 10628 → Sin Dealer ni Banco
- [OBSOLETO-9873] TC 10629 → Visualización de Inputs

---

## ⏳ US 9817 — Asignación en Lote (PENDIENTE)

**Acción:** Crear 1 TC consolidado nuevo + Ejecutar

### TC consolidado a crear:
**Título:** `9817 | VehicleDocs-Vehículos Importados-Asignación en Lote [Flujo Completo]`  
**Total pasos:** ~7-8 pasos  

### Escenarios a cubrir:
1. Seleccionar VINs → Abrir popup
2. Visualizar cantidad VINs y clientes preferidos
3. Buscar cliente por nombre → Mostrar resultados con tipo
4. Confirmar sin seleccionar cliente → Mensaje de validación
5. Seleccionar cliente y confirmar → Mensaje de éxito + Grid actualizado
6. Verificar VINs actualizados con cliente correcto
7. Cancelar popup → Cerrar y mantener selección

### TCs obsoletos marcados:
- [OBSOLETO-9817] TC 10283 → Buscar clientes
- [OBSOLETO-9817] TC 10284 → Confirmar muestra éxito
- [OBSOLETO-9817] TC 10285 → Sin cliente muestra validación
- [OBSOLETO-9817] TC 10286 → Cancelar cierra popup
- [OBSOLETO-9817] TC 10282 → Popup muestra VIN y clientes
- [OBSOLETO-9817] TC 10287 → Flujo claro

---

## ⏳ US 9947 — Editar Vehículo (PENDIENTE)

**Acción:** Crear 1 TC consolidado desde 3 TCs Ready + Ejecutar

### TCs Ready a consolidar:
- TC 10643 (4 pasos) → Acceso a pantalla Editar
- TC 10644 (6 pasos) → Validación de información precargada
- TC 10645 (5 pasos) → Validación modo Read Only

**TC consolidado a crear:**  
**Título:** `9947 | VehicleDocs-Vehículos-Editar-Revisión Completa [Flujo Completo]`  
**Total pasos:** ~15 pasos

### TCs obsoletos marcados:
- [OBSOLETO-9947] TC 10206 → Oprimir Cancelar regresa sin guardar
- [OBSOLETO-9947] TC 10207 → Regresar conserva filtros
- [OBSOLETO-9947] TC 10204 → Modificar y Guardar
- [OBSOLETO-9947] TC 10203 → Pantalla muestra datos precargados
- [OBSOLETO-9947] TC 10202 → Acceder redirige con VIN correcto
- [OBSOLETO-9947] TC 10208 → Pantalla clara
- [OBSOLETO-9947] TC 10205 → Campo vacío muestra validación

---

## ⏳ US 9940 — Roles (PENDIENTE)

**Acción:** Crear 1 TC consolidado nuevo + Ejecutar

**TC consolidado a crear:**  
**Título:** `9940 | VehicleDocs-Admin-Roles-Gestión de Roles [Flujo Completo]`  
**Total pasos:** ~11 pasos

### Escenarios a cubrir:
- Navegación a sección Roles
- Visualización de pantalla de gestión
- Información legible y organizada
- Asignar rol Distribuidor
- Confirmar acceso desde portal Motorambar

### TCs obsoletos marcados:
- [OBSOLETO-9940] TC 10086 → Pantalla muestra información legible
- [OBSOLETO-9940] TC 10084 → Sección disponible
- [OBSOLETO-9940] TC 10085 → Asignar rol

---

## ⏳ US 9892 — Catálogos Documentos (PENDIENTE)

**Acción:** Verificar si son TCs de backend (Cobertura DEV) o QA

### TCs obsoletos marcados:
- [OBSOLETO-9892] TC 10067 → Categoría Factura disponible
- [OBSOLETO-9892] TC 10066 → Categorías visibles
- [OBSOLETO-9892] TC 10068 → Sin duplicados
- [OBSOLETO-9892] TC 10069 → Inactivas no aparecen
- [OBSOLETO-9892] TC 10070 → Listado legible
- [OBSOLETO-9892] TC 10678 → Validación inconsistencias
- [OBSOLETO-9892] TC 10677 → Sincronización y Mapeo

**Nota:** Los 2 últimos TCs (10678, 10677) parecen ser de backend. Revisar antes de consolidar.

---

## 📊 RESUMEN GENERAL

| US | TCs Obsoletos | TC Consolidado | Estado |
|----|--------------|----------------|--------|
| **9856** | 6 Design | ✅ TC 11231 (11 pasos) | **Completado** |
| **9873** | 5 Design | Renombrar 3 Closed | Pendiente |
| **9817** | 6 Design | Crear nuevo (7 pasos) | Pendiente |
| **9947** | 7 Design | Crear nuevo (15 pasos) | Pendiente |
| **9940** | 3 Design | Crear nuevo (11 pasos) | Pendiente |
| **9892** | 7 Design | Verificar cobertura | Pendiente |

---

**🤖 Última actualización:** 2026-06-02 21:58 UTC  
**Próximo TC:** US 9873 (renombrar existentes)
