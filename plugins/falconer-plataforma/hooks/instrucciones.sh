#!/usr/bin/env bash
# Inyecta como contexto de la sesión las instrucciones de trabajo del plugin: texto estático empaquetado, nada de la red.
cat "${CLAUDE_PLUGIN_ROOT}/hooks/instrucciones.txt" 2>/dev/null
# ADR 1118: la ruta del catálogo local, que sólo se sabe en ejecución (el texto empaquetado no puede traerla),
# y la cuenta de herramientas, para que se vea que leerlo entero no es el camino.
catalogo="${CLAUDE_PLUGIN_ROOT}/catalogo.jsonl"
if [ -f "$catalogo" ]; then
  # La cuenta sale de la primera línea SIN sustitución de comandos: este script corre en la máquina de cada
  # usuaria al abrir su Claude y no puede ejecutar nada (lo vigila
  # `test_el_script_de_instrucciones_no_toca_la_red_ni_ejecuta_otras_cosas`). Así que se lee con una
  # redirección y se corta con expansión de parámetros; si el recorte no da sólo dígitos, no se dice el número.
  n=""
  primera=""
  read -r primera < "$catalogo" || primera=""
  resto="${primera#*\"herramientas\":}"
  if [ "$resto" != "$primera" ]; then
    n="${resto%%,*}"
    case "$n" in '' | *[!0-9]*) n="" ;; esac
  fi
  printf '\n## El catálogo de herramientas de la plataforma\n'
  printf 'Está en este archivo, una herramienta por línea:\n\n    %s\n\n' "$catalogo"
  printf 'Son %s herramientas, y cada línea EMPIEZA con su nombre. Buscá la tuya con este patrón exacto,\n' "${n:-muchas}"
  printf 'anclado al principio y con la coma final:\n\n'
  printf '    grep '\''^{"n":"hunting__move_stage",'\'' %s\n\n' "$catalogo"
  printf 'LAS DOS PUNTAS IMPORTAN: hay nombres que son prefijo de otros (`hunting__get_search` y\n'
  printf '`hunting__get_search_board`), y un patrón flojo trae la línea equivocada: armarías la llamada con\n'
  printf 'el esquema de OTRA herramienta. Si el grep trae más de una línea, no elijas: revisá el patrón.\n'
  printf 'De esa línea, `chica` es la letra chica (precondiciones, efectos, cuándo preguntar) y `esq` es el\n'
  printf 'JSON Schema entero de la llamada. **No lo leas entero ni lo cargues de arranque**: son cientos de\n'
  printf 'miles de caracteres y una sesión usa quince herramientas.\n'
  printf 'La primera línea trae un índice de familias con cuántas tiene cada una: es para cuando NO sabés\n'
  printf 'cuál buscar. Si ya sabés el nombre, salteala y andá derecho a su línea.\n'
fi
exit 0
