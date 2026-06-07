---
name: po-user-story
description: Redactar User Stories profesionales para Motorambar (sistema de distribución de vehículos). Usa este skill SIEMPRE que el usuario pida redactar, crear, escribir o estructurar User Stories, USs, historias de usuario, criterios de aceptación, requerimientos funcionales, items de backlog o tareas para Azure DevOps — incluso si no menciona explícitamente "user story". También usa este skill cuando convierta requerimientos en USs, refine el backlog, prepare sprints, divida features en USs más pequeñas, redacte criterios de aceptación, o cuando pida "esto sería una US" o "agregar al sprint". El skill produce USs listas para pegar en Azure DevOps con HTML en descripción y criterios de aceptación.
---

# Redacción de User Stories para Motorambar

Este skill está diseñado para producir User Stories **profesionales y específicas** para el sistema de distribución de vehículos Motorambar. Las USs van a Azure DevOps y se renderizan con HTML, así que tanto descripción como criterios de aceptación se redactan con tags HTML.

## Por qué este skill existe

Las User Stories genéricas ("Como usuario quiero ver una pantalla") no aportan valor al equipo. El valor está en la **especificidad** de las validaciones, los **mensajes UI exactos**, la mención sistemática de **auditoría**, **estados** y **reglas de negocio** del dominio de distribución de vehículos.

## Estructura obligatoria de una US

### 1. Título — formato parametrizable

```
[Módulo]: [Tema o acción] [Variante opcional entre corchetes]
```

**Módulo** es el dominio principal (Vehículo, Inventario, Orden, Cliente, Logística, Usuario, Reporte, Dashboard).

**Tema** es el sub-elemento dentro del módulo (VIN, estado, reserva, tracking, asignación, etc.).

**Variante** entre corchetes para distinguir flujos del mismo tema (Crear, Editar, Ver, Solo lectura, Cambiar estado, etc.).

Ejemplos para Motorambar:
- `Vehículo: Registro de nuevo vehículo en inventario`
- `Vehículo: Cambio de estado [Available → Reserved]`
- `Orden: Asignación de vehículo a cliente`
- `Logística: Tracking de vehículo en tránsito`
- `Inventario: Bandeja de vehículos disponibles`
- `Cliente: Perfil de distribuidor [Ver]`

**Notas de estilo en títulos:**
- Mantener español como idioma principal (salvo acrónimos como VIN)
- Variantes en corchetes van en español (`[Crear]`, `[Solo lectura]`)
- No uses puntos finales en el título

### 2. Descripción — patrón "Como/quiero/para"

Formato HTML literal para Azure DevOps:

```html
<div>Como [rol] quiero [acción concreta] para [beneficio o resultado de negocio].<br> </div>
```

**Rol**: usar el rol funcional, no "usuario" genérico cuando hay rol específico.
- ✅ `Como Gerente de Inventario quiero…`
- ✅ `Como Vendedor quiero…`
- ✅ `Como Cliente/Distribuidor quiero…`
- ✅ `Como Transportista quiero…`
- ✅ `Como Administrador del Sistema quiero…`
- ❌ `Como usuario quiero…` (solo cuando aplica a todos los roles)

**Acción**: verbo en infinitivo + objeto concreto. Evita verbos vagos ("gestionar", "manejar"). Prefiere "registrar", "asignar", "reservar", "cambiar estado", "validar", "rastrear", "actualizar".

**Beneficio**: razón de negocio breve y específica, no genérica.
- ✅ `…para mantener el inventario actualizado y evitar doble asignación.`
- ✅ `…para que el cliente pueda conocer la ubicación de su vehículo en tiempo real.`
- ✅ `…para asegurar la trazabilidad de cada vehículo en el sistema.`
- ❌ `…para mejorar la experiencia.`

### 3. Criterios de aceptación — Formato visual con Scenarios

**NUEVO ESTÁNDAR:** Los criterios se redactan en **Markdown con Scenarios** (NO HTML bullets, NO Feature/Background).

**Formato obligatorio:**
- Estructura: **Scenario N: Título descriptivo**
- Línea 2+: Dado que / Cuando / Entonces / Y...
- Palabras clave en negrita: `**rol**`, `**botón**`, `**pantalla**`, **módulo**, números, estados
- Separador entre scenarios: `___` (línea horizontal en Markdown)
- Sin Feature, sin Background (esa info está en la descripción)

