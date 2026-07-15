---
name: create-test-cases
description: 'Crea Test Cases profesionales en Azure DevOps siguiendo estándares QA empresariales. Usar cuando el usuario pida crear, redactar, generar, dividir o corregir TCs, casos de prueba o test cases en cualquier organización/proyecto de ADO. Aplica nomenclatura Portal-Módulo-Pantalla-Funcionalidad [Escenario], estructura PRECOND secuencial 0..N (Login siempre el último), y resultados esperados observables.'
argument-hint: 'Describe la funcionalidad a testear, pega pasos de un TC existente, o indica org/proyecto/plan/suite'
---

# Crear Test Cases Profesionales en Azure DevOps

Skill genérica para crear TCs de alta calidad en cualquier organización y proyecto de Azure DevOps, siguiendo estándares QA empresariales.

---

## 1. Recolectar contexto — SIEMPRE preguntar primero

Antes de crear cualquier TC, necesitas estos datos. **Pregunta todo lo que falte:**

| Dato | Ejemplo | Obligatorio |
|------|---------|-------------|
| **Organización ADO** | `MiOrg` | No — viene de `context/CONTEXT.md` § "Organización ADO" (AGENTS.md §2). Preguntar solo si falta o el usuario indica otra. |
| **Proyecto ADO** | `MiProyecto` | No — viene de `context/CONTEXT.md` § "Organización ADO" (AGENTS.md §2). Preguntar solo si falta o el usuario indica otro. |
| **Test Plan ID** | `9361` | No — si falta, resolver con la convención oficial: plan del **Equipo-Sprint** actual (ver `qa_tester` § "Estructura del Test Plan en ADO"). Preguntar solo si no se puede resolver. |
| **Test Suite ID** | `9363` | No — si falta, buscar/crear la suite de la US (`{US_ID}: {Título}`) dentro del plan del sprint. Preguntar solo si no hay US vinculada. |
| **User Story / Work Item** | `US 9313` | Recomendado |
| **Portal / Aplicación** | `AutoReg`, `MiPortal` | Sí (para el título) |
| **Módulo** | `Preventas`, `Ventas` | Sí (para el título) |
| **Pantalla / Funcionalidad** | `Proc. Preventas Excel` | Sí (para el título) |
| **URL de la pantalla** | `https://app.empresa.com/Forms/Modulo.aspx` | Sí — incluir en pasos de navegación. Requerida para automatización futura. |
| **Usuario de prueba** | `graciagc` | Sí (para PRECOND Login) |
| **Rol del usuario** | `CASE CREATOR` | Sí (para PRECOND Login) |
| **Escenarios a cubrir** | Happy path, errores, cancelar... | Sí |

> Si el usuario ya proporcionó esta información en mensajes previos o en el contexto de la conversación, no vuelvas a preguntar.

---

## 2. Estilos y Formatos (estándar oficial)

> **Fuente:** GUÍA-QA-Redacción de casos de pruebas v1.00 §2 (Tabla 1)

### 2.1 Reglas de formato en pasos de TC

| Elemento | Cómo usarlo | Ejemplo válido | Ejemplo NO válido |
|----------|-------------|----------------|-------------------|
| **Bold en nombres UI** | Usar **bold** para títulos de pantallas, nombres de campos, botones con >1 palabra. Ser consistente en todo el TC. | `Clic en el botón **Enviar solicitud**` | `Clic en el botón Enviar solicitud` (sin bold) |
| **Comillas dobles** | Alternativa al bold para títulos/nombres UI. Mantener consistencia: si usas comillas en un elemento, usarlas en todos los del mismo tipo. | `Ir a pantalla "Ingresar factura"` | Mezclar: `"Ingresar factura"` y `Ingresar usuarios` sin comillas |
| **Comillas simples** | Otra alternativa al bold. Mismo criterio de consistencia. | `Ir a pantalla 'Ingresar factura'` | Mezclar comillas dobles y simples |
| **`botón (seleccionado)`** | Al describir alertas/modales con varios botones, indicar cuál tiene foco por defecto con `(seleccionado)` después del nombre. | `Presenta alerta con botones 'Sí' y 'No (seleccionado)'` | No especificar cuál botón tiene foco |
| **Listas con viñetas en acciones** | Al listar varios valores para ingresar (acción tipo General-Compleja):<br/>1. Shift+Enter (nueva línea sin crear paso nuevo)<br/>2. Ingresar `-` + espacio<br/>3. Ingresar valor | `Ingresar valores en campos (PRECOND 2) y oprimir Enviar.`<br/>`- Primer Nombre`<br/>`- Apellido Paterno` | Lista en línea plana: `Ingresar Primer Nombre, Apellido Paterno` |
| **Listas con viñetas en resultados** | Al listar >2-3 elementos observables en resultado esperado, usar listas. Mismo formato: Shift+Enter + `-` + espacio | `Presenta los siguientes valores:`<br/>`- Información de valor 1`<br/>`- Información de valor 2` | Texto corrido: `Presenta: Información de valor 1, Información de valor 2` |

