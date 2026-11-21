# Configurações RouterOS

Os arquivos desta pasta representam **os trechos mínimos documentados no TCC** para os Cenários A e B. Eles não devem ser tratados como export completo da RB3011.

## Pré-requisitos assumidos

Antes de aplicar os trechos, o equipamento deve possuir, conforme o ambiente do laboratório:

- uma `bridge` existente;
- `ether2` utilizada como trunk 802.1Q;
- interface WAN e `interface-list=WAN` já configuradas quando a regra de NAT for utilizada;
- regras padrão/anteriores de firewall revisadas pelo administrador;
- endereçamento compatível com o laboratório.

## Importante

Revise a ordem das regras de firewall antes de importar em outro equipamento. A avaliação do RouterOS depende da posição das regras na cadeia `forward`.

Não publique backups binários `.backup`, senhas, usuários administrativos, chaves ou segredos.