#### Ejemplo de salida correcta — Batch de notificaciones

```
**Scenario 1: Batch exitoso**
Dado que se subió un PDF con 10 facturas válidas al módulo de Facturas
Cuando el sistema finaliza el procesamiento del batch
Entonces se envía exactamente **1 email** y **1 mensaje Teams** (sin notificaciones individuales por factura)
Y el asunto dice "Batch de facturas procesado: 10 facturas | [Fecha Hora]"
Y el cuerpo dice "Todas las facturas del batch fueron procesadas exitosamente"
Y ambos incluyen enlace directo al módulo de Facturas

___

**Scenario 2: Batch con errores parciales**
Dado que se subió un PDF con 7 facturas válidas y 3 con errores
Cuando el sistema finaliza el procesamiento
Entonces se envía **1 email** y **1 Teams** con resumen: ✅ Procesadas: 7 | ❌ Errores: 3
Y el cuerpo dice "Batch finalizó con 3 errores. Revisa el detalle en el módulo de Facturas"

___

**Scenario 3: Batch vacío o inválido**
Dado que se subió un PDF sin facturas válidas
Cuando el sistema intenta procesar el batch
Entonces **NO se envía** ninguna notificación (email ni Teams)
```

**Ventajas del nuevo formato:**
- ✅ Visual y fácil de leer en ADO y chat
- ✅ Palabras clave destacadas para dev/QA
- ✅ Cada scenario es **una acción comprobable** (Given/When/Then)
- ✅ Sin redundancia (Feature ≠ Título)
- ✅ Preparado para integración T2→T3 (Scenario mapea 1:1 con TC y spec)

**Patrones comunes en Scenarios para Motorambar:**

#### Patrón A — Validaciones de campo
```
**Scenario: Validar VIN único**
Dado que existe un vehículo con VIN ABC1234567890123 en el sistema
Cuando intento registrar otro vehículo con el mismo VIN
Entonces el sistema bloquea el registro
Y muestra "El VIN ya está registrado en el sistema"
Y el campo **VIN** se resalta en rojo
```

#### Patrón B — Cambios de estado
```
**Scenario: Cambiar estado [Available → Reserved]**
Dado que hay un vehículo en estado **Available**
Y el usuario es **Vendedor**
Cuando hace clic en botón **Reservar**
Entonces el estado cambia a **Reserved**
Y se envía notificación al **Gerente de Inventario**
Y la acción se registra en **Auditoría** con usuario, fecha, estado anterior/nuevo
```

#### Patrón C — Acciones por rol
```
**Scenario: Gerente de Inventario modifica vehículo**
Dado que el usuario es **Gerente de Inventario**
Y hay un vehículo en estado **Available** o **Reserved**
Cuando accede al formulario de edición
Entonces puede modificar: **VIN**, **Marca**, **Modelo**, **Año**, **Precio**
Y NO puede cambiar **ID Vehículo** (de solo lectura)
Y al guardar, registra la acción en **Auditoría**
```

#### Patrón D — Notificaciones
```
**Scenario: Notificación al cambiar estado a Sold**
Dado que un vehículo cambió a estado **Sold**
Cuando se guarda el cambio
Entonces se envía email al **Gerente de Inventario**
Y se envía mensaje a Teams al canal **#Ventas**
Y el asunto dice "Vehículo [VIN] marcado como Sold - [Fecha]"
Y ambos incluyen enlace al vehículo en el módulo
```

**Cómo escribir cada Scenario:**
1. **Título del Scenario** describe QUÉ se valida (no el cómo ni el por qué)
2. **Dado que** = precondiciones (estado del sistema, datos existentes, rol del usuario)
3. **Cuando** = acción que el usuario ejecuta (1 acción principal, puede tener "Y" para pasos adicionales si hay múltiples click/fill)
4. **Entonces** = resultado observable (estado cambia, mensaje aparece, notificación se envía, auditoría registra)
5. Palabras clave siempre en **negrita** para QA/Dev: roles, botones, estados, módulos, mensajes

> ⚠️ **Regla de oro:** Si un scenario no tiene un "**Entonces**" observable y verificable, no es aceptable — es ambiguo.

## Vocabulario y convenciones del dominio