**Importante:** En ADO, las listas dentro de un paso se crean con Shift+Enter (nueva línea dentro del mismo step), **NO** con Enter normal (que crearía un step nuevo). Al usar la tool MCP, usar `<br/>` en el texto del action para representar Shift+Enter.

---

## 3. Nomenclatura del título (estándar empresa)

**Formato obligatorio:**
```
{Portal}-{Módulo}-{Pantalla}-{Funcionalidad} [{Escenario}]
```

**Reglas:**
- **Portal**: nombre del portal o aplicación bajo prueba
- **Módulo**: sección del menú principal
- **Pantalla**: nombre exacto como aparece en la UI
- **Funcionalidad**: qué se prueba específicamente
- **Escenario**: entre corchetes `[]`, describe la variante

**Ejemplos:**
```
MiPortal-Ventas-Gestión de Pedidos-Creación de Pedido [Happy Path]
MiPortal-Ventas-Gestión de Pedidos-Creación de Pedido [Datos inválidos]
MiPortal-Ventas-Gestión de Pedidos-Creación de Pedido [Cancelar]
```

---

## 3. Estructura de pasos — Sistema PRECOND

Todo TC debe comenzar con precondiciones. Las PRECONDs se numeran **secuencialmente desde 0** — el número indica la posición, no la categoría. Incluir **solo** las categorías que el TC necesita, en este orden:

| Categoría | Contenido | Cuándo incluir |
|-----------|-----------|----------------|
| Dependencias de TCs | TCs que deben ejecutarse antes para dejar el sistema en un estado dado | Si el TC depende de otro TC previo |
| Datos del sistema | Archivos, usuarios creados, datos precargados, configuraciones específicas | Si el TC requiere datos específicos |
| Info de usuario | Tipo de rol, escenario de permisos, condiciones del usuario | Si el escenario requiere especificar condiciones de usuario adicionales |
| **Login** | `Login<br/>- Usuario: X<br/>- Rol: Y<br/>- Acceso portal: Z<br/>- Acceso módulo: W` (usar `<br/>` entre campos — nunca línea plana) | **Siempre — pero su número = su posición en la secuencia** |

> ⚠️ **El número NO es fijo por categoría.** Es la posición en la lista de precondiciones del TC:
> - Solo login → `PRECOND 0: Login<br/>- Usuario: X<br/>- Rol: Y<br/>...`
> - Datos + login → `PRECOND 0: Datos [...]`, `PRECOND 1: Login<br/>- ...`
> - TC deps + datos + login → `PRECOND 0: TC deps [...]`, `PRECOND 1: Datos [...]`, `PRECOND 2: Login<br/>- ...`
>
> ⚠️ **Login siempre usa `<br/>` entre campos** — nunca `Login - Usuario: X - Rol: Y` en línea plana.

Después de los PRECONDs, continúan los **pasos de ejecución** numerados secuencialmente.

**Ejemplo — solo Login (único PRECOND):**
```
1. PRECOND 0: Login<br/>- Usuario: usuario01<br/>- Rol: ADMIN<br/>- Acceso portal: MiPortal<br/>- Acceso módulo: Ventas / Gestión de Pedidos|
2. Clic en el botón 'Crear Pedido'|Se presenta el formulario de creación con los campos Nombre, Cantidad y Fecha habilitados
3. Ingresar 'Producto A' en el campo Nombre|El campo muestra el texto 'Producto A' sin errores de validación
4. Clic en el botón 'Guardar'|Se presenta mensaje de éxito 'Pedido creado correctamente' y se redirige a la lista de pedidos
```

**Ejemplo — TC deps + Datos + Login (tres PRECONDs):**
```
1. PRECOND 0: TC-A (ID XXXX) ejecutado hasta el paso 10; el sistema muestra la pantalla de resultados|
2. PRECOND 1: Archivo Excel con 3 registros válidos cargado en la sesión activa|
3. PRECOND 2: Login<br/>- Usuario: usuario01<br/>- Rol: ADMIN<br/>- Acceso portal: MiPortal<br/>- Acceso módulo: Ventas / Gestión de Pedidos|
4. Clic en el botón 'Crear Pedido'|Se presenta el formulario de creación con los campos Nombre, Cantidad y Fecha habilitados
```

### 3.1 Niveles de detalle de las acciones

> **Fuente:** GUÍA-QA-Redacción de casos de pruebas v1.00 §4.3 (Tabla 5)

Al decidir si mantener una acción en un solo paso o dividirla en múltiples pasos, considerar los siguientes niveles:

