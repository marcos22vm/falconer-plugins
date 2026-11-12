# Referencia de `presentar-feedback`

Las secciones largas de la skill, enteras (sólo se mudaron). Leé la sección antes de pedir esa tarjeta.

## Por voz
Es un circuito de **leer y una tarjeta**, sin pasos manuales:
1. **¿Qué contestó el cliente de la búsqueda X?** `hunting__list_searches` para el id y `client_feedback__get_feedback`: por candidata, `decision` (`advance` = quiere seguir/entrevistar, `pass` = no sigue) y, si hay una respuesta **pendiente** de confirmar, `pending_decision` con su `source`: `link` (el cliente contestó en el enlace), `recruiter` (la cargó una persona) o `ai_reply` (la **IA la leyó del correo del cliente** y dejó la lectura pendiente; hoy sólo corre donde la consultora la prendió y con la eval aprobada). Contale a la persona cuántas hay y de qué origen; no repitas nombres ni el texto del cliente (no te llega: es información interna). `client_feedback__get_decision` con el id da el detalle (qué, por dónde llegó, si ya se confirmó).
2. **«Marcalo como entrevista pedida»** = el cliente quiere avanzar con esa candidata (`advance`). Si ya hay una respuesta pendiente (la de la IA o la del enlace) y la persona la comparte, **no registres otra**: `client_feedback__confirm_decision` con el id de esa respuesta (tarjeta que muestra la respuesta tal como quedó; al aprobarla avanza la postulación de etapa). Si no hay ninguna, primero `client_feedback__record` con `advance` y sólo el id de la postulación (tarjeta, queda pendiente) y después `client_feedback__confirm_decision` (otra tarjeta). Son dos «sí» distintos de la persona; no los junten en uno.
3. Si la persona dice que **no sigue** (`pass`), el motivo lo escribe ella en la tarjeta: no lo mandes. Descartar una lectura mal hecha lo hace ella en la app.
4. **Nunca** le pases a una candidata lo que dijo el cliente ni pidas un texto con eso: ni siquiera «el cliente avanzó». Sólo existe «se decidió seguir con otro candidato», o lo que la reclutadora escriba a mano.

## Lecturas del seguimiento con el cliente
- `client_feedback__get_share` trae un enlace de shortlist compartido (búsqueda, vencimiento, si se revocó y cuántas visitas tuvo; el id sale de `client_feedback__list_shares`).
- `client_feedback__get_followup` trae el seguimiento de una búsqueda (cada cuántos días se le pide feedback, destinatario, idioma, pausa y si el correo del contacto rebotó). El pedido nunca sale solo.
- `client_feedback__get_cadence_settings` (topes por contacto y por día de los pedidos) y `client_feedback__get_interview_feedback_settings` (qué pasa al cargar que una entrevista con el cliente se hizo: nada, o una tarea en «Hoy» para pedirle feedback, y a los cuántos minutos vence). Cambiarlos es de la persona.
- `client_feedback__get_shareable_feedback` dice si una postulación tiene un feedback aprobado antes de la 0672: es un registro interno que no sale a la candidata por ningún camino.

## Si presentar da «aviso de privacidad pendiente»
`notice-pending` (o `notice_pending` en la tarjeta) no es un error del cliente: a esa persona todavía no le salió el aviso del art. 14, y no se la presenta hasta que salga. **Sale con el primer mensaje**: decile a la persona que le escriba desde «Escribirle», por LinkedIn con la línea del aviso que muestra el redactor, o por correo si tiene uno cargado (el aviso va al pie). No lo pidas otra vez ni busques otro camino; cuando haya salido, se presenta. Si pidió la baja, es otro caso: no se la presenta.

