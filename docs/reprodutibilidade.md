# Procedimento resumido de reprodutibilidade

1. Configurar a topologia e o endereçamento do laboratório.
2. Aplicar o Cenário A e confirmar que as regras adicionais `TCC-HARDEN` não restringem os fluxos avaliados.
3. Executar M1, M2 e M3 com 20 repetições e preservar os CSVs.
4. Aplicar as regras do Cenário B.
5. Repetir M1, M2 e M3 nas mesmas condições.
6. Comparar frequências/proporções e, quando aplicável, média e desvio padrão amostral.

## Critérios utilizados

- M1: estado da porta 22/TCP (`open`, `filtered` etc.) e tempo de execução da varredura.
- M2: `sucesso=1` quando há resposta ICMP; `sucesso=0` quando não há resposta dentro do timeout.
- M3: `acessivel=1` quando o SSH alcança a etapa de autenticação; `acessivel=0` quando a conexão expira ou não alcança o serviço.

Os tempos de timeout do M3 nos fluxos bloqueados não devem ser interpretados como latência de rede.