| Nivel | Acciones detalladas | Resultados detallados | Cuándo usar | Ejemplo |
|-------|---------------------|----------------------|-------------|----------|
| **Resumido** | NO | NO | Navegación básica sin validaciones específicas requeridas por criterios | `Ingresar al portal Académico.` → `Presenta pantalla de inicio.` |
| **Compuesto** (General-Compleja) | NO (múltiples acciones agrupadas) | NO (resultado único del grupo) | Varias acciones en la misma pantalla forman parte del mismo paso lógico. Se agrupan con "y", "luego". Criterios no requieren validar cada acción por separado. | `Ir a módulo PEI y tarjeta 'Crear/Modificar PEI'. En búsqueda rápida ingresar SIE (PRECOND 1), oprimir Buscar y luego Seleccionar.` |
| **Separado** (Detallado) | SÍ | SÍ | Cada acción requiere verificar su propio resultado específico. Criterios de aceptación lo requieren explícitamente. | Paso 1: `Ingresar nombre en 'Primer Nombre'` → `Campo muestra el texto sin errores`<br/>Paso 2: `Ingresar apellido en 'Apellido Paterno'` → `Campo muestra el texto sin errores` |

**Regla de decisión:**
- Si los **criterios de aceptación** no detallan el resultado de cada acción intermedia → usar **Resumido o Compuesto**
- Si los **criterios de aceptación** requieren validar el resultado de cada acción → usar **Separado**
- Un mismo TC puede combinar niveles: pasos Resumidos/Compuestos para navegación + pasos Separados para el flujo crítico

### 3.2 Notación de letras, `PRECOND 0` "TC Ejecutado" y referencias inline

(Fuente: GUÍA-QA-Redacción de casos de pruebas v1.00, §3.3)

**Notación de letras:** cuando hay más de una PRECOND del mismo tipo en la misma posición de la
secuencia, agregar una letra mayúscula al número (`1A`, `1B`, `1C`...). Ejemplo real (TC 82981):
```
PRECOND 1A: Referido Admitido
PRECOND 1B: Referido Serv. Rel. Activo
PRECOND 2: Login<br/>- ...
```

**`PRECOND 0` para dependencias de TCs (formato "TC Ejecutado"):** cuando el TC depende de otro TC
ya ejecutado, usar este formato — una línea `- {ID}: {título del TC}` por dependencia, dentro del
mismo row vía Shift+Enter (ejemplo real, TC 83070):
```
PRECOND 0: TC Ejecutado
- 83057: Solicitud Horas Comp.: Validación Crear [Reg - Solicitud Ninguna / SI Crear]
```

**Referencias inline:** dentro del texto de un paso de ejecución, citar entre paréntesis la PRECOND
de la que provienen los datos usados en ese paso: `(PRECOND 2)`, `(PRECOND 1A)`, `(PRECOND 1 / 2)`.
Ejemplos reales:
- "Ingresar portal Finanzas (PRECOND 3)"
- "En búsqueda ingresar filtros (PRECOND 1A) y oprimir Buscar"

**Espaciado preciso en PRECONDs (formato oficial):**
El estándar oficial requiere **2 espacios** después de los dos puntos en una PRECOND:
- ✅ Correcto: `PRECOND 0:  Login` (2 espacios entre `:` y `Login`)
- ❌ Incorrecto: `PRECOND 0: Login` (1 espacio)

Este detalle asegura consistencia con los documentos oficiales de Quisit. Al generar TCs, aplicar
este formato automáticamente.

---

## 4. Reglas de calidad — OBLIGATORIO cumplir todas

### Hacer (obligatorio)

- **Flujo narrativo continuo por pantalla/funcionalidad** — todos los escenarios que ocurren en la misma pantalla/popup van en 1 solo TC secuencial, sin salir de ella
- **Dividir en TCs separados SOLO cuando** el flujo requiere cambiar de pantalla, de módulo, o cuando las precondiciones son incompatibles entre sí
- **Cada paso = 1 acción + 1 resultado esperado observable**
- **Resultados específicos**: qué texto aparece, qué elementos se habilitan/deshabilitan, qué cambia en pantalla
- **Español correcto** con tildes y ortografía impecable (á, é, í, ó, ú, ñ)
- **Nombrar elementos UI exactamente** como aparecen en pantalla (botones, campos, labels)
- **Formato de resultados esperados largos** — cuando el resultado esperado tiene múltiples elementos observables (>2), usar listas con viñetas (`-`) para mejorar legibilidad. Cada elemento observable en su propia línea. Ver §4.1.

### NO hacer (prohibido)

