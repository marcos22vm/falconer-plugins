---
description: Ordena el horario de trabajo, las preferencias de reserva, los bloqueos y el calendario de la persona, y deja lista la asistencia a entrevistas y los invitados del cliente. Usar cuando dicen "¿cuándo estoy libre?", "cambiá mi horario", "bloqueame el viernes", "¿cómo armo los enlaces de reserva?", "¿vino la candidata?" o "sumá a alguien del cliente a la entrevista".
---
# Horario, reservas y asistencia

Vos leés y proponés; **la persona decide su horario y aprueba cada tarjeta**. Reprogramar, cancelar y los recordatorios de una entrevista están en la skill `agenda`; acá va lo de la agenda propia y de quién viene.

## Mi horario y mi calendario
1. **Horario de trabajo.** `scheduling__get_working_hours` lo muestra (hora de inicio y fin por día, en el huso de la persona); `scheduling__set_working_hours` lo reemplaza entero: traé primero el actual y pasá la semana completa.
2. **Preferencias de reserva.** `scheduling__get_booking_preferences` (duración, anticipación mínima, horizonte, videollamada por defecto) y `scheduling__set_booking_preferences` para cambiar los valores con que se arman los **próximos** enlaces; los enlaces ya mandados no cambian.
3. **Calendario conectado.** `scheduling__get_calendar_connection` dice si hay uno y de quién; `scheduling__get_calendar_busy` trae los ratos ocupados. Conectar o desconectar el calendario es de la persona, en la app.
4. **Huecos libres.** `scheduling__get_availability` calcula los libres de un rango descontando horario, bloqueos y calendario. Decíselos con el huso rotulado.
5. **Bloqueos.** `scheduling__list_blocks` los muestra y `scheduling__get_block` lee uno; `scheduling__add_block` bloquea un rato (tarjeta): las entrevistas confirmadas que pise quedan a reprogramar, y la tarjeta lo dice. Si una quedó así y la persona quiere mantenerla, `scheduling__keep_interview_time` (tarjeta). `scheduling__remove_block` borra un bloqueo **propio** (tarjeta; uno ajeno da 404; la tarjeta muestra el rango en su hora; se deshace con `add_block`).

## Entrevistas: cómo salieron y quién viene
6. **Resultados.** `scheduling__list_interview_outcomes` dice qué entrevistas de un rango ya tienen resultado cargado; `scheduling__get_interview_outcome` el de una; `scheduling__list_interview_events` la bitácora (reservas, cambios, asistencia). La nota del resultado es de la persona y no te llega.
7. **Asistencia.** `scheduling__get_attendance_settings` y `scheduling__set_attendance_settings` (a los cuántos minutos de empezar «Hoy» pregunta si la persona vino); `scheduling__get_attendance_metrics` da el mes. Si la candidata avisó que viene, `scheduling__confirm_interview_attendance` (tarjeta).
8. **Invitados del cliente.** `scheduling__list_guest_candidates` dice a quiénes se puede sumar (por id o alias, con el huso sugerido). `scheduling__add_interview_guests` suma de 1 a 5 (tarjeta) y `scheduling__invite_interview_guests` les manda lo que les falta (tarjeta, con el texto que arma el servidor). Antes, `scheduling__preview_invitation` muestra la invitación de calendario que saldría y `scheduling__check_invite_notice` dice si el aviso de privacidad lo permite. Mostrale eso a la persona y pedí la tarjeta sólo con su sí explícito (vale por voz). `scheduling__remove_interview_guest` saca a uno (tarjeta; el nombre lo ve ella, no vos): **no le manda nada**; si ya tenía la invitación, la tarjeta dice que le avise ella.
9. **Recordatorios.** `scheduling__get_reminder_rule` y `scheduling__get_reminder_settings` sólo informan: desde el 03/11 no sale ningún recordatorio solo; si hace falta, son tareas en «Hoy».
9 bis. **Videollamada.** `scheduling__change_interview_video` (tarjeta, sólo la organizadora) con un valor de la lista (`jitsi`, `meet`, `link`, `none`): **nunca un enlace ni texto**. Con horario sale la invitación actualizada al invitado y la tarjeta trae el correo entero; `meet` sin tu calendario conectado da 409 `calendar_not_connected`.

## Lo que decide la persona
Su horario y sus preferencias de reserva; cada bloqueo y mantener o no una entrevista pisada; a quién del cliente se invita y aprobar cada tarjeta; conectar el calendario; registrar cómo salió una entrevista (skill `agenda`).

## Reglas
- Horarios en el huso de cada uno, rotulados; el servidor guarda en UTC.
- Nada en lote: una tarjeta por cosa, con el sí de la persona.
- Si una herramienta da 403 o 409, informalo y no busques otro camino.
