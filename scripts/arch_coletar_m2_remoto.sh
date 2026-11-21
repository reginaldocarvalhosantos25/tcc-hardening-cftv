#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Executa M2 em uma VM via SSH e salva o CSV no host Arch.

Uso:
  ./arch_coletar_m2_remoto.sh SSH_DESTINO ORIGEM ARQUIVO.csv DESTINO:IP [DESTINO:IP ...]

Exemplo:
  ./arch_coletar_m2_remoto.sh admin-01@192.168.10.10 ADMIN M2-ADMIN.csv \
    CFTV:192.168.20.10 SERVER:192.168.30.10 GUEST:192.168.40.10

Jump host opcional:
  SSH_OPTS='-J admin-01@192.168.10.10' ./arch_coletar_m2_remoto.sh ...
USAGE
}

[[ $# -ge 4 ]] || { usage; exit 1; }

SSH_TARGET="$1"
ORIGEM="$2"
OUTPUT="$3"
shift 3
DESTINOS=("$@")
REPS="${REPS:-20}"

# Deliberadamente simples para permitir prompt de senha quando não há chave SSH.
# shellcheck disable=SC2086
ssh ${SSH_OPTS:-} "$SSH_TARGET" 'bash -s' -- "$ORIGEM" "$REPS" "${DESTINOS[@]}" <<'REMOTE' > "$OUTPUT"
ORIGEM="$1"
REPS="$2"
shift 2

printf 'repeticao,origem,destino,sucesso,rtt_ms\n'

for destino in "$@"; do
  nome="${destino%%:*}"
  ip="${destino#*:}"

  for i in $(seq 1 "$REPS"); do
    out=$(ping -c 1 -W 1 "$ip" 2>&1 || true)

    if grep -qE '1 (packets )?received|1 received' <<< "$out"; then
      rtt=$(sed -n 's/.*time=\([0-9.]*\) ms.*/\1/p' <<< "$out" | head -n1)
      printf '%s,%s,%s,1,%s\n' "$i" "$ORIGEM" "$nome" "$rtt"
    else
      printf '%s,%s,%s,0,\n' "$i" "$ORIGEM" "$nome"
    fi

    sleep 0.2
  done
done
REMOTE

echo "Arquivo salvo no Arch: $OUTPUT"
