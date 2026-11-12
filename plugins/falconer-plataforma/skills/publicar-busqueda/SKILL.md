---
description: Publica una búsqueda en las redes (LinkedIn, Get on Board) con la aprobación de la persona y revisa qué se publicó. Usar cuando dicen "publicá la búsqueda N", "¿ya se publicó?", "¿en qué cuentas puedo publicar?" o "desconectá la cuenta de Get on Board".
---
# Publicar una búsqueda

Publicar sale hacia afuera: **la persona ve el texto exacto y las cuentas en la tarjeta y la aprueba con su segundo factor**. Vos preparás y avisás qué falta.

## Pasos
1. **Cuentas.** `publishing__list_accounts` lista las cuentas que la persona puede usar (red, nombre, estado, dueña, vencimiento; sin tokens). Conectar o reconectar una cuenta es de la persona, en la app.
2. **Vista previa.** `publishing__get_preview` con la búsqueda dice si se puede publicar (si no, el motivo: búsqueda cerrada, sin publicación, sin casilla…), el código con que llegan las respuestas y el texto. Mostrale a la persona lo que devuelve: cuentas posibles, si ya se publicó y qué falta. `hunting__get_publication` dice si ya está publicada en el sitio de la consultora, y `hunting__get_inbound_links` trae los enlaces para postularse por mensaje.
3. **Pedirla.** Preguntale «¿la publico en estas cuentas?» y, sólo con su sí explícito, `publishing__publish_search` con las cuentas elegidas. Sale como **tarjeta** con las cuentas, el texto exacto y si es una republicación; el texto lo arma el servidor, no vos. La tarjeta dice si ya se publicó antes.
4. **Después.** `publishing__list_publications` muestra el historial por cuenta (publicada, fallida, pendiente). Si falló, decí el motivo y no la repitas sola.
5. **Desconectar.** `publishing__delete_account` desconecta una cuenta y borra su token (tarjeta; sólo su dueña). No retira lo ya publicado.

## Lo que decide la persona
En qué cuentas se publica y aprobar el texto exacto; republicar; conectar o desconectar una cuenta.

## Reglas
- Un pedido por búsqueda; hay un tope diario por cuenta.
- Si una herramienta da 403 o 409 (`already_published`, cuenta vencida, búsqueda cerrada), informalo y no busques otro camino.
