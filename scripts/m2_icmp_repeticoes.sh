#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

usage() {
  cat <<'USAGE'
Uso:
  ./m2_icmp_repeticoes.sh ORIGEM ARQUIVO.csv DESTINO:IP [DESTINO:IP ...]

Exemplo:
  ./m2_icmp_repeticoes.sh ADMIN M2-ADMIN.csv \
    CFTV:192.168.20.10 SERVER:192.168.30.10 GUEST:192.168.40.10

Variáveis opcionais:
  REPS=20       número de repetições por fluxo
  TIMEOUT=1     timeout do ping em segundos
  INTERVAL=0.2  pausa entre repetições
USAGE
}

[[ $# -ge 3 ]] || { usage; exit 1; }

ORIGEM="$1"
OUTPUT="$2"
shift 2

REPS="${REPS:-20}"
TIMEOUT="${TIMEOUT:-1}"
INTERVAL="${INTERVAL:-0.2}"

printf 'repeticao,origem,destino,sucesso,rtt_ms\n' > "$OUTPUT"

for destino in "$@"; do
  nome="${destino%%:*}"
  ip="${destino#*:}"

  if [[ "$nome" == "$destino" || -z "$ip" ]]; then
    echo "Destino inválido: $destino. Use NOME:IP." >&2
    exit 1
  fi

  for i in $(seq 1 "$REPS"); do
    out=$(ping -c 1 -W "$TIMEOUT" "$ip" 2>&1 || true)

    if grep -qE '1 (packets )?received|1 received' <<< "$out"; then
      rtt=$(sed -n 's/.*time=\([0-9.]*\) ms.*/\1/p' <<< "$out" | head -n1)
      printf '%s,%s,%s,1,%s\n' "$i" "$ORIGEM" "$nome" "$rtt" >> "$OUTPUT"
    else
      printf '%s,%s,%s,0,\n' "$i" "$ORIGEM" "$nome" >> "$OUTPUT"
    fi

    sleep "$INTERVAL"
  done
done

echo "Arquivo gerado: $OUTPUT"