| Término | Uso |
|---|---|
| **VIN** | Vehicle Identification Number (17 caracteres alfanuméricos) |
| **Inventario** | Stock de vehículos disponibles |
| **Orden** | Pedido/asignación de vehículo a cliente |
| **Reserva** | Vehículo apartado para un cliente |
| **Asignación** | Vehículo vinculado a una orden específica |
| **Tracking** | Seguimiento de ubicación durante tránsito |
| **Lote** | Grupo de vehículos ingresados juntos |
| **Distribuidor** | Cliente que compra vehículos para reventa |
| **Dealer** | Sinónimo de distribuidor |
| **Stock** | Cantidad de vehículos disponibles |
| **Ubicación** | Localización física del vehículo (almacén, en ruta, entregado) |
| **Dar de baja** | Marcar vehículo como Retired (no disponible) |

## Roles del sistema

- **Administrador del Sistema**: Gestión de usuarios, roles, configuración global
- **Gerente de Inventario**: Alta, baja, modificación de vehículos; control de stock
- **Vendedor/Distribuidor**: Consulta de inventario, reservas, órdenes de compra
- **Transportista/Logistics**: Actualización de tracking, cambio de ubicación
- **Cliente/Dealer**: Consulta de órdenes, tracking de vehículos asignados
- **Auditor**: Solo lectura, acceso a reportes y logs de auditoría

## Plantillas por tipo de US — Nuevo formato (Markdown Scenarios)

### Plantilla A — US de CRUD/Formulario

**Descripción (HTML):**
```html
<div>Como [rol] quiero [crear/editar/eliminar/visualizar] [entidad] para [beneficio].<br> </div>
```

**Criterios (Markdown Scenarios):**
```
**Scenario 1: [Rol] accede al formulario**
Dado que el usuario es **[Rol]**
Cuando hace clic en botón **[Crear/Editar]**
Entonces se abre el formulario con los campos:
  • **[Campo 1]** * (requerido, validación)
  • **[Campo 2]** * (requerido, validación)
  • **[Campo 3]** (opcional)

___

**Scenario 2: Validaciones de campos**
Dado que el formulario está abierto
Cuando intento guardar sin completar **[Campo requerido]**
Entonces el sistema bloquea el guardado
Y muestra "Campo requerido: [Campo]"
Y el campo se resalta en rojo

___

**Scenario 3: Guardar cambios exitosamente**
Dado que ingresé datos válidos en todos los campos requeridos
Cuando hago clic en botón **Guardar**
Entonces los datos se persisten en la base de datos
Y se envía mensaje "Cambios guardados exitosamente"
Y la acción se registra en **Auditoría** (usuario, fecha, campos modificados)

___

**Scenario 4: Validación de duplicados**
Dado que existe [entidad] con **[Campo único]** = "ABC123"
Cuando intento crear/editar otro con el mismo **[Campo único]**
Entonces el sistema bloquea la operación
Y muestra "[Campo] ya existe en el sistema"
```

### Plantilla B — US de Validación

**Descripción (HTML):**
```html
<div>Como [rol] quiero que el sistema valide [regla] para [evitar problema o asegurar política].<br> </div>
```

**Criterios (Markdown Scenarios):**
```
**Scenario 1: Validación exitosa (pasa)**
Dado que ingresé datos que cumplen la regla **[Regla]**
Cuando intento ejecutar **[Acción]**
Entonces el sistema permite continuar
Y muestra mensaje de confirmación

___

**Scenario 2: Validación fallida (bloquea)**
Dado que ingresé datos que NO cumplen la regla **[Regla]**
Cuando intento ejecutar **[Acción]**
Entonces el sistema bloquea la operación
Y muestra mensaje de error: "[Mensaje específico]"
Y el campo inválido se resalta en rojo

___

**Scenario 3: Auditoría de intentos fallidos**
Dado que intenté ejecutar **[Acción]** con datos inválidos
Cuando falla la validación
Entonces el sistema registra en **Auditoría**:
  • Usuario que intentó
  • Fecha/Hora
  • Acción intentada
  • Motivo del rechazo
```

### Plantilla C — US de Workflow/Cambio de Estado

**Descripción (HTML):**
```html
<div>Como [rol] quiero [acción del workflow] para [siguiente paso del proceso].<br> </div>
```

