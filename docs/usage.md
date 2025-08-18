# Usage Guide - Guia de Uso dos Playbooks

Este guia detalha como usar os playbooks para criar e gerenciar VMs no Proxmox.

## 📚 Visão Geral dos Playbooks

### 🔵 `create-vm.yml` - Criação Básica
- Criação simples de VM a partir de template
- Configuração manual de rede
- Ideal para testes rápidos

### 🟢 `create-vm-cloudinit.yml` - Criação Avançada (Recomendado)
- Criação com Cloud-Init
- Configuração automática de usuário e SSH
- Pronto para uso imediato

## 🚀 Usando o Playbook Cloud-Init (Recomendado)

### Execução Básica
```bash
ansible-playbook -i inventory.ini playbooks/create-vm-cloudinit.yml
```

### Exemplo de Execução Interativa
```
Digite o ID para a nova VM: 102
Digite o nome (hostname) para a nova VM: web-server-01
Digite o nome do usuário sudo para a nova VM: admin
Digite a senha para o novo usuário: [senha oculta]
Digite o tamanho do disco em GB (ex: 50): 50
Digite a quantidade de memória em MB (ex: 4096): 4096
Digite o número de cores de CPU (ex: 2): 4
```

### Parâmetros Detalhados

| Parâmetro | Descrição | Exemplo | Validação |
|-----------|-----------|---------|-----------|
| **VM ID** | Identificador único da VM | `102` | 100-999999 |
| **Hostname** | Nome da máquina | `web-server-01` | Alfanumérico + hífen |
| **Usuário** | Usuário sudo a ser criado | `admin` | Alfanumérico |
| **Senha** | Senha do usuário | `MinhaSenh@123` | Entrada oculta |
| **Disco** | Tamanho em GB | `50` | 10-1000 |
| **Memória** | RAM em MB | `4096` | 512-32768 |
| **CPU** | Número de cores | `4` | 1-16 |

## 🔵 Usando o Playbook Básico

### Execução
```bash
ansible-playbook -i inventory.ini playbooks/create-vm.yml
```

### Diferenças do Cloud-Init
- ❌ Não configura usuário automaticamente
- ❌ Não instala chave SSH
- ✅ Mais rápido para testes
- ✅ Menor complexidade

## 🛠️ Configurações Avançadas

### Executar com Variáveis Personalizadas
```bash
ansible-playbook -i inventory.ini playbooks/create-vm-cloudinit.yml \
  -e vm_id=103 \
  -e vm_name=database-01 \
  -e vm_user=dba \
  -e disk_size=100 \
  -e memory=8192 \
  -e cores=6
```

### Executar em Modo Check (Dry Run)
```bash
ansible-playbook -i inventory.ini playbooks/create-vm-cloudinit.yml --check
```

### Executar com Verbose
```bash
ansible-playbook -i inventory.ini playbooks/create-vm-cloudinit.yml -v
```

## 🌐 Configuração de Rede

### Padrão Automático
As VMs são criadas com IP baseado no ID:
- **VM 102:** `192.168.50.102/24`
- **VM 103:** `192.168.50.103/24`
- **Gateway:** `192.168.50.1`

### Customizar Rede
Edite o arquivo `vars/defaults.yml`:
```yaml
network:
  subnet: "10.0.1"        # Altere para sua rede
  gateway: "10.0.1.1"     # Altere para seu gateway
  dns: "10.0.1.1"         # Altere para seu DNS
```

## 🔑 Gestão de Chaves SSH

### Chave Padrão
O playbook usa automaticamente: `~/.ssh/id_rsa.pub`

### Chave Personalizada
```bash
# Alterar temporariamente
export SSH_KEY_PATH="/caminho/para/sua/chave.pub"

# Ou editar vars/defaults.yml
ssh:
  key_path: "/caminho/para/sua/chave.pub"
```

## 📊 Monitoramento e Logs

### Verificar Status da VM
```bash
# No Proxmox
qm status 102

# Via Ansible
ansible -i inventory.ini proxmox -m command -a "qm status 102"
```

### Logs do Ansible
```bash
# Habilitar logging
export ANSIBLE_LOG_PATH=./ansible.log

# Executar playbook
ansible-playbook -i inventory.ini playbooks/create-vm-cloudinit.yml

# Verificar logs
tail -f ansible.log
```

## 🔧 Exemplos Práticos

### Caso 1: Servidor Web
```yaml
VM ID: 110
Nome: web-nginx-01
Usuário: webadmin
Disco: 30GB
Memória: 2048MB
CPU: 2 cores
```

### Caso 2: Banco de Dados
```yaml
VM ID: 120
Nome: db-postgres-01
Usuário: dbadmin
Disco: 100GB
Memória: 8192MB
CPU: 4 cores
```

### Caso 3: Servidor de Aplicação
```yaml
VM ID: 130
Nome: app-node-01
Usuário: appuser
Disco: 50GB
Memória: 4096MB
CPU: 4 cores
```

## 🚨 Solução de Problemas

### Erro: VM ID já existe
```
TASK [Falhar se VM já existir] *****
fatal: [pve]: FAILED! => {"msg": "VM com ID 102 já existe!"}
```
**Solução:** Use um ID diferente ou remova a VM existente

### Erro: Chave SSH não encontrada
```
fatal: [pve]: FAILED! => {"msg": "could not locate file in lookup: ~/.ssh/id_rsa.pub"}
```
**Solução:** 
```bash
# Gerar nova chave
ssh-keygen -t rsa -b 4096

# Ou especificar caminho correto
export SSH_KEY_PATH="/caminho/correto/chave.pub"
```

### Erro: Timeout SSH
```
TASK [Aguardar VM ficar acessível via SSH] *****
fatal: [pve]: FAILED! => {"msg": "Timeout when waiting for 192.168.50.102:22"}
```
**Solução:** 
- Verificar se a VM iniciou corretamente
- Verificar configuração de rede
- Aumentar timeout no playbook

### VM não consegue acessar internet
**Solução:**
```bash
# Na VM, verificar configuração de rede
ip route show
ping 8.8.8.8

# Verificar DNS
cat /etc/resolv.conf
```

## 📋 Checklist Pós-Criação

Após criar uma VM, verifique:

- [ ] VM está rodando: `qm status <ID>`
- [ ] IP foi atribuído corretamente
- [ ] SSH está funcionando: `ssh usuario@ip`
- [ ] Internet está funcionando na VM
- [ ] Usuário tem privilégios sudo
- [ ] Partição do disco foi expandida

## 🔄 Próximos Passos

1. **Configurar a VM:** Instalar software necessário
2. **Backup:** Criar snapshot da VM configurada
3. **Monitoramento:** Configurar alertas
4. **Documentar:** Anotar configurações específicas

---
**💡 Dica:** Sempre teste os playbooks com `--check` primeiro!
