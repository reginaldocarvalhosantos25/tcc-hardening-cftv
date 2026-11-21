# TCC — Hardening em segmento de CFTV IP

Repositório de apoio ao Trabalho de Conclusão de Curso **“Análise e aplicação de técnicas de hardening em sistemas de CFTV IP integrados a redes corporativas”**, desenvolvido na Universidade Federal do Pará (UFPA).

## Objetivo do repositório

Disponibilizar os materiais técnicos utilizados para documentar e reproduzir os experimentos descritos no TCC:

- scripts dos indicadores M1, M2 e M3;
- trechos mínimos de configuração RouterOS dos Cenários A e B;
- dados brutos em CSV das 20 repetições realizadas em cada condição;
- instruções de execução e organização dos resultados.

## Ambiente experimental

| Segmento | VLAN | Rede | Host principal |
|---|---:|---|---|
| ADMIN | 10 | 192.168.10.0/24 | ADMIN-01 — 192.168.10.10 |
| CFTV | 20 | 192.168.20.0/24 | CFTV-01 — 192.168.20.10 |
| SERVER | 30 | 192.168.30.0/24 | SERVER-01 — 192.168.30.10 |
| GUEST | 40 | 192.168.40.0/24 | GUEST-01 — 192.168.40.10 |
| MGMT | 99 | 192.168.99.0/24 | estação de gerenciamento |

A infraestrutura utilizou um MikroTik RB3011UiAS, RouterOS, um host Arch Linux, VMware Workstation, máquinas virtuais Debian 13 e uma estação Kali Linux para os testes de varredura.

## Cenários avaliados

### Cenário A — referência

As VLANs e o roteamento inter-VLAN estavam presentes, porém os fluxos avaliados não eram restringidos pelas regras `TCC-HARDEN`.

### Cenário B — hardening

Foram aplicadas regras explícitas de firewall para:

- permitir `MGMT -> internal`;
- permitir `ADMIN -> CFTV`;
- permitir `ADMIN -> SERVER`;
- bloquear os demais fluxos inter-VLAN avaliados;
- bloquear origens não autorizadas com destino ao segmento CFTV.

## Indicadores

### M1 — exposição de serviços

Uma varredura de referência avaliou as 1000 portas TCP padrão do Nmap. Para repetibilidade, a porta `22/TCP` foi avaliada em 20 varreduras direcionadas por cenário.

Scripts:

- `scripts/m1_varredura_referencia.sh`
- `scripts/m1_nmap_repeticoes.sh`

### M2 — comunicação inter-VLAN

Os 12 fluxos direcionais entre ADMIN, CFTV, SERVER e GUEST foram avaliados. Cada fluxo foi repetido 20 vezes, totalizando 240 medições por cenário.

Script:

- `scripts/m2_icmp_repeticoes.sh`

### M3 — exposição administrativa

ADMIN-01, SERVER-01 e GUEST-01 realizaram 20 tentativas de conexão SSH cada uma contra a CFTV-01, totalizando 60 tentativas por cenário.

Script:

- `scripts/m3_ssh_repeticoes.sh`

## Estrutura

```text
tcc-hardening-cftv/
├── README.md
├── .gitignore
├── scripts/
│   ├── m1_varredura_referencia.sh
│   ├── m1_nmap_repeticoes.sh
│   ├── m2_icmp_repeticoes.sh
│   ├── m3_ssh_repeticoes.sh
│   ├── arch_coletar_m2_remoto.sh
│   └── arch_coletar_m3_remoto.sh
├── routeros/
│   ├── README.md
│   ├── cenario-a-baseline.rsc
│   └── cenario-b-hardening.rsc
├── dados/
│   ├── README.md
│   ├── cenario-a/
│   └── cenario-b/
└── docs/
    └── reproducibilidade.md
```

## Execução rápida

### M1 — referência completa

Na Kali:

```bash
./scripts/m1_varredura_referencia.sh 192.168.20.10 cenario-a-cftv
```

### M1 — 20 repetições da porta 22

```bash
./scripts/m1_nmap_repeticoes.sh 192.168.20.10 M1-KALI-CFTV.csv
```

### M2 — exemplo a partir da ADMIN-01

```bash
./scripts/m2_icmp_repeticoes.sh \
  ADMIN M2-ADMIN.csv \
  CFTV:192.168.20.10 \
  SERVER:192.168.30.10 \
  GUEST:192.168.40.10
```

### M3 — exemplo ADMIN -> CFTV

```bash
./scripts/m3_ssh_repeticoes.sh \
  ADMIN M3-ADMIN-CFTV.csv 192.168.20.10 teste
```

O usuário remoto `teste` é propositalmente utilizado apenas para verificar se o serviço SSH chega à etapa de autenticação. O script não tenta autenticar com senha.

## Coleta a partir do Arch Linux

Os scripts `arch_coletar_m2_remoto.sh` e `arch_coletar_m3_remoto.sh` executam os testes em uma VM via SSH e salvam o CSV no host Arch.

Para o CFTV no Cenário B, pode ser necessário utilizar jump host pela ADMIN-01. Exemplo:

```bash
SSH_OPTS='-J admin-01@192.168.10.10' \
./scripts/arch_coletar_m2_remoto.sh \
  cftv-01@192.168.20.10 CFTV M2-CFTV.csv \
  ADMIN:192.168.10.10 SERVER:192.168.30.10 GUEST:192.168.40.10
```

## Dados

A pasta `dados/` contém os CSVs utilizados para consolidar os resultados das 20 repetições nos Cenários A e B.

## Segurança

Não publique:

- backups binários `.backup` do RouterOS;
- senhas;
- chaves privadas;
- tokens;
- credenciais reais;
- arquivos que revelem dados desnecessários da rede doméstica ou corporativa.

Os arquivos `.rsc` presentes aqui contêm somente os trechos necessários para documentar o experimento descrito no TCC.

## Autor

Reginaldo de Carvalho Santos — 2026.
