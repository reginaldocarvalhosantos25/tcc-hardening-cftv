# TCC - CENARIO A / BASELINE
# Trecho mínimo documentado no Apêndice A.
# Pressupõe bridge existente e ether2 utilizada como trunk.

/interface vlan
add comment="TCC - ADMIN" interface=bridge name=vlan10-admin vlan-id=10
add comment="TCC - CFTV" interface=bridge name=vlan20-cftv vlan-id=20
add comment="TCC - SERVER" interface=bridge name=vlan30-server vlan-id=30
add comment="TCC - GUEST" interface=bridge name=vlan40-guest vlan-id=40
add comment="TCC - Management" interface=bridge name=vlan99-mgmt vlan-id=99

/interface bridge vlan
add bridge=bridge comment="TCC - VLAN10 ADMIN" tagged=bridge,ether2 vlan-ids=10
add bridge=bridge comment="TCC - VLAN20 CFTV" tagged=bridge,ether2 vlan-ids=20
add bridge=bridge comment="TCC - VLAN30 SERVER" tagged=bridge,ether2 vlan-ids=30
add bridge=bridge comment="TCC - VLAN40 GUEST" tagged=bridge,ether2 vlan-ids=40
add bridge=bridge comment="TCC - VLAN99 MGMT" tagged=bridge,ether2 vlan-ids=99

/ip address
add address=192.168.10.1/24 interface=vlan10-admin
add address=192.168.20.1/24 interface=vlan20-cftv
add address=192.168.30.1/24 interface=vlan30-server
add address=192.168.40.1/24 interface=vlan40-guest
add address=192.168.99.1/24 interface=vlan99-mgmt

/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WAN

# No Cenário A, as regras adicionais TCC-HARDEN não são aplicadas aos fluxos avaliados.
