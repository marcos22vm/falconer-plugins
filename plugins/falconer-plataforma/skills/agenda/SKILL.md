---
description: Lleva la agenda de entrevistas como una secretaria que pide permiso para cada envío: reprogramar, cancelar, armar otra entrevista después de una ausencia, mandar el recordatorio y pedir que la candidata confirme. Cada cosa sale como tarjeta con el correo entero y la persona la aprueba. Usar cuando dicen "pedile otro horario", "cancelá la entrevista de mañana", "no vino, proponele otra", "mandale el recordatorio", "pedile que confirme" o "¿qué tengo hoy en la agenda?".
---
# Agenda: reprogramar, cancelar, seguimiento, recordatorio y confirmación

Vos preparás y pedís; **la persona ve el correo entero y lo aprueba** en la tarjeta (con su segundo factor). Nada sale en lote ni porque sí: una tarjeta por cada cosa que la persona pidió. Las herramientas son del servidor MCP «plataforma» (su descripción y esquema son la fuente de verdad). Ninguna lleva texto tuyo: el correo lo arma el servidor con los textos aprobados de la consultora.

## Pasos
1. **Ubicar la entrevista.** `scheduling__get_agenda_today` (lo de hoy, lo que quedó a reprogramar y lo que no tiene resultado) o `scheduling__list_interviews` con un rango. `scheduling__get_interview` da el estado, el horario, el huso del invitado y si quedó «a reprogramar» y por qué. Si hay más de una posible, preguntá cuál.
1b. **El resultado cargado.** `scheduling__get_interview_outcome` dice cómo salió una entrevista (hecha o «no vino») o que todavía no tiene resultado.
2. **Probar antes.** `scheduling__preview_interview_action` con la acción (`reschedule`, `cancel`, `follow_up`, `reminder` o `attendance_request`) te dice si se puede y si le escribe a alguien (`sends`), con el mismo 409 que daría la acción. El texto del correo no te llega: lo ve la persona en la tarjeta. Antes de invitar a una candidata, `scheduling__check_invite_notice` dice si el aviso de privacidad lo permite (`notice_rule_missing` si la consultora no aprobó la regla).
3. **Pedir la tarjeta**, una por pedido:
   - **Reprogramar** (`scheduling__reschedule_interview`): le sale a la candidata un enlace nuevo para elegir horario; el actual sigue reservado hasta que elija. Opcional `origin` (quién lo pidió). Si ya tiene un enlace de hace menos de un día, 409 `link_open`: lo decide la persona en la app.
   - **Cancelar** (`scheduling__cancel_interview`): con horario, le sale la cancelación. `origin` y `reason_code` son de lista cerrada; nunca un motivo escrito. Si la candidata no avisó y ya empezó, no es una cancelación: 409 `use_no_show`, va el resultado.
   - **Otra entrevista después de una ausencia o una cancelación** (`scheduling__follow_up_interview`): sólo sobre una cancelada o con el resultado «no vino» ya cargado. Si empezó sin resultado, 409 `outcome_required`: primero el resultado (`scheduling__record_interview_outcome`, que decide la persona). Si todavía no empezó, se reprograma la misma (`use_reschedule`).
   - **Recordatorio de 24 h** (`scheduling__send_interview_reminder`): sólo dentro de las 24 h previas (`not_due`) y uno por entrevista (`already_sent`).
   - **Pedido de confirmación** (`scheduling__request_interview_attendance`): con el enlace para responder; uno por entrevista (`already_requested`).
4. **Contarle a la persona** qué va a salir, a quién y a qué hora en el huso del invitado y en el suyo, y que lo apruebe en la tarjeta. Si algo cambió antes de aprobar (el horario, el texto, la casilla), no sale nada: volvé a pedirlo.

## Lo que decide la persona
Aprobar cada envío (y la tarjeta de `scheduling__record_interview_outcome`, con la que registrás que alguien no vino o cómo salió); quién la originó y el motivo de una cancelación; mantener un horario que pidió cambiar la candidata; cambiar la videollamada, sacar a una invitada del cliente, anular un resultado y conectar el calendario (todo eso, en la app).

## Reglas
- Nunca en lote, nunca porque sí, nunca para «probar»: sólo lo que la persona pidió, una tarjeta por cosa.
- Horarios en el huso de cada uno, rotulados; el servidor guarda en UTC.
- No repitas nombres ni correos en el chat: referite por id o por la hora de la entrevista.
- Si una herramienta da 403, 404 o 409, no busques otro camino: decile qué falta (el código lo dice).
- Cambiar la videollamada de una entrevista (`scheduling__change_interview_video`), borrar un bloqueo propio (`scheduling__remove_block`) o sacar a un invitado del cliente (`scheduling__remove_interview_guest`): tarjeta; el detalle está en `horario-y-reservas`.
