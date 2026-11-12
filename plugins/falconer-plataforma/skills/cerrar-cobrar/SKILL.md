---
description: Acompaña el cierre de una búsqueda hasta el cobro: oferta e ingreso del candidato, garantía, borrador de factura y recordatorio de reclamar el pago. Usar cuando dicen "cerrá esta búsqueda", "ofertale a X", "ingresó la candidata", "colocación", "facturá", "¿qué me falta cobrar?" o "¿cuántos cerré este mes?".
---
# Cerrar y cobrar

El objetivo del equipo es la cantidad de procesos cerrados por mes. Vos acompañás cada paso; **los montos, el motivo del cierre y el envío de cada reclamo los decide la persona**.

## Qué podés hacer hoy
1. **Qué falta.** `hunting__get_search_next_step` dice en qué paso está la búsqueda y qué le falta para cerrarse. Una búsqueda dura aproximadamente un mes: avisá si pasa de ~30 días.
2. **Estado de ofertas e ingresos.** `placements__list_placements` y `placements__get_placement` muestran cada oferta o ingreso con su estado y su garantía.
3. **Cómo vamos.** `metrics__get_closures` muestra los procesos cerrados por mes, `metrics__get_funnel` el embudo y `metrics__get_board` el tablero contra la meta. Informá los números tal cual, sin proyecciones inventadas. Nunca evalúes a una reclutadora, no la compares con otra ni recomiendes medidas laborales (premios, avisos, cambios de puesto): el tablero es para ver cómo viene el equipo.
4. **Oferta.** Pedile a la persona sueldo, **moneda** (ISO 4217), honorario y días de garantía; nunca los estimes ni conviertas monedas. `placements__offer_for_application` (o `placements__create_placement`) sale como **tarjeta de aprobación**, con los montos en `amount_minor`; `placements__preview_offer`, `placements__update_offer` y `placements__accept_offer` completan el paso. **Antes de pedirla, leé [`referencia.md`](referencia.md)** (§ 4).
5. **Ingreso.** El ingreso se registra el día que pasa (no se acepta una fecha futura). Cuando la persona cuenta que la candidata ingresó, `placements__start_placement` (tarjeta) registra el ingreso: devenga el honorario y empieza a correr la garantía (un cierre de prueba deja además el borrador).
6. **Factura.** Pasados **15 días del ingreso** (con datos de prueba, desde el día del ingreso), `billing__preview_invoice` dice si se puede y `billing__create_invoice` (tarjeta, owner y admin) crea el **borrador**: no se emite ni se manda nada. Mostrale la vista previa y pedí la tarjeta sólo con un sí explícito. El correo de la factura y el comprobante, en [`referencia.md`](referencia.md) (§ 6).
6 bis. **Editar, acreditar y anular.** Todas, tarjeta con segundo factor: `billing__update_invoice` (un borrador), `billing__issue_credit_note`, `billing__set_billing_contact`, `billing__register_refund` y `billing__void_invoice` (sólo un borrador); `billing__request_invoice_pdf` imprime el PDF de una emitida y ella lo baja de la factura. **Antes de pedir cualquiera, leé [`referencia.md`](referencia.md)** (§ 6 bis): qué se manda y qué nunca.
7. **Cobro.** Cualquiera de las dos socias cobra y se reclama el pago **cada dos días**. Cuando la persona cuenta que se cobró (la factura ya tiene que estar **emitida**: una real la emite ella en la app; una de prueba, `billing__issue_test_invoice`), antes, `billing__check_payment` dice si se aceptaría (factura emitida, en su moneda, sin pasar el saldo, fecha entre la emisión y hoy) o por qué no, con el campo; después `billing__register_payment` (tarjeta) registra el cobro parcial o total en la moneda de la factura. Recordale cuáles toca reclamar y ofrecé redactar el texto del reclamo, que ella envía. Con `agent_billing_mail` prendido, `billing__send_payment_reminder` lo pide como tarjeta con segundo factor (el texto aprobado y el destinatario los pone el servidor; uno cada 7 días como máximo); apagado, es de ella.

