# Referencia de `machear`

Las secciones largas de la skill, enteras (sólo se mudaron). Leé la que corresponda antes de usar esas
herramientas.

## Explicar un puntaje y los frenos de contacto (sólo lectura)
- **La regla y el umbral.** `matching__get_score_rule` (pesos y topes vigentes), `matching__list_score_rule_versions` (versiones), `matching__get_search_threshold` (el umbral exacto de la búsqueda, de dónde sale y el seniority mínimo) y `matching__get_search_threshold_history` (cómo se movió y por qué código). No dicen quién los aprobó o cambió. **Sirven para explicar** un puntaje o un grupo; **nunca calcules, ordenes ni filtres vos con la regla**: el puntaje de una persona se lee con `matching__approximate_score` y lo calcula la plataforma. Aprobar la regla, cambiar el umbral o previsualizar sigue siendo de la persona en la app.
- **«¿Por qué no puedo escribirle?»** `people__get_engagement_holds` (una persona) o `people__get_engagement_holds_batch` (hasta 100): dice si está colocada, en proceso en otra búsqueda o marcada por off-limits de un cliente, si eso frena el contacto y si hay un destrabe vigente. `hunting__get_engagement_hold_rule` trae la regla (veda en meses, etapa que frena, meses del off-limits) y `people__list_contact_hold_releases` los destrabes vigentes y cuándo vencen. **Del off-limits no sabés el cliente ni la fecha del pase.** Si la persona pidió la baja, se opuso o está restringida, estas lecturas dan «no existe» como si no estuviera: no insistas ni lo interpretes. Dar o revocar un destrabe o un pase sigue siendo de la persona en la app.


## Las demás herramientas del macheo, en orden
**Antes de evaluar.**
- Una persona sin CV interno estructurado: `matching__request_cv_parse` (la IA lee el CV y propone el CV interno; queda pendiente hasta que una persona lo acepte; `person_id`, y `cv_id` si no es el último). `matching__get_cv_parse_status` dice cómo va, sin el contenido ni las citas.
- JD sin estandarizar: `matching__request_jd_standardization` (descripción corta y extendida en es/en/pt y los requisitos; queda como sugerencia) y `matching__get_jd_suggestion` (la JD sugerida pendiente tal como la aprobaría «Aprobar todo»: las seis versiones y los requisitos con su cita). Aprobarla es de la persona.
- Qué es excluyente: `assessments__set_criteria_importance` (tarjeta; un mapa de id de requisito a `required` o `desired`; los ids salen de `assessments__get_criteria`). Preguntale cuáles exige de verdad: cambia a quién deja pasar.

**Evaluar.**
- `matching__evaluate_all` (tarjeta): evalúa **toda** la búsqueda en el servidor (prefiltro y de a 5 en segundo plano). Gasta IA de la consultora: decile a cuántas personas alcanza y esperá su sí. `matching__get_evaluation` muestra el avance (en cola, evaluando, terminó) y el informe de ahorro.
- Prefiltro: `matching__list_prefilter_results` (quién pasó y quién quedó «no evaluado por el pre-filtro», con las tecnologías que nombra su CV; `passed=false` para ver sólo los que no). La medición para elegir el umbral (`get_prefilter_backtest`) es sólo del asistente de la app.
- Una persona o una página de la base: `matching__request_person_match` (el match con motivo contra los requisitos; queda pendiente, no rankea ni descarta) y `matching__request_search_suggestions` (hasta 5 personas de la base por página, con `offset`/`limit`).
- Revisar de a una: `matching__next_suggested_candidate` trae la siguiente que encaja y sigue sin decidir, con lo que cumple de cada requisito (para saltar, `after` con el id de la última vista). Mostrala sin ranking. **Sumar, descartar o saltar lo decide la persona.**

**El umbral.** `matching__preview_search_threshold` dice cuántas personas cambiarían de grupo con un umbral nuevo (sólo conteos, no guarda nada). `matching__lower_search_threshold` (tarjeta) pide **bajar** el umbral, nunca subirlo; el motivo lo elige la persona al aprobar. Mirá antes el preview y que `raises` sea falso.

**La primera llamada.** `matching__suggest_call_questions` arma las preguntas sugeridas de un resultado (cada una con su requisito y su cita; `origin` `template` o `ai`) y `matching__get_call_questions` dice si ya hay, cuántas y de qué tipo; el texto lo ve ella en la app.