**Criterios (Markdown Scenarios):**
```
**Scenario 1: Cambiar estado [Estado Origen → Estado Destino]**
Dado que el **[Entidad]** está en estado **[Estado Origen]**
Y el usuario es **[Rol autorizado]**
Cuando hace clic en botón **[Acción]**
Entonces aparece modal de confirmación con:
  • Título: "[Título Modal]"
  • Campo **[Campo requerido]** * (opcional/requerido)
  • Botones: Cancelar y **[Acción]**

___

**Scenario 2: Confirmar cambio de estado**
Dado que el modal de confirmación está abierto
Cuando hace clic en botón **[Acción]** después de rellenar campos
Entonces el estado pasa de **[Estado Origen]** a **[Estado Destino]**
Y se envía notificación a **[Destinatarios]** con asunto "[Asunto Email]"
Y la acción se registra en **Auditoría** (usuario, fecha, estado origen, estado destino, motivo)

___

**Scenario 3: Cancelar cambio de estado**
Dado que el modal de confirmación está abierto
Cuando hace clic en botón **Cancelar**
Entonces el modal se cierra
Y el estado del **[Entidad]** NO cambia
Y NO se registra nada en **Auditoría**

___

**Scenario 4: Rol sin permiso NO ve acción**
Dado que el usuario es **[Rol sin permiso]**
Y el **[Entidad]** está en estado **[Estado Origen]**
Cuando accede a la pantalla
Entonces el botón **[Acción]** NO es visible
Y el rol solo ve opciones disponibles para él
```

### Plantilla D — US de Bandeja/Listado

**Descripción (HTML):**
```html
<div>Como [rol] quiero visualizar [entidades] en una bandeja para [gestionar/dar seguimiento].<br> </div>
```

**Criterios (Markdown Scenarios):**
```
**Scenario 1: Mostrar bandeja con datos y columnas**
Dado que el usuario es **[Rol]**
Cuando accede a la sección **[Módulo]** → **[Bandeja]**
Entonces ve tabla con columnas:
  • **[Columna 1]** (texto)
  • **[Columna 2]** (estado con badge de color)
  • **[Columna 3]** (fecha)
  • **Acciones** (Ver, Editar, Eliminar según permisos)

___

**Scenario 2: Filtrar por criterios**
Dado que hay 100 registros en la bandeja
Cuando aplico filtro **[Criterio]** = "[Valor]"
Entonces solo se muestran registros que coinciden
Y se muestra "X de 100 registros"

___

**Scenario 3: Búsqueda por texto**
Dado que hay 100 registros en la bandeja
Cuando escribo "[Texto]" en campo de búsqueda
Entonces se filtran registros que contengan ese texto
Y la búsqueda es **case-insensitive**

___

**Scenario 4: Paginación**
Dado que hay 150 registros (más de una página)
Cuando la bandeja está configurada para 10 filas por página
Entonces se muestra "Página 1 de 15"
Y puedo navegar: [Primera] [Anterior] [1 2 3...] [Siguiente] [Última]
Y puedo cambiar filas/página: 10/25/50/100
```

### Plantilla E — US de Tracking/Logística

**Descripción (HTML):**
```html
<div>Como [rol] quiero [rastrear/actualizar ubicación] del vehículo para [trazabilidad/informar al cliente].<br> </div>
```

**Criterios (Markdown Scenarios):**
```
**Scenario 1: Actualizar ubicación (usuario Transportista)**
Dado que el vehículo está en estado **InTransit**
Y el usuario es **Transportista**
Cuando hace clic en botón **Actualizar ubicación**
Entonces se abre formulario con campos:
  • **Ubicación actual** * (texto libre)
  • **Fecha/Hora** (automático, timestamp actual)
  • **Observaciones** (opcional, 0-200 caracteres)

___

**Scenario 2: Guardar ubicación y notificar cliente**
Dado que el formulario está completo
Cuando hace clic en **Guardar**
Entonces:
  • La ubicación se registra en **Historial de ubicaciones**
  • Se envía SMS/Email al **Cliente** con mensaje: "[Mensaje personalizado con ubicación]"
  • La acción se registra en **Auditoría** (usuario, fecha, ubicación anterior, nueva ubicación)

___

**Scenario 3: Ver historial de ubicaciones**
Dado que estoy visualizando un vehículo en estado **InTransit**
Cuando hago clic en **Ver historial**
Entonces se muestra tabla con:
  • **Fecha/Hora** (más reciente primero)
  • **Ubicación**
  • **Observaciones**
  • **Actualizado por** (usuario/Transportista)

___

**Scenario 4: Mostrar mapa de ubicación (opcional)**
Dado que visualizo el vehículo en tránsito
Cuando se carga la pantalla
Entonces se muestra mapa con **Última ubicación conocida** marcada
Y el marcador actualiza cada vez que se envía una ubicación
```