7b. **Qué hay para cobrar.** `billing__list_invoices` (filtrable por estado), `billing__list_overdue_invoices` (emitidas vencidas, la más vieja primero) y `billing__next_invoice_to_claim` (la siguiente vencida con saldo a la que ya se puede reclamar). Decile a la persona cuál toca y ofrecé redactar el reclamo; lo decide ella. `billing__get_summary` da los totales por mes y por moneda, **sin convertir**; `billing__get_settings` la configuración (condición fiscal, plazo de pago, cada cuánto se reclama); `billing__list_credit_notes` las notas de una factura y `billing__get_invoice_email_sender` con qué nombre saldría el correo.
7 bis. **Rutina de cobro del día.** `billing__list_claims_today` dice qué reclamar hoy (historial, tono sugerido, tope); cada reclamo es `billing__send_payment_reminder`, **de a uno**, y lo de `stopped` no se reclama por correo. `billing__get_dso` da la línea de base. **Leé [`referencia.md`](referencia.md)** (§ 7 bis).

8. **Rechazo o salida.** Si la candidata rechazó la oferta, `placements__decline_offer` (tarjeta; no se deshace). Si quien ingresó se fue, `placements__record_leave` con `left_on` (no futuro): la aprueba ella con segundo factor; dentro de la garantía se debe un reemplazo (`placements__offer_for_application` con `replaces_placement_id`) y el honorario no se factura. **Nunca mandes motivo** (422 `free_text_not_allowed`; ni en la justificación del pedido): lo escribe ella en la app. Las dos piden que la owner haya prendido «lo irreversible y las decisiones sobre personas» (`person_decisions_disabled`); `offer_not_open`, `placement_not_started`, `left_in_future` y `left_before_start` dan 409 sin pendiente.

## Cerrar las postulaciones y la búsqueda
`hunting__close_application` cierra una postulación (con OK o con rechazo) y `hunting__change_status` cambia el estado de la búsqueda (activar, pausar o cerrar para siempre): **tarjeta de aprobación**; la decisión y el motivo son de la persona. Proponele el motivo según lo que te contó, pero no cierres sin su aprobación. A quien no sigue, la devolución se prepara con `contactar-seguimiento`, sin mencionar a otros candidatos.

## «Baja» son tres cosas distintas
- **Baja de una postulación** («se cayó», «dalo de baja de esta búsqueda»): `hunting__close_application`. Sale de esa búsqueda y **nada más**: la persona sigue en la plataforma y se le puede seguir escribiendo.
- **Bloquear el contacto** (`do_not_contact`, «no contactar»): bloquea a la persona, borra su evidencia de macheo, sugerencias, etiquetas y listas, y cierra **todas** sus postulaciones. **No se deshace** y **no lo podés pedir** (422 `do_not_contact_app_only`): lo decide ella en la app. Si alguien dice «que no le escriban más», decile que eso se hace en la app.
- **El enlace de baja del correo** lo usa quien recibe el mensaje; no es una herramienta tuya. Y **borrar a una persona** (supresión de datos) es de ella en la app.

## Lo que decide la persona
Sueldo, moneda, honorario y garantía; aprobar cada tarjeta (oferta, ingreso, cobro, cierre); el motivo de cada cierre; emitir una factura real; la nota de crédito y sus motivos; mandar la factura real y cada reclamo de cobro (cada uno, una tarjeta con su segundo factor).

## Reglas
- Monedas con su código (ISO 4217) y fechas con su huso.
- Si una herramienta da 403 o 409, informalo y no busques otro camino.

**Propuesta que no salió.** `proposals__retry_version_email` (tarjeta con segundo factor) manda el **mismo** correo de una versión con `email_status = failed`, sin texto nuevo; probalo con `proposals__preview_version_retry`. Una propuesta real sólo si el operador prendió `agent_proposal_mail` (si no, 409 `proposal_not_test`); pasados 7 días, `email_too_old`.