- ❌ `"Vuelve al paso X"` — no es observable, no sirve como resultado esperado
- ❌ Copiar/pegar criterios de aceptación como pasos del TC
- ❌ Pasos sin resultado esperado (excepto PRECONDs)
- ❌ Combinar varias acciones distintas en un solo paso cuando cada una tiene resultado esperado diferente
- ❌ Crear TCs separados para escenarios que ocurren en la misma pantalla/popup y comparten el mismo flujo de navegación
- ❌ Resultados vagos como "funciona correctamente" o "se actualiza la página"
- ❌ Usar comillas dobles `"` dentro del texto de pasos (causa problemas de escape XML/JSON) — preferir comillas simples o describir sin comillas

### 4.1 Formato de resultados esperados largos — legibilidad con listas

Cuando un resultado esperado incluye **2 o más elementos observables** (pantallas, mensajes, campos, estados), usar listas con viñetas (`-`) en lugar de texto corrido. Esto mejora la legibilidad y facilita la ejecución.

**❌ Mal (difícil de leer):**
```
El sistema abre una nueva pestaña del Portal Distribuidor con la sesión activa, mostrando nuevamente el Dashboard sin solicitar reautenticación (SSO funcionando correctamente).
```

**✅ Bien (legible con listas):**
```
- El sistema abre una nueva pestaña del Portal Distribuidor con la sesión activa
- Muestra nuevamente el Dashboard sin solicitar reautenticación (SSO funcionando correctamente)
```

**❌ Mal (bloque largo):**
```
Tras hacer clic en botón 'Iniciar Sesión', el sistema redirige a la página de inicio de Autoreg mostrando 'Inicio: Bienvenido'. En la barra superior se visualiza: Usuario (j.distribuidor), Rol (Distribuidor), Fecha actual, Balance, y botones 'Perfil de Seguridad' y 'Salida'. En el body se presenta la sección 'Datos y Documentos' con el botón 'Portal Distribuidor' visible.
```

**✅ Bien (estructura clara con listas anidadas):**
```
Tras hacer clic en 'Iniciar Sesión':
- El sistema redirige a la página de inicio de Autoreg
- Muestra 'Inicio: Bienvenido'
- En la barra superior se visualiza:
  - Usuario (j.distribuidor)
  - Rol (Distribuidor)
  - Fecha actual
  - Balance
  - Botones: 'Perfil de Seguridad', 'Salida'
- En el body se presenta la sección 'Datos y Documentos' con el botón 'Portal Distribuidor' visible
```

**Regla práctica:**
- **1 elemento observable** → texto corrido simple
- **2+ elementos observables** → lista con viñetas
- **Elementos agrupados** (ej. varios campos en una sección) → listas anidadas con indentación

---

### Niveles de detalle de las acciones (Tabla 5, GUÍA-QA-Redacción de casos de pruebas v1.00 §4.3)

| Nivel | Acciones detalladas | Resultados detallados | Pasos | Ejemplo |
|---|---|---|---|---|
| **Resumido** | No | No | 1 | "Ingresar al portal Académico." |
| **Compuesto** | No | No | 1 (multi-acción) | "Ir al módulo PEI y tarjeta 'Crear/Modificar PEI'. En búsqueda rápida ingresar SIE (PRECOND 1), oprimir Buscar y luego Seleccionar." |
| **Separado** | Sí | Sí, una por cada acción | 1 acción = 1 paso | Pasos separados: "Ingresar nombre", "Ingresar apellido paterno"... cada uno con su propio resultado |

> Elegir el nivel según cuánto detalle pida el requerimiento/criterio de aceptación. Un mismo TC
> puede combinar pasos Resumidos/Compuestos para navegación y pasos Separados para el flujo
> crítico que el criterio detalla.

### Resultados esperados — 7 aspectos (Tabla 6, GUÍA-QA-Redacción de casos de pruebas v1.00 §5.1)

Al redactar el resultado esperado de un paso, considerar estos aspectos (no todos aplican siempre):

| Aspecto | Qué describe | Ejemplo |
|---|---|---|
| Validación de datos | Mensajes de validación por campo | "El campo 'Fecha' muestra el mensaje 'Campo requerido' en rojo" |
| Mensaje de éxito o error | Texto literal entre comillas | "Se presenta el mensaje 'Pedido creado correctamente'" |
| Cambios en la interfaz de usuario | Elementos que aparecen/cambian, incluyendo la notación `botón (seleccionado)` para el botón resaltado/con foco en una alerta | "Se presenta alerta con los botones 'Sí' y 'No (seleccionado)'" |
| Seguridad | Mensajes de error de credenciales/permisos | "Se presenta el mensaje 'Usuario o contraseña incorrectos'" |
| Estado del sistema | Redirecciones, datos guardados, valores reflejados | "Se redirige a la lista de pedidos y el nuevo pedido aparece en la primera fila" |
| Interacción con otros sistemas | Envío de correo, sincronización externa | "Se envía un correo de confirmación a la dirección registrada" |
| Rendimiento | Tiempos de respuesta esperados | "La búsqueda retorna resultados en menos de 2 segundos" |

