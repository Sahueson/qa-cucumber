#!/usr/bin/env bash
# Ejecuta una o varias suites (carpetas de features/), opcionalmente solo algunos escenarios, con
# el staging reservado (with-staging.js reserva + resetea; cada suite resetea al empezar).
#   SUITE=c-inscripciones[,e-gobernanza]  GREP='TC-C01 Inscribirse…|TC-E03 …' (opcional)  ./run.sh
# SUITE y GREP llegan de la web: SUITE se limpia a caracteres de slug y GREP (regex de nombres de
# escenario, para --name) se pasa como un único argumento entre comillas.
set -euo pipefail
cd "$(dirname "$0")"
suites=$(printf %s "${SUITE:?Falta SUITE}" | tr -cd 'a-z0-9,-')
args=()
IFS=',' read -ra list <<< "$suites"
for s in "${list[@]}"; do [ -n "$s" ] && args+=("features/$s"); done
[ -n "${GREP:-}" ] && args+=(--name "$GREP")
exec node shared/reset-staging/with-staging.js -- npx cucumber-js "${args[@]}"
