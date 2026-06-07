# Contexto de Proyecto — Motorambar / Autoreg

> ⚠️ **ESTE ARCHIVO SE LEE AUTOMÁTICAMENTE.** Contiene el dominio del proyecto.
> El agente DEBE conocer todo esto antes de crear TCs, USs o ejecutar pruebas.

---

## Portales y URLs

| Portal | URL | Descripción |
|--------|-----|-------------|
| **Autoreg** | `https://testwaf.portaldevehiculos.com` | Portal del distribuidor (origen). Aquí hacen login los distribuidores. |
| **Motorambar** | (abre desde Autoreg vía botón Portal Distribuidor) | Portal interno de gestión vehicular. Destino del login federado. |

---

## Login — Flujos Conocidos

### Login estándar en Autoreg
- Pantalla: campos **Usuario** y **Contraseña** + botón **Iniciar Sesión**
- Tras login exitoso: dashboard de Autoreg visible
- Modal **Términos y Condiciones** puede aparecer en primera sesión del día: tiene **4 checkboxes** + botón **Continuar**

### Login Federado Autoreg → Motorambar
- Sección en dashboard Autoreg: **Datos y Documentos**
- Botón: **Portal Distribuidor** (solo visible si el rol del usuario tiene permiso)
- Al hacer clic: abre **nueva pestaña** del navegador con Motorambar
- Motorambar muestra layout **VehicleDocs** con menú **Vehículos importados**

---

## Roles y Permisos

| Condición | Resultado visible |
|-----------|------------------|
| Usuario con permiso para Portal Distribuidor | Botón **Portal Distribuidor** visible y habilitado en Autoreg |
| Usuario SIN permiso para Portal Distribuidor | Botón **NO aparece** en Autoreg |

---

## Módulos Principales (Motorambar)

- **Vehículos importados** — gestión de VINs, estados de importación
- **Preventas** — proceso de preventa de vehículos
- **Ventas** — gestión de órdenes de venta

---

## Organización ADO

- **Organización:** `AutoregPR`
- **Proyecto:** `Motorambar`
- **Usuario QA:** `jmartinez@portaldevehiculos.com`

---

## Terminología Literal (NO cambiar nombres)

| Término en sistema | Descripción |
|--------------------|-------------|
| `Portal Distribuidor` | Botón exacto en Autoreg para ir a Motorambar |
| `Datos y Documentos` | Sección del dashboard de Autoreg donde aparece el botón |
| `VehicleDocs` | Nombre del layout interno de Motorambar |
| `VIN` | Vehicle Identification Number — identificador único del vehículo |
| `MANUFACTURER` | Rol de fabricante en Motorambar |
| `Iniciar Sesión` | Texto del botón de login en Autoreg |
| `Continuar` | Botón para aceptar T&C en modal |

---

## Tecnología Frontend

- **Autoreg:** ASP.NET WebForms con componentes Telerik
- **Motorambar:** Next.js 16 + React 19