### Nivel de detalle del resultado (Tabla 7, GUÍA-QA-Redacción de casos de pruebas v1.00 §5.2)

| Nivel | Cuándo usar | Descripción | Ejemplo |
|---|---|---|---|
| **Resumen** | Los requerimientos/criterios NO lo piden explícitamente | Sin detalle del mensaje/alerta, solo el estado general | "Presenta pantalla de inicio" |
| **Detallado** | Los requerimientos/criterios SÍ lo requieren, o hay alertas/validaciones críticas | Mensaje completo + botón con foco, color del mensaje, texto literal entre comillas | "Presenta alerta con ícono de condición crítica en rojo, botón OK (seleccionado) y mensaje: 'Favor de ingresar todos los valores requeridos.'" |

**Regla de decisión:**
- Si el criterio de aceptación menciona el mensaje específico → usar **Detallado**
- Si el criterio solo dice "debe validar" sin especificar el texto → usar **Resumen**
- Para resultados de seguridad, validaciones críticas, o alertas con múltiples botones → siempre **Detallado**

---

### 4.3 Verbos estándar en acciones (referencia rápida)

> **Fuente:** GUÍA-QA-Redacción de casos de pruebas v1.00 §4.2

Usar verbos consistentes y precisos para describir acciones del usuario:

| Verbo | Cuándo usar | Ejemplo |
|-------|-------------|----------|
| **Ingresar** | Teclear texto en un campo | "Ingresar 'Juan Pérez' en el campo 'Nombre'" |
| **Seleccionar** | Elegir de dropdown, radio button, checkbox | "Seleccionar 'México' en el dropdown 'País'" |
| **Oprimir** / **Clic** | Hacer clic en botón o enlace | "Oprimir el botón 'Guardar'" / "Clic en el enlace 'Ver detalles'" |
| **Marcar** / **Desmarcar** | Checkbox específicamente | "Marcar el checkbox 'Acepto términos y condiciones'" |
| **Arrastrar** | Drag & drop | "Arrastrar el archivo desde el explorador al área de carga" |
| **Navegar a** / **Ir a** | Cambiar de pantalla/módulo | "Navegar a la pantalla 'Gestión de Usuarios'" |
| **Abrir** | Menú, modal, sección colapsable | "Abrir el menú 'Configuración'" |
| **Cerrar** | Modal, diálogo, ventana | "Cerrar el diálogo de confirmación" |
| **Cargar** / **Subir** | Upload de archivos | "Cargar el archivo 'documento.pdf'" |
| **Descargar** | Download de archivos | "Descargar el reporte en formato Excel" |
| **Expandir** / **Colapsar** | Secciones accordion | "Expandir la sección 'Datos Adicionales'" |
| **Editar** | Modificar un registro existente | "Editar el pedido con ID 12345" |
| **Eliminar** | Borrar un registro | "Eliminar el usuario 'test01' de la lista" |
| **Filtrar** / **Buscar** | Aplicar filtros o búsqueda | "Filtrar por estado 'Activo'" / "Buscar por nombre 'Juan'" |
| **Ordenar** | Cambiar orden de tabla/lista | "Ordenar por fecha de creación descendente" |

**Reglas de uso:**
- Mantener consistencia: si usas "Oprimir" para botones, no alternar con "Clic" en el mismo TC
- Ser específico: "Seleccionar 'Opción A'" es mejor que "Elegir una opción"
- Evitar verbos ambiguos como "acceder", "ejecutar", "realizar" — ser concreto

---

## 5. Procedimiento técnico en ADO (vía MCP)

### Paso A — Crear el TC (solo título)

```
mcp_ado_testplan_create_test_case(
  project = "<PROYECTO>",
  title   = "{Portal}-{Módulo}-{Pantalla}-{Funcionalidad} [{Escenario}]"
)
→ guardar el ID devuelto
```

> **IMPORTANTE:** NO pasar los steps en `create_test_case`. Si se pasan como array/string en la creación, se almacenan como JSON crudo en vez de XML válido de pasos de ADO. Los pasos SIEMPRE se cargan en un segundo llamado.

### Paso B — Cargar los pasos (separado, obligatorio)

```
mcp_ado_testplan_update_test_case_steps(
  id    = <ID del paso anterior>,
  steps = "1. acción|resultado esperado\n2. acción|resultado esperado\n..."
)
```

**Formato del string `steps`:**
- Cada paso: `N. texto de la acción|texto del resultado esperado`
- Separador entre pasos: `\n` (salto de línea real)
- Separador acción/resultado: `|` (pipe)
- PRECONDs sin resultado: dejar vacío después del `|` (ADO agrega texto genérico automáticamente)
- NO usar comillas dobles dentro del contenido de los pasos

