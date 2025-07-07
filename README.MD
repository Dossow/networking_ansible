Proyecto Ansible - Túneles GRE entre Routers Cisco

Automatiza la configuración de túneles GRE entre tres routers Cisco usando Ansible desde Docker.


 Estructura del Proyecto

```
proyecto_vpn/
├── Dockerfile
├── docker-compose.yml
├── inventory/hosts.yml
├── group_vars/cisco.yml
├── host_vars/R1.yml, R2.yml, R3.yml
├── playbooks/deploy_vpn.yml
└── roles/gre_tunnel/tasks/main.yml


 Comandos principales

```bash
docker-compose build --no-cache
docker-compose up -d
docker exec -it ansible-proyecto bash
ansible-playbook -i inventory/hosts.yml playbooks/deploy_vpn.yml
```



 Inventario (`inventory/hosts.yml`)

```yaml
all:
  children:
    cisco:
      hosts:
        R1:
          ansible_host: 10.0.1.1
        R2:
          ansible_host: 10.0.2.1
        R3:
          ansible_host: 10.0.3.1
```

---

 Credenciales (`group_vars/cisco.yml`)

```yaml
ansible_connection: network_cli
ansible_network_os: cisco.ios.ios
ansible_user: cisco
ansible_password: cisco
ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
```

---

 Variables por router (`host_vars/R1.yml`, etc.)

```yaml
tunnel_interface: Tunnel0
tunnel_ip: 172.16.0.1
tunnel_peer: 10.0.2.1
source_interface: GigabitEthernet1/0
```

---

Playbook (`playbooks/deploy_vpn.yml`)

```yaml
- name: Desplegar túnel GRE entre routers Cisco
  hosts: cisco
  gather_facts: no
  roles:
    - gre_tunnel
```

---

 Rol (`roles/gre_tunnel/tasks/main.yml`)

```yaml
- name: Configurar túnel GRE
  cisco.ios.ios_config:
    lines:
      - interface {{ tunnel_interface }}
      - ip address {{ tunnel_ip }} 255.255.255.252
      - tunnel source {{ source_interface }}
      - tunnel destination {{ tunnel_peer }}
      - tunnel mode gre ip
```

---

Verificación

En el router:
```bash
show run | section Tunnel
```

---

 Requisitos previos

En cada router:
```bash
conf t
hostname R1
ip domain-name red.local
crypto key generate rsa
username cisco privilege 15 secret cisco
line vty 0 4
 login local
 transport input ssh
```



├── docker-compose.yml
├── Dockerfile
├── group_vars
│   └── cisco.yml
├── host_vars
│   ├── R1.yml
│   ├── R2.yml
│   └── R3.yml
├── inventory
│   └── hosts.yml
├── playbooks
│   └── deploy_vpn.yml
├── README.md
└── roles
    └── gre_tunnel
        └── tasks
            └── main.yml
