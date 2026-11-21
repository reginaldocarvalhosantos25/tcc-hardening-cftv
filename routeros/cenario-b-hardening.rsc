# TCC - CENARIO B / HARDENING
# Trecho adicional documentado no Apêndice B.
# Deve ser revisado quanto à posição das regras antes da importação.

/ip firewall address-list
add address=192.168.10.0/24 comment="TCC ADMIN" list=TCC-INTERNAL
add address=192.168.20.0/24 comment="TCC CFTV" list=TCC-INTERNAL
add address=192.168.30.0/24 comment="TCC SERVER" list=TCC-INTERNAL
add address=192.168.40.0/24 comment="TCC GUEST" list=TCC-INTERNAL
add address=192.168.99.0/24 comment="TCC MGMT" list=TCC-INTERNAL

/ip firewall filter
add action=accept chain=forward comment="TCC-HARDEN: MGMT -> internal" dst-address-list=TCC-INTERNAL src-address=192.168.99.0/24
add action=accept chain=forward comment="TCC-HARDEN: ADMIN -> CFTV" dst-address=192.168.20.0/24 src-address=192.168.10.0/24
add action=accept chain=forward comment="TCC-HARDEN: ADMIN -> SERVER" dst-address=192.168.30.0/24 src-address=192.168.10.0/24
add action=drop chain=forward comment="TCC-HARDEN: DROP inter-VLAN" dst-address-list=TCC-INTERNAL src-address-list=TCC-INTERNAL
add action=drop chain=forward comment="TCC-HARDEN: DROP unauthorized -> CFTV" dst-address=192.168.20.0/24
