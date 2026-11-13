# Bandeja: referencia

Lo largo de la skill `bandeja`, para leer cuando hace falta.

## 1. Mirar el correo antes de asignar o responder
- **Encontrar.** `mail__search` busca en asunto, remitente y texto de sus casillas y devuelve ids de hilo y de mensaje, sin el contenido (opcional `mailbox_id`). `mail__get_thread` abre un hilo: sus mensajes con fecha, carpeta y estado (leído, destacado, archivado), sin remitentes, texto ni adjuntos.
- **¿De quién es?** `mail__resolve_thread` (dado un hilo) y `mail__resolve_by_headers` (dado proveedor, remitente y asunto) dicen a qué persona y búsqueda corresponde, o a quién se parece. Son una consulta: **no vinculan nada**; vincular es `mail__assign` o `mail__set_thread_links`, con el sí de la persona.
- **El correo de todos los días.** «¿Qué tengo sin leer?»: `mail__list_threads` con `unread=true` (y `folder`: `inbox`, `sent` o `archive`; `mailbox_id` para una sola casilla); te vuelve el hilo, la fecha y cuántos no leídos, nunca remitente ni texto. Para ver las marcas de un hilo, `mail__get_thread` (leído, destacado, archivado). Las carpetas propias de la casilla (`folder_id`), la vista de los destacados (`flagged`) y la lista de ids son sólo de la app: con el agente dan 422, no las pidas. Marcar es de a un correo con `mail__set_message_flags` (`seen`, `flagged` o `archived`; se deshace con el valor anterior); si te piden muchos, decí cuántos son y esperá su sí. Mover entre carpetas, borrar y vaciar la papelera no tienen herramienta: se hacen en la app.
- **Alertas y marcas.** `mail__list_alerts` lista los avisos de correo nuevo de una persona o búsqueda que sigue (`status` open o resolved) y `mail__dismiss_alert` descarta uno sin tocar el correo. `mail__set_message_flags` marca un correo leído, destacado o archivado, también en el servidor de correo: nada se borra nunca.
- **Rebotes y adjuntos.** `mail__list_bounces` lista los rebotes (sin la dirección); sirve para encadenar `people__correct_contact` con la dirección nueva. `mail__get_attachment` dice tipo, fecha, tamaño y a quién iría un CV adjunto, sin el contenido. **Levantar un rebote es de la persona en la app.**
- **Gmail.** `mail__get_gmail_connection` dice si su Gmail está conectado en sólo lectura y con qué filtro, y `mail__list_gmail_labels` las etiquetas para elegirlo. Conectar o cambiar el filtro es de ella, en la app.

## 2. Reintentar un correo propio que falló
`mail__retry_failed_message` (tarjeta con segundo factor) vuelve a mandar el **mismo** correo que falló, sin cambiar nada; probalo con `mail__preview_retry`. Uno de la agenda, una factura o una propuesta da 409 `mail_origin_not_retryable`: se reintenta con su herramienta. Más de 7 días, `mail_too_old`; con baja de un destinatario, `suppressed`. Escribir un correo nuevo no tiene herramienta: lo hace ella en la app.

`mail__sync_mailbox` trae ya lo nuevo de UNA casilla de ella, sin esperar el sondeo, y sin tarjeta porque no manda nada: te vuelven sólo cuántos correos leyó y cuántos guardó (hasta 6 veces por hora por casilla). El id de la casilla sale de `mail__mailbox_status`; después leé con `mail__list_threads`. Una casilla que no es de ella da 404.
