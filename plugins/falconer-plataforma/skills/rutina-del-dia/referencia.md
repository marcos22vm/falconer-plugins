# Referencia de `rutina-del-dia`

Los pasos 0.3 (línea de base), A1 (panorama con Code Mode) y C2 (constancia) de la skill, enteros. Leé la sección antes de hacerlos.

## 0.3. Línea de base
3. **Primera vez** (después, una vez cada dos semanas). La línea de base son **tres lecturas, cada una con su única definición**; no recalcules nada:
   - `metrics__get_routine_baseline`: mediana de horas hábiles para contestar a una candidata, tarjetas de más de 24 h, búsquedas de más de 30 días sin acción en la semana.
   - `billing__get_dso`: los días de cobro (DSO), por moneda y por cliente. La `definition` que trae es la de la plataforma. Es sólo de owner y admin: si da 403, anotá «sin DSO (la lectura es de owner/admin)» y seguí.
   - `metrics__get_objective_progress`: los procesos cerrados del mes por reclutadora (el objetivo de 30 a 200). Una reclutadora ve sólo lo suyo.
   Ponelas al principio del resumen y avisá que son la medida para saber si la rutina sirve.

## A1. Panorama
1. **Panorama.** Corré lo de la skill `hoy`: `hunting__get_today` y `hunting__get_today_feed`. Si el servidor «plataforma-lecturas» (Code Mode) está conectado, hacé estas lecturas con **un solo** `plataforma__execute` (varias lecturas en pasos y un `return` corto) en vez de una llamada por cada una; si no está, llamalas por nombre. Dentro de `steps` las herramientas van con punto (`hunting.get_today`), no con doble guion bajo. Ejemplo mínimo:
   `{"steps":[{"id":"hoy","tool":"hunting.get_today","args":{}},{"id":"cobros","tool":"billing.list_claims_today","args":{}}],"return":{"value":{"hoy":"$hoy","cobros":"$cobros.due","cortados":"$cobros.stopped"}}}`.
   Un programa admite pocos pasos (con 12 da 422 `program_too_large`: partilo en dos) y un 404 en un paso lo corta entero: por eso `outreach__get_proposed_reply`, que da 404 cuando no hay regla, se llama de a una y por nombre. Code Mode es sólo de lectura: las tarjetas se piden por el servidor «plataforma».

## C2. Constancia
2. **Constancia**: `assistant__report_routine_run` (si da 429 por el límite diario, anotalo en el resumen) con la franja, la fecha local y los conteos, **en dos niveles**: `{"slot":"morning","local_date":"2026-11-11","body":{"counts":{"candidate_replies":0,"client_replies":0,"drafts":0,"cards_pending":0,"interview_prep":0,"collections":0,"stale_searches":0,"retention":0,"linkedin_tasks":0,"no_feedback_discards":0}}}`. Es una declaración tuya, no una prueba: sólo sirve para el aviso de «hoy no corrió». `assistant__get_routine_runs` muestra las de hoy.

## A5. Los digests de la fase A
Sólo lectura; nada se pide.
   - Búsquedas de más de 30 días: `hunting__list_searches` y `hunting__get_search_next_step` de cada una; en el resumen, dónde se trabó y qué opciones hay. (Los lunes, el digest completo.)
   - Retención por vencer: `privacy__list_expiring`; lo vencido va primero. Proponé una acción por caso, que la persona decide.
   - Tareas de LinkedIn del día: `outreach__next_linkedin_task` y `outreach__open_linkedin_task` dicen cuál sigue y si el texto está listo. Una lista priorizada; **la extensión no hace nada sola**: las manda ella, a ritmo humano.
