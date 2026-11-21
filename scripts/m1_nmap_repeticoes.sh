#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C

TARGET="${1:-192.168.20.10}"
OUTPUT="${2:-M1-KALI-CFTV.csv}"
REPS="${REPS:-20}"
PORT="${PORT:-22}"

command -v nmap >/dev/null 2>&1 || {
  echo "Erro: nmap não encontrado." >&2
  exit 1
}

printf 'repeticao,porta,estado,tempo_s\n' > "$OUTPUT"

for i in $(seq 1 "$REPS"); do
  inicio=$(date +%s%3N)
  out=$(nmap -Pn -sT -sV -p "$PORT" "$TARGET" 2>&1)
  fim=$(date +%s%3N)

  tempo_ms=$((fim - inicio))
  estado=$(awk -v p="$PORT" '$1 ~ ("^" p "/tcp$") {print $2}' <<< "$out" | head -n1)
  [[ -n "$estado" ]] || estado="indeterminado"
  tempo_s=$(awk "BEGIN {printf \"%.3f\", $tempo_ms/1000}")

  printf '%s,%s,%s,%s\n' "$i" "$PORT" "$estado" "$tempo_s" >> "$OUTPUT"
  sleep 0.5
done

echo "Arquivo gerado: $OUTPUT"
