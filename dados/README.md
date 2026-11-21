# Dados brutos dos experimentos

Os CSVs desta pasta correspondem às 20 repetições utilizadas na análise estatística do TCC.

## Cenário A

- `M1-KALI-CFTV.csv`: 20 varreduras da porta 22/TCP a partir da Kali;
- `M2-ADMIN.csv`, `M2-CFTV.csv`, `M2-SERVER.csv`, `M2-GUEST.csv`: 20 repetições para cada um dos 12 fluxos direcionais;
- `M3-ADMIN-CFTV.csv`, `M3-SERVER-CFTV.csv`, `M3-GUEST-CFTV.csv`: 20 tentativas SSH por origem.

## Cenário B

Mesma estrutura do Cenário A, após a aplicação das regras `TCC-HARDEN`.

Os arquivos são preservados sem alterações para manter rastreabilidade entre os dados brutos e os resultados consolidados apresentados no TCC.