### Paso C — Agregar al Test Suite (opcional)

```
mcp_ado_testplan_add_test_cases_to_suite(
  project      = "<PROYECTO>",
  planId       = <PLAN_ID>,
  suiteId      = <SUITE_ID>,
  testCaseIds  = [id1, id2, ...]
)
```

> Si falla con error 401/403 (permisos insuficientes), indicar al usuario que los agregue manualmente:
> **Test Plans → [Plan] → [Suite] → Add test cases → buscar IDs**

---

## 6. Tipos de Escenarios (clasificación oficial)

> **Fuente:** GUÍA-QA-Redacción de casos de pruebas v1.00 §6.1 (Tabla 8)

Al diseñar los Test Cases, clasificar los escenarios según estos 5 tipos:

| Tipo | Descripción | Ejemplos oficiales |
|------|-------------|-------------------|
| **Positivos** | Verifican funcionamiento correcto bajo condiciones esperadas | • Al ingresar valores requeridos y guardar, no presenta errores<br/>• Información almacenada exitosamente se presenta en búsquedas<br/>• Al subir archivo formato PDF correcto, no presenta error |
| **Negativos** | Evalúan cómo maneja entradas no válidas o condiciones inesperadas | • Al no ingresar valor en campo requerido → mensaje de error<br/>• En campo de teléfono al ingresar letras → mensaje de error<br/>• Al subir archivo no en formato adecuado → mensaje de error |
| **Usabilidad** | Evalúan facilidad de uso para usuarios finales | • Mascarilla en campo de teléfono: `(###) ###-####`<br/>• No presenta errores ortográficos o gramaticales<br/>• No presenta formatos de archivos no adecuados en selector |
| **Límite** | Prueban valores mínimos y máximos permitidos | • Al ingresar parcialmente números de teléfono → mensaje requiere 7 dígitos<br/>• Al subir archivo >5 MB → mensaje de error<br/>• Al subir archivo de 0 MB → mensaje de error |
| **Seguridad** | Examina resistencia a acceso no autorizado | • Intentar acceder sin credenciales → deniega acceso<br/>• Intentar acceder funcionalidad sin permisos → no se presenta |

**Cómo usar:**
- Al recibir una US, identificar qué tipos de escenarios requieren los criterios de aceptación
- Priorizar escenarios **Positivos** (happy path) siempre
- Agregar escenarios **Negativos** para validaciones críticas
- Incluir **Seguridad** si la funcionalidad tiene roles/permisos
- Considerar **Límite** para campos con restricciones numéricas o de tamaño
- Considerar **Usabilidad** para flujos complejos o formularios extensos

---

## 7. Criterios para Crear Múltiples TCs (decisión de división)

> **Fuente:** GUÍA-QA-Redacción de casos de pruebas v1.00 §6.2 (Tabla 9)

Al decidir si crear 1 TC o varios TCs para una funcionalidad, aplicar estos 6 criterios:

| # | Criterio | ¿Cuándo dividir en TCs separados? | Ejemplo |
|---|----------|----------------------------------|----------|
| **A** | **Número de precondiciones** | Si hay >3-4 PRECONDs, o si hay PRECONDs incompatibles entre sí (ej. usuario con permiso vs sin permiso) | TC-A: Con permiso de edición<br/>TC-B: Sin permiso de edición |
| **B** | **Número de pasos de ejecución** | Si el flujo completo requiere >15-20 pasos, dividir en TCs lógicos | TC-A: Crear registro (pasos 1-10)<br/>TC-B: Editar registro (pasos 1-8, usa PRECOND 0: TC-A) |
| **C** | **Cambio de módulo/pantalla principal** | Si la funcionalidad navega a otro módulo o portal, crear TC separado | TC-A: Portal Ventas → Crear pedido<br/>TC-B: Portal Inventario → Consultar stock |
| **D** | **Tipo de escenario** | Escenarios **Positivos** vs **Negativos** pueden ir en el mismo TC si comparten flujo. **Seguridad** y **Límite** suelen requerir TCs separados. | TC-A: Crear pedido [Happy Path + Validaciones]<br/>TC-B: Crear pedido [Sin permisos] |
| **E** | **Complejidad de resultados esperados** | Si cada escenario tiene >3 resultados complejos/detallados, considerar TC separado | TC-A: Validaciones de campos (paso 3: valida Nombre, paso 4: valida Email, paso 5: valida Teléfono)<br/>TC-B: Validaciones de fechas |
| **F** | **Dependencias entre escenarios** | Si un escenario DEBE ejecutarse después de otro, usar `PRECOND 0: TC Ejecutado`. Si son independientes, TCs separados. | TC-A: Registro de usuario<br/>TC-B (depende de TC-A): Login con usuario registrado |

