# Referencia de `sourcing-cv` (b)

Continuación de [`referencia.md`](referencia.md), partida porque una respuesta del kit no puede pasar los
20 000 caracteres. Las secciones están enteras (sólo se mudaron).

## Completar o corregir los datos de una persona
Contactos, ficha, huso y movilidad se piden **uno por vez, con tarjeta** (ve el antes y el después y la aprueba). Buscá a la persona (`people__search_people`) y, **sólo con el dato que ella te dictó o pasó** (nunca inventado ni deducido de un CV sin que te lo confirme):
- **Agregar un contacto**: `people__add_contact` con el tipo (email, teléfono con + y país, LinkedIn) y el valor; queda marcado como cargado por el agente. Si da 409 (lista de supresión o es de otra persona), **no busques otro camino** ni le preguntes por qué a nadie: decile que no se pudo.
- **Corregir o quitar**: primero `people__list_contacts` (id, tipo y procedencia, **sin el valor**: lo ve ella en la tarjeta) y después `people__correct_contact` o `people__remove_contact` (no se deshace; segundo factor).
- **La ficha**: `people__update_person` con sólo los campos que cambian (nombre, ubicación, país, puesto, empresa, huso); queda como declarado. El huso solo, `people__set_timezone` (IANA, como America/Argentina/Buenos_Aires).
- **Etiquetas**: `people__get_tags` y `people__edit_tags` con lo que **suma** (`add`) y **saca** (`remove`), nunca el conjunto entero; las de revisión de un CV (`cv-con-instrucciones-ia`, `cv-con-texto-oculto`, `cv-sin-revisar`) no se tocan.
- **Rol de candidata a alguien que ya está**: `people__enroll` con el origen (`sourcing_linkedin`, `sourcing_github`, `sourcing_other` o `referral` con su nota) y la base `legitimate_interest`; salen como **propuestos** y los decide la persona.
- **Idioma de los mensajes**: `people__set_message_language` (es, en o pt) con `source: recruiter`, si quien la atiende te lo dice; que lo pidió ella misma todavía no se puede pedir.
- **Un CV subido por error**: `people__delete_cv` con el motivo (`wrong_person`, `not_applicable` o `duplicate`); tarjeta con segundo factor, se borra de verdad. No sirve para una supresión de la candidata ni para el CV que originó su CV interno (409 `cv_in_use`).
- **Retirar un consentimiento**: `people__revoke_consent` con la cita de su mensaje (`conversation_id` y `source_message_id`); otorgarlo no se puede pedir.
- **Buscar personas**: `people__query_people` con `q`, `role`, `tags` o `list_id`; sólo las de la consultora.
- **Movilidad**: `people__set_mobility` reemplaza el registro entero (si quiere mudarse, a dónde, en cuántas semanas, permisos de trabajo), sólo lo que declaró; `people__clear_mobility` lo borra.
Antes de cada pedido mostrale **lo que vas a cargar** y preguntale «¿lo pido así?»; pedí la tarjeta sólo con su sí explícito (vale por voz). Un sí a otra cosa no vale.

## CV que llegaron adjuntos por correo
1. `mail__list_attachments` dice cuántos PDF o DOCX llegaron sin guardar (`count`) y, de cada uno, si va **directo** (el hilo ya tiene persona) o hay **duda** (`doubt`).
2. Directos: `mail__save_attachment_as_cv` los guarda como CV de la persona del hilo (entra pendiente de revisión, sin tarjeta). Si da 409 `cv_attachment_needs_person`, no insistas.
3. Con duda: preguntale de quién es cada uno (`person_ids` son los que tienen el correo del remitente) y, con lo que diga, `mail__propose_attachment_as_cv`: tarjeta en «Para aprobar». Nunca elijas vos a quién.
4. Cuando el CV quede revisado, delegá su lectura en el subagente `carga-cv`.

## Importar una planilla de candidatos
El archivo, el mapeo de columnas y la procedencia (base legal, origen, retención) son de la persona, en la app (Importar). Vos no subís el archivo ni elegís la base legal ni la fuente.
1. Con el lote mapeado, `imports__get_import` (estado `mapped`, filas) e `imports__preview_import` (conteos: nuevas, ya en la base, repetidas, inválidas, suprimidas) te dejan contarle qué traería.
2. `imports__confirm_import`: tarjeta en «Para aprobar» con los conteos, una muestra de 20 filas, lo que ella declaró y su segundo factor. Hasta 200 filas por lote y 2 lotes por día; más, `import_too_large` (que lo parta o lo confirme en la app); sin mapear, `import_not_mapped`. La red de LinkedIn no se importa.
3. Nunca digas que quedó importado antes de que ella apruebe; después `imports__get_import` dice cuántas se crearon.
