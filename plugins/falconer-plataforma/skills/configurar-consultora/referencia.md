# Plantillas de los documentos: cómo se ven los PDF de la consultora

Cambiar **cómo se ve** un documento que ve el cliente ya no necesita que nadie despliegue nada. Cada
documento tiene su propia **galería de plantillas** y su propia plantilla **en uso**.

Hoy hay cuatro: el **CV ciego** (`blind_profile`, el PDF que se manda en una licitación), el **informe
del perfil** (`profile_report`, el que resume una evaluación), la **propuesta comercial** (`proposal`) y
el **resumen de cuenta** (`billing`, el PDF interno de cobro, que comparte plantilla con su nota de
crédito). Son galerías separadas: cambiar la del CV ciego no toca a las otras.

Un detalle que conviene saber decir: la propuesta y la factura **se quedan con la plantilla que tenían
al salir**. Si alguien cambia la plantilla después, lo ya enviado se sigue reimprimiendo igual que como
lo recibió el cliente.

En el resumen de cuenta la plantilla **sólo cambia el aspecto**: no hay secciones ni campos que elegir.
Es a propósito, porque es el único documento cuyo texto dice qué es —«no es un comprobante fiscal»— y
re-rotularlo lo convertiría en otra cosa.

## Lo que podés hacer vos

1. `tenancy__list_document_kinds` — qué documentos se pueden vestir. Empezá por acá si no sabés el nombre.
2. `tenancy__list_document_templates` — la galería de uno: la que trae el sistema (**versión 0**: es de la
   plataforma, no se edita, pero **sí se puede elegir**) y las que guardó la consultora, con cuál está en uso.
3. `tenancy__get_active_document_template` — con cuál sale hoy. Si dice **versión 0**, es que nadie eligió
   ninguna y rige la del sistema: **eso es lo que imprime de verdad**, no un dato que falta.
4. `tenancy__get_document_catalog` — qué secciones y campos puede mostrar ese documento, y cuáles están
   protegidos. Es la lista blanca: lo que no está ahí no se puede imprimir, ni con una plantilla.
5. `tenancy__get_document_template_version` — una versión guardada por su id, **vigente o no**. Sirve para
   contestar «¿con qué formato salió este PDF que ya mandamos?»: el documento trae la plantilla y su
   versión, y la traza guarda el id.
6. `tenancy__use_document_template` — **intercambiar** cuál se usa. Va por tarjeta: la persona aprueba.

## El orden, y qué preguntar

Si te piden «ponelo más chico», «sacale el color», «probá la sobria»: **leé primero la galería** y decile
qué plantillas tiene y cuál está en uso. Si no dijo cuál quiere, **preguntale**: no elijas vos, es cómo la
consultora se muestra a sus clientes.

Antes de pedir el cambio, decí en palabras qué documento y qué plantilla, porque son dos galerías: «el CV
ciego pasa de la que trae el sistema a "Sobria nuestra"». La tarjeta muestra el antes y el después.

**Nada se pierde al cambiar**: volver a la anterior es la misma llamada con el otro nombre, y **volver a la
que trae el sistema también** —se pide por su nombre, el que muestra la galería—. Decíselo, porque es lo que
hace que probar no dé miedo. Ojo con una trampa de la primera vez: la **primera** plantilla que guarda una
consultora queda en uso sola, así que guardar ya cambia cómo salen los documentos; avisale, y si no era lo
que quería, volver es una llamada.

Ninguna plantilla de la consultora puede llamarse como la del sistema: si alguien lo pide, el servidor lo
rechaza y hay que elegir otro nombre. Es para que el nombre siempre signifique una sola cosa.

## Lo que decide la persona, y lo que no se hace por voz

- **Elegir la plantilla en uso**: lo aprueba ella, siempre, en la tarjeta. **Sólo owner o admin.**
- **Diseñar una plantilla nueva** (qué secciones salen, qué rótulos, qué tipografía) y **mirar la vista
  previa**: en la app, Configuración → Consultora → Plantillas de documentos. No se dicta por voz: una
  definición entera no se dice, se mira.
- **Nunca por voz**: nada que cambie *qué datos* salen en un documento. Una plantilla elige **cómo se ve**,
  nunca **qué campos se imprimen**, y eso no es una limitación que se pueda levantar pidiéndolo. Si te
  piden agregar un dato que el documento no muestra (una certificación, el mes de un período, una
  validación de idioma), la respuesta es que eso **no es formato** y se decide en otro lado.
- Lo que una decisión protege **no se puede ocultar ni re-rotular**, y el servidor lo rechaza: el pie legal
  y el código del perfil en el CV ciego; el pie y la **línea de que hubo IA** en el informe. Si alguien
  insiste, explicá por qué existe: sin el pie, «Empresa reservada» se lee como una omisión sospechosa de la
  candidata; sin la línea de IA, un informe sobre una persona oculta que hubo IA.
- El **orden del informe** es fijo: datos, criterios, mirada, trayectoria, recomendación. Se pueden apagar
  secciones, no moverlas.

## Si algo no sale

- «La plantilla no existe»: no es de esa consultora, o es la del sistema, que no se elige por nombre. Leé la
  galería y decile qué hay; **no pruebes otros ids**.
- Si te piden la vista previa, mandala a la app: el documento de ejemplo se mira, no se cuenta.
