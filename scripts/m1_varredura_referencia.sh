#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-192.168.20.10}"
PREFIX="${2:-m1-cftv-referencia}"

command -v nmap >/dev/null 2>&1 || {
  echo "Erro: nmap não encontrado." >&2
  exit 1
}

# Varredura de referência descrita no TCC:
# -Pn: não depende da descoberta convencional do host
# -sT: TCP Connect
# -sV: detecção de serviço/versão
# -oA: salva .nmap, .gnmap e .xml
nmap -Pn -sT -sV "$TARGET" -oA "$PREFIX"
