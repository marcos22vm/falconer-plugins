---
description: Guía de lectura y ajuste de las búsquedas: dónde está cada una, qué le falta, el tablero, las postulaciones quietas, la calibración, el cliente y los términos de LinkedIn. Usar cuando dicen "¿cómo va la búsqueda N?", "¿cuál sigo?", "¿qué postulaciones están quietas?", "¿quién rechazó el cliente?", "cambiá el rango de sueldo" o "¿qué términos usamos en LinkedIn?".
---
# Búsquedas: dónde están y qué sigue

Casi todo es lectura: informá el estado y proponé; **la persona decide qué se cambia**. Las que escriben son reversibles (se pueden volver a guardar) o salen como tarjeta.

## Ver
1. **Una búsqueda.** `hunting__get_search` (título, cliente, estado, responsable, fechas), `hunting__get_search_extras` (país, requisitos en texto, números de contactados, respondieron, entrevistas, presentados) y `hunting__get_search_parties` (cliente final e intermediarios). `hunting__count_searches` cuenta por estado (con `mine`, sólo las de la persona).
2. **Tablero.** `hunting__get_search_board` (todas las abiertas) y `hunting__get_search_board_one` (una): una fila por candidatura con sus casilleros por etapa. `hunting__get_application` dice de qué búsqueda y persona es una postulación, y su etapa. `hunting__get_search_signals` marca cuáles están «a entrevistar».
3. **«Hoy».** `hunting__get_today_sections` trae la pantalla entera; `hunting__get_monthly_closures` es la versión vieja del cierre mensual (para el número actual, `metrics__get_closures`).
4. **Qué sigue.** `hunting__next_search_to_advance` trae la siguiente búsqueda abierta con lo que le falta para cerrarse y la acción sugerida; `hunting__next_search_to_close` la siguiente con un paso de plata pendiente (oferta, respuesta a la oferta, ingreso, factura). Una búsqueda dura aproximadamente un mes: avisá si pasa de ~30 días.
5. **Pipeline largo.** `hunting__list_pipeline` trae hasta 50 por página y un `next_cursor`: para seguir, la misma herramienta con `cursor` = ese `next_cursor`, tal cual (es opaco, vence a los 30 minutos y sólo sirve para esa búsqueda; si no, 422 `invalid_cursor` y se vuelve a la primera). Parás cuando `next_cursor` es `null` o ya tenés lo que pidió la persona. Con un 429 de tope de lectura, la persona puede seguir confirmando con su segundo factor en la app (`confirm_url`; si la conexión no está frenada, 409 `not_paused`): no se lo pidas por el chat.

## Postulaciones quietas
5. `hunting__get_stale_after` dice a los cuántos días sin mirar una postulación entra en «¿Siguen bien?» (`hunting__set_stale_after` lo cambia para toda la consultora; que lo diga la persona). `hunting__next_stale_application` trae la siguiente y `hunting__confirm_batch` confirma «sigue bien» (tarjeta, de a una o hasta 25 en una lista de ids, después de preguntarle a la persona). `hunting__get_no_response_hours` dice cuántas horas hábiles se espera una respuesta.
6. **Reabrir.** `hunting__reactivate_application` reabre una postulación cerrada por sin respuesta, no encaja o el cliente (tarjeta). Una que cerró la candidata («no me interesa») la reabre sólo la persona.

## Corregir una búsqueda
7. `hunting__edit_search` corrige título, cliente, responsable o los textos de la JD; `hunting__edit_jd_draft` escribe una versión de la JD (corta o extendida, en un idioma) en borrador. `hunting__set_search_extras` guarda país, rango de sueldo (mes, año u hora; `share_in_first_contact` sólo si el cliente autorizó decirlo en el primer mensaje), horario (`schedule`: días, inicio, fin y huso IANA, completo o no se manda) y honorario, **mandando sólo lo que cambia** (lo que no mandás queda como estaba; un `null` explícito lo borra); `hunting__set_search_parties` define el cliente final y los intermediarios (reemplaza lo anterior); `hunting__set_search_presentation_items` reemplaza los requisitos de presentación del cliente. Mostrá el valor actual y el nuevo, y pedí el cambio con el sí de la persona. `hunting__set_active_search` marca en cuál está trabajando.
8. **Nombre del cliente.** `hunting__check_client_name` dice si un texto nombra a un cliente que la búsqueda no revela, sin guardarlo: usalo antes de proponer un texto que va afuera.
9. **Borrados.** `hunting__delete_salary_band` borra la banda salarial interna y `hunting__remove_application_by_post` borra una postulación cargada por error y sin trabajar: ambas, tarjeta que no se deshace; proponelas sólo si la persona lo pide.

## Calibración, cliente y LinkedIn
10. **Calibración.** `hunting__get_calibration` muestra las alertas de búsqueda mal calibrada (sueldo fuera de mercado, requisitos que dejan afuera a casi todos). `hunting__dismiss_calibration_alert` la deja de mostrar con un motivo: el motivo lo escribe la persona, no vos.
11. **Rechazos del cliente.** `hunting__list_search_client_rejections` lista las candidatas que el cliente rechazó en la búsqueda, con la etapa y el código del motivo; `hunting__get_client_rejection_alert` dice desde cuántos rechazos la consultora avisa «Cliente con muchos rechazos: revisar». Es una señal para revisar al cliente, no una acción.
12. **LinkedIn.** `hunting__get_linkedin_query` trae lo que llena los filtros (los términos aprobados o los requisitos), `hunting__get_query_requirements` las aptitudes con sus sinónimos, `hunting__list_linkedin_term_versions` el historial de versiones aprobadas y `hunting__list_open_requirements` los requisitos de las búsquedas activas de la persona. Aprobar los términos y buscar en LinkedIn es de la persona.
13. **Cruce y selección.** `hunting__match_person` pide el cruce por reglas (sin IA) de los requisitos con el CV interno de una persona; `hunting__get_selection` y `hunting__check_selection_row` leen una selección vigente (la que arma `assistant__select_candidates`) y si una postulación sigue cumpliéndola.
14. **Ajustes de la consultora.** `hunting__get_close_reasons_catalog` (motivos para cerrar una postulación), `hunting__get_call_notes_status` (qué puntos de la primera llamada están cargados), `hunting__get_publication` y `hunting__get_inbound_links` (publicar: skill `publicar-busqueda`).

## Lo que decide la persona
Qué se cambia de una búsqueda; confirmar que una postulación sigue bien o reabrirla; borrar; el motivo de una alerta; los términos de LinkedIn y a qué cliente revisar.

## Sumar varias personas a una búsqueda
`hunting__add_many_to_search` (tarjeta): postula hasta 25 personas de la base a una búsqueda en una sola tarjeta, en la etapa inicial y sin valoración; no se envía nada, las que ya estaban no se duplican y es todo o nada. Sólo sirve con personas que te mostró `people__search_people` o `people__query_people` en los últimos 30 minutos (si no, 404). Preguntale **cuáles** y a qué búsqueda; las elige ella, vos no completás la lista.

## Reglas
- En el chat no repitas nombres ni datos de contacto de candidatos: usá ids o alias.
- Una tarjeta por cosa, con el sí explícito de la persona; nada en lote.
- Si una herramienta da 403 o 409, informalo y no busques otro camino.
