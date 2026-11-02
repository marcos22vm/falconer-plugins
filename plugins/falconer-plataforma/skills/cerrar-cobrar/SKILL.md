---
description: Acompaña el cierre de una búsqueda hasta el cobro: oferta e ingreso del candidato, garantía, borrador de factura y recordatorio de reclamar el pago. Usar cuando dicen "cerrá esta búsqueda", "ofertale a X", "ingresó la candidata", "colocación", "facturá", "¿qué me falta cobrar?" o "¿cuántos cerré este mes?".
---
# Cerrar y cobrar

El objetivo del equipo es la cantidad de procesos cerrados por mes. Vos acompañás cada paso; **los montos, el motivo del cierre y el envío de cada reclamo los decide la persona**.

## Qué podés hacer hoy
1. **Qué falta.** `hunting__get_search_next_step` dice en qué paso está la búsqueda y qué le falta para cerrarse. Una búsqueda dura aproximadamente un mes: avisá si pasa de ~30 días.
2. **Estado de ofertas e ingresos.** `placements__list_placements` y `placements__get_placement` muestran cada oferta o ingreso con su estado y su garantía.
3. **Cómo vamos.** `metrics__get_closures` muestra los procesos cerrados por mes, `metrics__get_funnel` el embudo y `metrics__get_board` el tablero. Informá los números tal cual, sin proyecciones inventadas.
4. **Oferta.** Pedile a la persona el sueldo y su **moneda** (ISO 4217), el honorario y los **días de garantía** (lo normal son 30; es configurable). Nunca los estimes ni conviertas monedas por tu cuenta. Con esos datos, `placements__create_placement` registra la oferta: sale como **tarjeta de aprobación** y la aprueba ella. Que el candidato aceptó la oferta lo registra `placements__accept_offer` (tarjeta, con la fecha de inicio que ella diga).
5. **Ingreso.** Cuando la persona cuenta que la candidata ingresó, `placements__start_placement` (tarjeta) registra el ingreso: devenga el honorario, arma el borrador de factura y empieza a correr la garantía.
6. **Cobro.** Cualquiera de las dos socias cobra y se reclama el pago **cada dos días**. Cuando la persona cuenta que se cobró, `billing__register_payment` (tarjeta) registra el cobro parcial o total en la moneda de la factura. Recordale cuáles toca reclamar y ofrecé redactar el texto del reclamo, que ella envía.

## Cerrar las postulaciones y la búsqueda
`hunting__close_application` cierra una postulación (con OK o con rechazo) y `hunting__change_status` cambia el estado de la búsqueda (activar, pausar o cerrar para siempre): ambas salen como **tarjeta de aprobación** y la decisión y el motivo son de la persona. Proponele el motivo que corresponde según lo que te contó, pero no la cierres sin su aprobación. A quien no sigue, la devolución se prepara con `contactar-seguimiento` y la aprueba ella, sin mencionar a otros candidatos.

## Se activa cuando la plataforma lo habilite para tu Claude
Estas acciones existen en la plataforma, pero todavía no las puede pedir un Claude conectado (están en el BACKLOG). Mientras tanto la persona las registra en la app, y vos le preparás los datos y le decís dónde:
- Corregir una oferta pendiente o registrar que el candidato la rechazó: `placements__update_offer`, `placements__decline_offer`; pasar la postulación a Oferta en un solo paso: `placements__offer_for_application`.
- Salida de la persona: `placements__record_leave` (dentro de la garantía se debe un reemplazo).
- Factura: `billing__create_invoice` crea el **borrador**; emitirla es de la persona.

## Lo que decide la persona
Sueldo, moneda, honorario y garantía; aprobar cada tarjeta (oferta, ingreso, cobro, cierre); el motivo de cada cierre; emitir la factura; enviar cada reclamo de cobro.

## Reglas
- Monedas con su código (ISO 4217) y fechas con su huso.
- Si una herramienta da 403 o 409, informalo y no busques otro camino.
