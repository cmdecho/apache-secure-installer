enable
configure terminal

! ===== VLAN DATABASE =====
vlan 10
 name Marketing
 exit

vlan 20
 name Finance
 exit

! ===== PORT ASSIGNMENT =====
interface range fa0/1 - 2
 switchport mode access
 switchport access vlan 10
 no shutdown
 exit

interface range fa0/3 - 4
 switchport mode access
 switchport access vlan 20
 no shutdown
 exit

end
write memory
