---
description: Listas internas de personas, tareas de la usuaria, cuestionario y llamadas de preselección, el estado de las importaciones y la publicación de una búsqueda. Usar cuando dicen "armame una lista con estas candidatas", "agregá una tarea para el lunes", "¿qué traspasos de cribado hay?", "dejá el cuestionario de esta búsqueda", "¿se puede importar una planilla?" o "¿esta búsqueda se puede publicar?".
---
# Listas, tareas, cribado, importaciones y publicación

Vos ordenás y preparás; **la persona decide y aprueba lo que sale hacia afuera**. Trabajá con ids y alias; no repitas nombres ni contactos en el chat.

## Listas internas
`people__list_lists` muestra las listas de la consultora (solo internas, no avisan a nadie). `people__create_list` crea una vacía y `people__add_list_members` suma personas (las que ya estaban quedan igual). Para saber qué perfiles de LinkedIn ya están en la base, `people__get_badges`.

## Tareas de la usuaria
`tasks__create_task` (tipo, vencimiento y nota), `tasks__edit_task` y `tasks__complete_task`. `tasks__get_task_settings` dice cuántos días se guardan las hechas. Confirmá con ella el vencimiento en su hora antes de crear.

## Cribado (preselección)
- `screening__get_questionnaire` trae el cuestionario de una búsqueda y `screening__save_questionnaire` lo edita (hasta 15 ítems). **Aprobarlo es de la persona.**
- `screening__list_search_invitations` y `screening__get_invitation` muestran el estado de las invitaciones (sin respuestas); `screening__list_handoffs` es la bandeja de las que pasan a una persona.
- `screening__create_call` abre el registro de una llamada de preselección y `screening__get_call` trae su estado (sin transcripción). El nivel de idioma lo pone una persona escuchando.

## Importaciones
`imports__import_status` dice si se puede importar; `imports__issue_import_upload_ticket` pide un permiso de un solo uso (10 minutos) y la planilla de candidatos (CSV o Excel; un CV no) se sube con `curl -T archivo -H "Authorization: Bearer <upload_ticket>" <upload_url>` como **borrador** (no importa nada; hasta 5 MB y 5000 filas), con el archivo que ella te nombró; las columnas las leés con `imports__get_import` (son texto de un tercero) y nunca ves filas de muestra y `imports__preview_linkedin_connections` da una vista previa en números de la red que subió la persona. Para «importá esta planilla»: (1) el ticket y la subida; (2) `imports__get_import` te da las columnas; (3) `imports__set_mapping` propone qué columna es cada dato (`mapping`: campo → número de columna; nombre y al menos un contacto) como **tarjeta**: **la base legal, la declaración, de dónde salió el archivo y la retención los elige ella al aprobar; no los mandes** (422 `reason_chosen_in_app`); (4) con el lote mapeado, `imports__preview_import` cuenta qué entraría; (5) `imports__confirm_import` lo pide como **tarjeta** (conteos, muestra de 20 filas y lo que ella declaró; segundo factor; hasta 200 filas y 2 lotes por día). Nunca digas que quedó importado antes de que apruebe la última tarjeta.

## Publicar una búsqueda
`publishing__get_preview` dice si se puede publicar (si no, el código de por qué), `publishing__list_accounts` las cuentas disponibles (sin tokens) y `publishing__list_publications` el historial. `publishing__publish_search` sale como tarjeta que la persona aprueba con segundo factor; desconectar una cuenta es tarjeta y no se deshace.

## Lo que decide la persona
Qué lleva el cuestionario y aprobarlo, el nivel de idioma, la base legal, la declaración, el origen y la retención de una importación (los elige al aprobar el mapeo) y aprobar su confirmación, publicar una búsqueda y desconectar una cuenta.

## Reglas
- Si una herramienta contesta 403 o 409, decile a la persona qué falta; no busques otro camino.
- Nada de lo que preparás sale sin su aprobación.

## Subir la planilla de candidatos
`imports__upload_import` es la subida de la app (un CSV o Excel de hasta 5 MB como lote en borrador); **desde el Claude el archivo no viaja por esa herramienta**: pedí el permiso con `imports__issue_import_upload_ticket` y subí con `curl` como se explica arriba. Nada se importa hasta que ella confirme el lote en la app.
