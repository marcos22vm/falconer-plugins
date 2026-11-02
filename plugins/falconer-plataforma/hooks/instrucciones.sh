#!/usr/bin/env bash
# Inyecta como contexto de la sesión las instrucciones de trabajo del plugin: texto estático empaquetado, nada de la red.
cat "${CLAUDE_PLUGIN_ROOT}/hooks/instrucciones.txt" 2>/dev/null
exit 0
