# Setup Guide - Configuração do Ambiente

Este guia detalha como configurar o ambiente para usar os playbooks de automação do Proxmox.

## 📋 Pré-requisitos

### Sistema Operacional
- **Linux:** Ubuntu 20.04+ / Debian 11+ / CentOS 8+ / RHEL 8+
- **macOS:** Big Sur+ (com Homebrew)
- **Windows:** WSL2 com Ubuntu

### Software Necessário
- **Ansible:** 2.9 ou superior
- **Python:** 3.8 ou superior
- **SSH:** Cliente configurado
- **Git:** Para clonar o repositório

## 🔧 Instalação do Ansible

### Ubuntu/Debian
```bash
sudo apt update
sudo apt install ansible python3-pip openssh-client git
```

### CentOS/RHEL
```bash
sudo yum install epel-release
sudo yum install ansible python3-pip openssh-clients git
```

### macOS
```bash
brew install ansible
```

## 🏠 Configuração do Proxmox

### 1. Preparar o Proxmox
```bash
# Conectar no Proxmox via SSH
ssh root@SEU_IP_PROXMOX

# Verificar se está funcionando
pveversion
```

### 2. Criar Template Base (Recomendado)
```bash
# Baixar ISO do Debian (exemplo)
cd /var/lib/vz/template/iso/
wget https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2

# Criar VM template (ID 301)
qm create 301 --name "debian-12-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 301 debian-12-generic-amd64.qcow2 local-lvm
qm set 301 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-301-disk-0
qm set 301 --boot c --bootdisk scsi0
qm set 301 --ide2 local-lvm:cloudinit
qm set 301 --serial0 socket --vga serial0
qm template 301
```

## 🔑 Configuração SSH

### 1. Gerar Par de Chaves SSH (se não tiver)
```bash
ssh-keygen -t rsa -b 4096 -C "seu-email@exemplo.com"
```

### 2. Copiar Chave Pública para o Proxmox
```bash
ssh-copy-id root@SEU_IP_PROXMOX
```

### 3. Testar Conexão
```bash
ssh root@SEU_IP_PROXMOX
```

## 📁 Configuração do Projeto

### 1. Clonar Repositório
```bash
git clone https://github.com/seu-usuario/pve-homelab.git
cd pve-homelab
```

### 2. Configurar Inventário
```bash
# Copiar arquivo de exemplo
cp examples/inventory.ini.example inventory.ini

# Editar com seu IP do Proxmox
nano inventory.ini
```

**Exemplo do inventory.ini:**
```ini
[proxmox]
pve ansible_host=192.168.50.15 ansible_user=root

[proxmox:vars]
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

### 3. Configurar Variáveis (Opcional)
```bash
# Editar configurações padrão se necessário
nano vars/defaults.yml
```

## ✅ Verificação da Configuração

### 1. Testar Conectividade
```bash
ansible -i inventory.ini proxmox -m ping
```

**Resultado esperado:**
```
pve | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

### 2. Verificar Acesso ao Proxmox
```bash
ansible -i inventory.ini proxmox -m command -a "pveversion"
```

### 3. Teste Básico de Playbook
```bash
ansible-playbook -i inventory.ini playbooks/create-vm.yml --check
```

## 🚨 Solução de Problemas

### Erro de Conexão SSH
```bash
# Verificar se o SSH está rodando no Proxmox
ssh -v root@SEU_IP_PROXMOX

# Verificar chaves SSH
ssh-add -l
```

### Erro de Permissão
```bash
# Verificar se o usuário tem permissões adequadas
ansible -i inventory.ini proxmox -m command -a "whoami"
```

### Erro de Python
```bash
# Instalar python3 no Proxmox se necessário
ansible -i inventory.ini proxmox -m raw -a "apt update && apt install python3 -y"
```

## 🔧 Configurações Avançadas

### Ansible Configuration File
Criar `ansible.cfg` na raiz do projeto:
```ini
[defaults]
host_key_checking = False
timeout = 30
gathering = explicit

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
```

### Logging
```bash
export ANSIBLE_LOG_PATH=./ansible.log
```

## ✅ Próximos Passos

Após a configuração bem-sucedida:
1. Leia o [Usage Guide](usage.md) para usar os playbooks
2. Execute seu primeiro playbook de criação de VM
3. Explore as configurações avançadas

---
**💡 Dica:** Mantenha sempre backups das suas configurações e teste em ambiente separado primeiro!
