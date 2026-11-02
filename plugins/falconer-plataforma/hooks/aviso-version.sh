#!/usr/bin/env bash
# Avisa si hay una versión nueva del plugin (ADR 0506, V3). La respuesta de la red es DATO: solo se acepta una
# versión X.Y.Z, y el aviso es una frase fija. La versión la sirve la plataforma (GET /api/public/plugin-version, ADR 0521). Sin red, o con cualquier otra cosa, no dice nada. No manda la key.
SEMVER='^[0-9]+\.[0-9]+\.[0-9]+$'
URL='https://app.falconertalent.com/api/public/plugin-version'
root="${CLAUDE_PLUGIN_ROOT:-}"
data="${CLAUDE_PLUGIN_DATA:-}"
[ -n "$root" ] || exit 0
local_v=$(sed -n 's/.*"version": *"\([0-9][0-9.]*\)".*/\1/p' "$root/.claude-plugin/plugin.json" 2>/dev/null | head -n 1)
[[ "$local_v" =~ $SEMVER ]] || exit 0
today=$(date +%Y-%m-%d)
remote_v=""
if [ -n "$data" ] && [ -f "$data/version-check" ]; then
  read -r day cached < "$data/version-check" 2>/dev/null
  if [ "$day" = "$today" ] && [[ "$cached" =~ $SEMVER ]]; then remote_v="$cached"; fi
fi
if [ -z "$remote_v" ]; then
  body=$(curl --silent --fail --max-time 3 --proto '=https' --max-redirs 0 --max-filesize 1024 "$URL" 2>/dev/null | head -c 64 | tr -d '[:space:]')
  [[ "$body" =~ $SEMVER ]] || exit 0
  remote_v="$body"
  if [ -n "$data" ]; then mkdir -p "$data" 2>/dev/null && printf '%s %s\n' "$today" "$remote_v" > "$data/version-check" 2>/dev/null; fi
fi
# Solo avisa si la remota es MAYOR que la local (componente a componente).
IFS=. read -r r1 r2 r3 <<< "$remote_v"
IFS=. read -r l1 l2 l3 <<< "$local_v"
newer=0
if (( 10#$r1 > 10#$l1 )) || { (( 10#$r1 == 10#$l1 )) && (( 10#$r2 > 10#$l2 )); } || { (( 10#$r1 == 10#$l1 )) && (( 10#$r2 == 10#$l2 )) && (( 10#$r3 > 10#$l3 )); }; then newer=1; fi
[ "$newer" = 1 ] || exit 0
printf '{"systemMessage":"Hay una versión nueva del plugin de la plataforma (%s; tenés la %s). Actualizala con: claude plugin update falconer-plataforma@falconer-plugins"}\n' "$remote_v" "$local_v"
exit 0
