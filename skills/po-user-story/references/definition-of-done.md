# Definition of Done (DoD) de Quisit

> **Fuente:** GUÍA-QA-Historias de usuarios-Definition of Done v1.00

---

## ¿Qué es la Definition of Done?

La **Definition of Done (DoD)** en Scrum es un conjunto de criterios que deben cumplirse para que un incremento de producto se considere completo. Estos criterios aseguran que el trabajo realizado es de alta calidad y está listo para ser entregado. La DoD, al ser acordada por el equipo de desarrollo, garantiza la transparencia y coherencia en el proceso de entrega.

---

## Definition of Done de Quisit

Los siguientes 7 criterios son obligatorios para considerar una User Story como **"Done"**:

### 1. Código cumple con los estándares de programación [DEV]
El código fuente cumple con las convenciones, patrones y mejores prácticas definidas en el manual de estándares de programación del equipo.

**Responsable:** DEV  
**Referencia:** Ver en Intranet Portal: `Manual Estándares Programación.pdf`

### 2. Criterios funcionales realizados y aprobados [DEV]
Todos los criterios funcionales UI (dropdowns, date pickers, validaciones de campos, formatos, etc.) definidos en la guía oficial han sido implementados y verificados.

**Responsable:** DEV  
**Referencia:** `GUÍA-QA-Historias de usuarios-Criterios funcionales.pdf` (en este template: `references/criterios-funcionales-ui.md`)

### 3. Unit Testing (pruebas unitarias) realizadas y aprobadas [DEV]
Las pruebas unitarias del código desarrollado han sido escritas, ejecutadas y todas pasan exitosamente. Cobertura mínima de código según estándares del equipo.

**Responsable:** DEV

### 4. Code Review (revisión de código) realizado y aprobado [TL]
El código ha sido revisado por el Team Lead u otro desarrollador senior, se han resuelto todos los comentarios críticos, y el PR ha sido aprobado formalmente.

**Responsable:** TL (Team Lead)

### 5. Quality Assurance (QA) realizado y aprobado [QAA]
El QA Analista ha ejecutado el Test Plan o las pruebas manuales correspondientes, todos los Test Cases han pasado (estado `Passed`), y la historia cumple con los criterios de aceptación.

**Responsable:** QAA (QA Analista)  
**Referencia:** `PROC-QA-Generales de calidad.pdf` (en este template: `../../qa_tester/SKILL.md`)

### 6. Desviaciones de QA resueltas y aprobadas [QAA]
Todos los bugs y desviaciones encontrados durante la ejecución de QA han sido corregidos y re-validados. No quedan bugs abiertos bloqueantes asociados a la historia.

**Responsable:** QAA  
**Referencia:** `PROC-QA-Generales de calidad.pdf`

### 7. Requerimientos y funcionalidades realizadas y aprobadas [PO]
El Product Owner ha revisado la funcionalidad implementada en Demo, confirma que cumple con los requerimientos del negocio, y aprueba formalmente la historia (campo `ApprovedProductOwner = True` en Azure DevOps).

**Responsable:** PO (Product Owner)

---

## Verificación de DoD en el Template

### Checklist al cerrar US (`qa_tester`)
Antes de cerrar una historia (cambiar estado a `Closed`), el QA Analista debe verificar que:

```
□ Punto 5 (QA): Test Plan ejecutado y Passed, o Pruebas manuales completadas
□ Punto 6 (Desviaciones): Todos los bugs asociados están en estado Closed o Resolved
□ Punto 7 (Aprobación PO): Campo ApprovedProductOwner = True (confirmado en Demo)
□ Campo Custom.TestPlanCompleted = True
□ Documentación de resultados registrada en comentario de la historia
```

> Para QA, los ítems 5 y 6 se cumplen cuando la US pasa a `Closed` con comentario `QA PASSED` (ver
> `agents/QA-PRO.agent.md` §5 "Documentación de US post-ejecución").

### Roles y Responsabilidades

| Rol | Puntos DoD | Actividades |
|-----|------------|-------------|
| **DEV** | 1, 2, 3 | Escribir código según estándares, implementar criterios funcionales UI, escribir unit tests |
| **TL** | 4 | Revisar código, aprobar PRs, validar cumplimiento de estándares |
| **QAA** | 5, 6 | Ejecutar test plans/pruebas, reportar desviaciones, re-validar correcciones |
| **PO** | 7 | Revisar funcionalidad en Demo, aprobar historias, validar valor de negocio |

---

## Anti-Patrones (No hacer)

❌ Cerrar una historia sin que todos los puntos DoD estén completos  
❌ Saltarse unit tests "porque no hay tiempo"  
❌ Marcar historia como Done sin aprobación formal del PO  
❌ Dejar bugs abiertos asociados a la historia  
❌ No documentar resultados de QA en la historia