**Regla general:**
- **AGRUPAR** cuando los escenarios:
  - Comparten el mismo flujo de navegación
  - Ocurren en la misma pantalla/popup
  - Tienen precondiciones compatibles
  - Juntos suman <15 pasos

- **DIVIDIR** cuando:
  - Cambian de módulo/portal
  - Tienen precondiciones incompatibles (ej. roles diferentes)
  - El TC resultante supera 20 pasos
  - Los criterios de aceptación los separan explícitamente

---

## 8. Escenarios típicos a cubrir (referencia rápida)

Para cualquier funcionalidad, considerar al menos estos escenarios:

| Categoría | Escenario sugerido | Ejemplo de título |
|-----------|--------------------|-------------------|
| Éxito | Flujo completo exitoso | `[Happy Path]` |
| Validación | Datos inválidos o formato incorrecto | `[Datos inválidos]` |
| Cancelación | Cancelar en medio del proceso | `[Cancelar]` |
| Navegación | Volver atrás conservando datos | `[Volver al paso anterior]` |
| Eliminación | Quitar un ítem de una lista | `[Eliminar elemento]` |
| Incompleto | Proceso con datos parciales | `[Registros incompletos]` |
| Omisión | Finalizar sin completar opcional | `[Sin campo opcional]` |
| Reanudación | Retomar proceso interrumpido | `[Reanudación automática]` |
| Duplicado | Intentar crear registro existente | `[Registro duplicado]` |
| Vacío | Sin resultados o lista vacía | `[Sin resultados]` |
| Permisos | Usuario sin permisos suficientes | `[Sin permisos]` |
| Límites | Valores máximos/mínimos | `[Valor límite]` |

> No todos aplican siempre. Seleccionar los relevantes según la funcionalidad.

---

## 9. Flujo de trabajo completo

```
1. Recolectar contexto (sección 1)
   ↓
2. Identificar escenarios a cubrir (sección 6)
   ↓
3. Para cada escenario:
   a. Redactar título con nomenclatura (sección 2)
   b. Redactar pasos con PRECONDs (secciones 3-4)
   c. Verificar resultados observables
   ↓
4. Presentar resumen al usuario para aprobación
   ↓
5. Crear TCs en ADO (sección 5, pasos A→B→C)
   ↓
6. Reportar IDs creados y estado final
```

### Presentar resumen antes de crear

Antes de ejecutar llamadas a ADO, mostrar al usuario una tabla con:
- Letra/código del TC (TC-A, TC-B, etc.)
- Título completo
- Cantidad de pasos
- Escenarios cubiertos

Esperar confirmación ("dale", "sí", "ok") antes de crear en ADO.

---

## 10. Ejemplo completo de TC bien escrito

**Título:** `MiPortal-Ventas-Gestión Pedidos-Creación de Pedido [Cancelar a mitad del proceso]`

**Pasos:**
```
1. PRECOND 0: Login<br/>- Usuario: admin01<br/>- Rol: VENDEDOR<br/>- Acceso portal: MiPortal<br/>- Acceso módulo: Ventas / Gestión de Pedidos|
2. Clic en el botón 'Crear Pedido'|Se presenta el formulario de creación de pedido con:<br/>- Campos: Nombre, Cantidad, Fecha<br/>- Botones: 'Guardar' / 'Cancelar'
3. Ingresar 'Producto de Prueba' en el campo 'Nombre'|El campo muestra el texto ingresado sin errores de validación
4. Ingresar '5' en el campo 'Cantidad'|El campo muestra '5' y no presenta alertas
5. Clic en el botón 'Cancelar'|Se presenta diálogo de confirmación con:<br/>- Texto: 'Tiene cambios sin guardar. ¿Desea cancelar?'<br/>- Botones: 'Sí' / 'No'
6. Clic en el botón 'Sí'|Se presenta el estado final con:<br/>- Diálogo: cerrado<br/>- Pantalla: lista de pedidos<br/>- Pedido creado: NO aparece en la lista
```

---

## 10.2 Ejemplos adicionales de TCs (casos avanzados)

### Ejemplo A: TC con dependencia (`PRECOND 0: TC Ejecutado`)

**Título:** `Autoreg-Gestión Usuarios-Login-Autenticación [Usuario previamente registrado]`

**Contexto:** Este TC depende de que el TC anterior (registro de usuario) se haya ejecutado exitosamente.

**Pasos:**
```
1. PRECOND 0:  TC Ejecutado<br/>- 12345: Autoreg-Gestión Usuarios-Registro-Crear usuario [Happy Path]|
2. PRECOND 1:  Usuario registrado en PRECOND 0|
3. Navegar a la pantalla de Login de Autoreg|Presenta pantalla de Login con:<br/>- Campo 'Usuario'<br/>- Campo 'Contraseña'<br/>- Botón 'Iniciar Sesión'
4. Ingresar credenciales del usuario (PRECOND 1)|Campos muestran los valores ingresados sin errores
5. Oprimir el botón 'Iniciar Sesión'|Se presenta el estado final con:<br/>- Redirección a Dashboard de Autoreg<br/>- Barra superior muestra: Usuario (nombre del PRECOND 1), Rol (Distribuidor)<br/>- Menú lateral visible con opciones del rol
```

