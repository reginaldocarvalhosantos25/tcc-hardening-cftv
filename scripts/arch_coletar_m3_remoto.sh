#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Executa M3 em uma VM via SSH e salva o CSV no host Arch.

Uso:
  ./arch_coletar_m3_remoto.sh SSH_DESTINO ORIGEM ARQUIVO.csv [IP_CFTV] [USUARIO_TESTE]

Exemplo:
  ./arch_coletar_m3_remoto.sh admin-01@192.168.10.10 ADMIN M3-ADMIN-CFTV.csv
USAGE
}

[[ $# -ge 3 ]] || { usage; exit 1; }

SSH_TARGET="$1"
ORIGEM="$2"
OUTPUT="$3"
TARGET="${4:-192.168.20.10}"
TEST_USER="${5:-teste}"
REPS="${REPS:-20}"

# shellcheck disable=SC2086
ssh ${SSH_OPTS:-} "$SSH_TARGET" 'bash -s' -- "$ORIGEM" "$TARGET" "$TEST_USER" "$REPS" <<'REMOTE' > "$OUTPUT"
ORIGEM="$1"
TARGET="$2"
TEST_USER="$3"
REPS="$4"

export LC_ALL=C
printf 'repeticao,origem,destino,acessivel,tempo_ms\n'

for i in $(seq 1 "$REPS"); do
  inicio=$(date +%s%3N)

  out=$(ssh \
    -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null \
    "$TEST_USER@$TARGET" true 2>&1 || true)

  fim=$(date +%s%3N)
  tempo=$((fim - inicio))

  if grep -qi 'Permission denied' <<< "$out"; then
    acessivel=1
  else
    acessivel=0
  fi

  printf '%s,%s,CFTV,%s,%s\n' "$i" "$ORIGEM" "$acessivel" "$tempo"
  sleep 0.5
done
REMOTE

echo "Arquivo salvo no Arch: $OUTPUT"