## Cómo proceder cuando se invoca este skill

1. **Identifica el módulo** (Vehículo, Inventario, Orden, Logística, etc.) y el **tipo de US** (CRUD, validación, workflow, bandeja, tracking).

2. **Pregunta lo mínimo necesario** si falta contexto crítico — específicamente:
   - ¿Qué rol(es) la ejecutan?
   - ¿En qué estado(s) del vehículo aplica?
   - ¿Hay validaciones específicas (VIN único, año válido, precio, etc.)?
   - ¿Qué notificaciones dispara?
   - ¿Requiere tracking o actualización de ubicación?

3. **Aplica la plantilla** correspondiente y rellena con detalles específicos del dominio de distribución de vehículos.

4. **Genera siempre**: título, descripción HTML, criterios HTML.

5. **Si vas a crear en Azure DevOps**, usa el proyecto `Motorambar` (o el activo) y `System.IterationPath` correspondiente. Los campos clave son:
   - `System.Title`
   - `System.IterationPath`
   - `System.Description` (formato Html)
   - `Microsoft.VSTS.Common.AcceptanceCriteria` (formato Markdown — los Scenarios van en Markdown, el sistema de ADO los renderiza automáticamente)

6. **Estructura final entregada** al usuario debe ser fácil de leer en chat (Markdown Scenarios) Y publicable en Azure DevOps (ADO acepta Markdown en AcceptanceCriteria). Si vas a crear directamente en Azure DevOps, muestra el resumen en chat y crea la US con los datos directamente.

## Ejemplo completo de salida — referencia "gold standard"

**Título**: `Vehículo: Validación de VIN único en registro`

**Descripción (HTML)**:
```html
<div>Como Gerente de Inventario quiero que el sistema valide que el VIN sea único para evitar registrar vehículos duplicados en el inventario.<br> </div>
```

**Criterios de aceptación (Markdown Scenarios)**:
```
**Scenario 1: VIN único — registro exitoso**
Dado que estoy en el formulario de registro de vehículo
Y ingresé un **VIN** que no existe en la base de datos (17 caracteres alfanuméricos válidos)
Cuando completo los otros campos obligatorios y hago clic en **Guardar**
Entonces el sistema valida y acepta el registro
Y muestra "Vehículo registrado exitosamente con VIN: [VIN]"
Y el vehículo aparece en la bandeja de inventario

___

**Scenario 2: VIN duplicado — registro bloqueado**
Dado que existe un vehículo con **VIN** = "ABC1234567890123"
Y estoy intentando registrar otro vehículo con el mismo **VIN**
Cuando completo el formulario e intento **Guardar**
Entonces el sistema bloquea el registro
Y muestra "El VIN ABC1234567890123 ya está registrado en el sistema (ID: 12345). No se puede registrar un vehículo duplicado."
Y el campo **VIN** se resalta en rojo
Y el formulario permanece abierto con todos los datos ingresados (para corrección)

___

**Scenario 3: Auditoría de intento fallido**
Dado que intenté guardar un vehículo con **VIN duplicado**
Y el sistema rechazó la operación
Entonces el intento fallido se registra en **Auditoría** con:
  • Usuario que intentó
  • Fecha/Hora del intento
  • VIN duplicado
  • Motivo: "Validación de duplicados fallida"

___

**Scenario 4: Validación de formato VIN**
Dado que estoy en el formulario de registro
Cuando intento guardar un vehículo con **VIN inválido** (menos de 17 caracteres o caracteres especiales)
Entonces el sistema bloquea el registro
Y muestra "VIN inválido. Debe tener exactamente 17 caracteres alfanuméricos."
Y el campo **VIN** se resalta en rojo
```


## Cuándo NO usar este skill

- Cuando el usuario pide otro tipo de documento (especificación técnica detallada, arquitectura, propuesta comercial, presentación).
- Cuando el usuario quiere brainstorm libre sobre ideas de producto sin estructura aún.
- Cuando solo pide buscar o consultar USs existentes en Azure DevOps (es una tarea de consulta, no de redacción).
- Cuando pide crear **Test Cases** (ese es el skill `create-test-cases` o `qa_tester`).

## Referencias adicionales

Si necesitas más detalle sobre el dominio de Motorambar, consulta el archivo `references/dominio-motorambar.md` incluido en este skill.