### Ejemplo B: TC con múltiples PRECONDs del mismo tipo (notación de letras)

**Título:** `MiPortal-Ventas-Comparación Productos-Comparar [Dos productos diferentes]`

**Pasos:**
```
1. PRECOND 0:  Login<br/>- Usuario: vendedor01<br/>- Rol: VENDEDOR<br/>- Acceso portal: MiPortal<br/>- Acceso módulo: Ventas|
2. PRECOND 1A:  Producto A existente<br/>- ID: PROD-001<br/>- Nombre: Laptop Dell<br/>- Precio: $1200|
3. PRECOND 1B:  Producto B existente<br/>- ID: PROD-002<br/>- Nombre: Laptop HP<br/>- Precio: $1100|
4. Ir al módulo Ventas y tarjeta 'Comparación de Productos'|Presenta pantalla de comparación con:<br/>- Campo de búsqueda 'Producto 1'<br/>- Campo de búsqueda 'Producto 2'<br/>- Botón 'Comparar'
5. En 'Producto 1' ingresar ID (PRECOND 1A) y seleccionar|Campo muestra: PROD-001 - Laptop Dell
6. En 'Producto 2' ingresar ID (PRECOND 1B) y seleccionar|Campo muestra: PROD-002 - Laptop HP
7. Oprimir el botón 'Comparar'|Se presenta tabla comparativa con:<br/>- Columna 1: Laptop Dell - $1200<br/>- Columna 2: Laptop HP - $1100<br/>- Filas: Características, Precio, Disponibilidad
```

### Ejemplo C: TC de tipo Límite (validación de tamaño de archivo)

**Título:** `PortalDoc-Documentos-Subir Archivo-Validación [Tamaño excede límite]`

**Pasos:**
```
1. PRECOND 0:  Login<br/>- Usuario: admin01<br/>- Rol: ADMINISTRADOR<br/>- Acceso portal: PortalDoc|
2. PRECOND 1:  Archivo de prueba preparado<br/>- Nombre: reporte_grande.pdf<br/>- Tamaño: 12 MB (excede límite de 5 MB)|
3. Navegar al módulo Documentos y oprimir 'Subir Archivo'|Presenta modal de carga con:<br/>- Área de arrastre de archivos<br/>- Botón 'Seleccionar archivo'<br/>- Texto: 'Tamaño máximo: 5 MB'
4. Arrastrar el archivo (PRECOND 1) al área de carga|Se presenta mensaje de validación en rojo:<br/>"El archivo excede el tamaño máximo permitido (5 MB). Tamaño actual: 12 MB."
5. Intentar oprimir el botón 'Subir'|Botón 'Subir' permanece deshabilitado (gris). No se ejecuta la carga.
```

### Ejemplo D: TC de tipo Seguridad (acceso denegado por permisos)

**Título:** `Autoreg-Admin-Gestión Roles-Eliminar Rol [Sin permisos]`

**Pasos:**
```
1. PRECOND 0:  Login<br/>- Usuario: user_readonly<br/>- Rol: CONSULTOR (sin permisos de escritura)<br/>- Acceso portal: Autoreg|
2. PRECOND 1:  Rol existente en el sistema<br/>- ID: ROL-005<br/>- Nombre: Vendedor Junior|
3. Navegar al módulo Admin, sección 'Gestión de Roles'|Presenta lista de roles con:<br/>- Rol 'Vendedor Junior' visible en la tabla<br/>- Botón 'Eliminar' NO visible (permiso denegado)
4. Intentar acceder directamente a la URL de eliminación: `/admin/roles/delete/ROL-005`|Se presenta alerta de seguridad con:<br/>- Ícono de error en rojo<br/>- Mensaje: "Acceso denegado. No tiene permisos para realizar esta acción."<br/>- Botón 'Aceptar (seleccionado)'<br/>- Redirección automática a lista de roles (no ejecuta eliminación)
```

---

## Notas técnicas

- Los TCs se crean con estado `Design` por defecto
- El campo `steps` en ADO usa formato XML interno (`<steps>` con `<step>` tags)
- La tool `update_test_case_steps` convierte el formato `N. acción|resultado` a XML automáticamente
- Si un PRECOND no tiene resultado esperado, ADO agrega "Verify step completes successfully" — esto es aceptable para precondiciones
- **Espaciado oficial:** 2 espacios después de `:` en PRECONDs (ej. `PRECOND 0:  Login`)
