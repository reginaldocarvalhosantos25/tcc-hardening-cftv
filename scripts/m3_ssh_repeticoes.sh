#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

usage() {
  cat <<'USAGE'
Uso:
  ./m3_ssh_repeticoes.sh ORIGEM ARQUIVO.csv IP_DESTINO [USUARIO_TESTE]

Exemplo:
  ./m3_ssh_repeticoes.sh ADMIN M3-ADMIN-CFTV.csv 192.168.20.10 teste

O teste considera "acessível" quando o SSH responde e chega à etapa de
autenticação, identificada por "Permission denied". Não é fornecida senha.
USAGE
}

[[ $# -ge 3 ]] || { usage; exit 1; }

ORIGEM="$1"
OUTPUT="$2"
TARGET="$3"
SSH_USER="${4:-teste}"
REPS="${REPS:-20}"
CONNECT_TIMEOUT="${CONNECT_TIMEOUT:-5}"

printf 'repeticao,origem,destino,acessivel,tempo_ms\n' > "$OUTPUT"

for i in $(seq 1 "$REPS"); do
  inicio=$(date +%s%3N)

  out=$(ssh \
    -o BatchMode=yes \
    -o ConnectTimeout="$CONNECT_TIMEOUT" \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "$SSH_USER@$TARGET" true 2>&1 || true)

  fim=$(date +%s%3N)
  tempo=$((fim - inicio))

  if grep -qi 'Permission denied' <<< "$out"; then
    acessivel=1
  else
    acessivel=0
  fi

  printf '%s,%s,CFTV,%s,%s\n' "$i" "$ORIGEM" "$acessivel" "$tempo" >> "$OUTPUT"
  sleep 0.5
done

echo "Arquivo gerado: $OUTPUT"
