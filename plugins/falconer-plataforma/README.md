# falconer-plataforma

Plugin de Claude Code de la plataforma de reclutamiento (ADR 0506). Reemplaza al kit con la key.

## Instalar (una vez, desde la PC de la persona)
1. Definir la variable de entorno `RRHH_AGENT_KEY` con la key personal que genera la app en Configuración → Conectar tu Claude
   (nunca la pegues en un archivo ni en el chat).
2. `claude plugin marketplace add marcos22vm/falconer-plugins#v0.4.0` (la etiqueta fija la versión: subir de versión es una acción deliberada).
3. `claude plugin install falconer-plataforma@falconer-plugins`.
4. Reiniciar Claude Code. `/mcp` tiene que mostrar «plataforma».

Por ahora, **solo datos de prueba**. La IA recomienda, la persona decide; nada de automatizar LinkedIn.

## Si algo no anda
- `/mcp` no muestra «plataforma» o falla al arrancar: casi siempre falta la variable `RRHH_AGENT_KEY` (sin ella Claude Code puede
  rechazar el servidor entero). Definila y reiniciá Claude Code.
- Los avisos de versión nueva aparecen al abrir una sesión; actualizar es una acción tuya: `claude plugin update falconer-plataforma@falconer-plugins`.
