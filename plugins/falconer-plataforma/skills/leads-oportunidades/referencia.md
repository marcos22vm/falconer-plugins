# Referencia de `leads-oportunidades`

Leé la sección antes de pedir esa tarjeta.

**«Con el interruptor»** = pide que la owner haya prendido «lo irreversible y las decisiones sobre personas»; si no, 403 `person_decisions_disabled`: decíselo, no insistas.

## Acuerdo directo
Sólo con lo que dictó la persona: `leads__preview_agreement` dice si ya hay uno; `leads__set_default_agreement` (todo el lead) o `leads__set_search_agreement` (una búsqueda vinculada) con el honorario (porcentaje en puntos básicos o monto fijo con su moneda); garantía y plazo vacíos rigen los de la consultora. No pongas la referencia: la escribe la persona al aprobar, con su segundo factor. Si el acuerdo cambió en el medio, no se hace: volvé a pedirlo.

## Primer toque propio
Pedí `leads__set_first_touch_template` con el texto que dictó o aprobó la persona, **antes de leer nada del lead**: toda lectura de leads deja el token contaminado 30 minutos y entonces da 403 (también `leads__preview_first_touch_template`, que sólo sirve para revisar sin pedir). Sale una tarjeta con el texto entero y cómo saldría a cada país, con sus pies; si no pasa los filtros, 422 con el código: corregí el texto. Sólo los marcadores `{name}`, `{company}`, `{role}`, `{sender}` y `{firm}`; nada de enlaces, correos, teléfonos, cifras, nombres de sus contactos ni frases sobre la baja, el aviso o «no es comercial»: los pies los pone el servidor. Lo edita y lo manda una persona. `leads__clear_first_touch_template` vuelve a la general.

## El cliente firmó
Sólo cuando la persona te dice que el cliente firmó o aceptó por escrito, `leads__convert_opportunity` con el id de la oportunidad (tarjeta de aprobación). Al aprobarla, la oportunidad queda ganada, se abre la búsqueda asignada a ella y el lead queda habilitado: **no se deshace**. Con el interruptor. Si la oportunidad no está abierta (`opportunity_not_open`) o el lead está vetado (`lead_vetoed`), da 409 y no queda nada pendiente. La pendiente vence a las 2 horas y hay un tope de 10 aprobadas por día. Te vuelven sólo el id, el estado y el id de la búsqueda.

## Vincular una búsqueda
**Los tres pasos van en ese orden y la lista es obligatoria, no una sugerencia.** `leads__link_search` sólo acepta una búsqueda que `leads__list_linkable_searches` te haya mostrado **para ese mismo lead**, y vale **30 minutos**: pasado ese rato, o si no listaste, da **404 `not_found`** y el mensaje no te dice por qué (no distingue «no existe» de «no te la ofrecí»). Si te da 404 habiendo mandado bien los ids, **pedí la lista de nuevo y volvé a intentar en la misma vuelta**, sin leer otra cosa en el medio. `leads__preview_link_search` **no** cuenta como la lista: sirve para avisar si el cliente de la búsqueda no coincide con el lead, pero no habilita nada.

Y ojo con el orden cuando encadenás: toda lectura de leads deja el token contaminado 30 minutos, así que **vincular una segunda búsqueda corre la tarjeta que estés esperando** de la primera (aceptación por fuera, veto, descarte). Primero la tarjeta pendiente, después la vinculación siguiente.

Al vincular, el lead pasa a habilitado y la oportunidad queda ganada con esa búsqueda. Desde ahí el lead es el cliente de esa búsqueda: **no se deshace**. 409 si ya está vinculada o tiene colocaciones. Tarjeta; con el interruptor de las decisiones sobre personas. **No toca la propuesta**: una propuesta que nació colgada del lead sigue sin oportunidad después de vincular.

## Una búsqueda sin cliente
Una búsqueda real sin vacante no tiene cliente comercial que la ate, **no entra en el embudo** (los procesos abiertos se cuentan por la vacante) y su propuesta no se ve desde la búsqueda. Se repara en **dos pedidos, en este orden**, cada uno con su tarjeta:

1. `leads__list_linkable_searches` (vale 30 minutos) y `leads__link_search`: crea la vacante **ganada sobre esa misma búsqueda** y habilita el cliente. No abre ninguna búsqueda nueva.
2. `proposals__link_opportunity` con el id de la propuesta y el de esa vacante: le ata la vacante a la propuesta que había quedado colgada del cliente. **Conserva el honorario** que ya tuviera cargado y no cambia su estado ni su versión. Si la propuesta sigue en borrador con el nombre de la empresa como título, toma el título de la vacante.

- **No sirve `leads__open_engagement`**: busca las piezas por la vacante y, como estas búsquedas no tienen ninguna, crearía una **segunda** búsqueda y dejaría la vieja con su pipeline.
- **Tampoco sirven** `proposals__decide_proposal` con `open_search` ni abrir la búsqueda desde la propuesta: las dos **crean una vacante nueva** y abren **otra** búsqueda para la misma vacante, así que sobre una propuesta huérfana cuya búsqueda ya existe, duplican. **No registres la aceptación ni abras la búsqueda antes de reparar.**
- Los dos ids: la propuesta, de `proposals__list_proposals` o de la ficha del cliente; la vacante, de `leads__get_lead` o `leads__get_opportunity` (la que quedó con `search_id`).
- Rechazos del paso 2, y **ninguno sobreescribe**: `proposal_already_linked` (ya cuelga de otra vacante: mirá cuál corresponde, no insistas), `opportunity_other_lead` (es de otro cliente), `opportunity_has_live_proposal` (esa vacante ya tiene su propuesta viva), `opportunity_merged` (se unió a otra: atá la de destino) y `opportunity_discarded`.
- Pedir el paso 2 dos veces con la misma vacante deja lo mismo, sin escribir nada.
- Si hay **más de una** propuesta suelta de ese cliente, cuál es la de esta búsqueda lo decide la persona: preguntáselo, no elijas vos.

## Volver a revisar
Si la persona quiere deshacer un habilitado o un veto, `leads__reset_lead` con el id del lead (tarjeta de aprobación, con quién lo decidió y cuándo). Con el interruptor; un lead sin revisar da 409 `lead_not_decided`. No reabre las oportunidades descartadas ni levanta bajas u oposiciones de sus contactos. Te vuelven el id y el estado.

## Alta de un contacto
`leads__add_new_person_contact` lleva nombre, correo de trabajo o LinkedIn, cargo, tipo y rol, y sale como
tarjeta. Pedila **antes de leer el lead**, con el id de la tarjeta que lo creó. Si da `person_not_created`,
ya hay alguien con ese dato o pidió no ser contactada: buscala con `people__search_people` y sumala con
`leads__add_contact` y su `person_id` —que es el **alias** `P-XXXXXX` que te devolvió la búsqueda, no un id
con guiones—. La procedencia, la base legal y la retención las pone el servidor, y de dónde salió el dato lo
elige la persona al aprobar; vos mandás `contact_country` sólo si el lead no tiene país.
