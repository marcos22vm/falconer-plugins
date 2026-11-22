# falconer-plataforma

Plugin de Claude Code de la plataforma de reclutamiento (ADR 0506). Reemplaza al kit con la key.

## Instalar (una vez, desde la PC de la persona)
1. Definir la variable de entorno `RRHH_AGENT_KEY` con la key personal que genera la app en Configuración → Conectar tu Claude
   (nunca la pegues en un archivo ni en el chat).
2. Preguntale al servidor qué versión corre y usala como etiqueta — **este archivo ya no la escribe**, porque un número a mano acá caduca en cada bump y el 19/11/2026 ya mandó a instalar dos versiones
   viejas seguidas (la 0.7.4 contra un servidor en 0.8.71, y la 0.8.71 contra uno en 0.8.72):
   ```
   V=$(curl -s https://app.falconertalent.com/api/public/plugin-version)
   claude plugin marketplace add marcos22vm/falconer-plugins#v$V
   ```
   La etiqueta sigue fijando la versión —subir es una acción deliberada—, pero el número sale de quien lo sabe, no de este texto.
3. `claude plugin install falconer-plataforma@falconer-plugins`.
4. Reiniciar Claude Code. `/mcp` tiene que mostrar «plataforma» y «plataforma-lecturas».

## Los dos servidores (desde la 0.6.0, ADR 0666)
- **plataforma** (`/mcp`): escrituras, tarjetas de aprobación, novedades, «qué falta» y la guía completa.
- **plataforma-lecturas** (`/mcp/code`): las lecturas por Code Mode (`plataforma__search` y `plataforma__execute`). Viene
  prendido (ADR 0806) y la owner lo apaga en Ajustes: apagado, conecta igual y muestra **cero herramientas**; si la instalación
  no tiene Code Mode, da error. Las dos cosas son esperables: se lee por «plataforma», que lo avisa (ADR 0807). Con Code Mode prendido, «plataforma» deja de listar las lecturas y la sesión carga cerca de un 38 % menos.

Si el servidor dice que la consultora habilitó datos reales (`datos_reales.permitido` en `plataforma__que_falta`), se trabaja con lo real y con lo de prueba, distinguiéndolos por `data_kind` (cada ítem de una cola o lista lo trae); si no, sólo con lo de prueba. Lo decide la owner en Configuración, no este kit. La IA recomienda, la persona decide; nada de automatizar LinkedIn.

## Si algo no anda
- «plataforma-lecturas» con cero herramientas: Code Mode no está prendido en tu consultora; no es una falla.
- `/mcp` no muestra «plataforma» o falla al arrancar: casi siempre falta la variable `RRHH_AGENT_KEY` (sin ella Claude Code puede
  rechazar el servidor entero). Definila y reiniciá Claude Code.
- Los avisos de versión nueva aparecen al abrir una sesión; actualizar es una acción tuya: `claude plugin update falconer-plataforma@falconer-plugins`.
