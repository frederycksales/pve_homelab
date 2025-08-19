# Home Lab Proxmox - Automação SRE/DevOps

[![Ansible](https://img.shields.io/badge/Ansible-2.9+-red.svg)](https://ansible.com)
[![Proxmox](https://img.shields.io/badge/Proxmox-VE%208.0+-orange.svg)](https://proxmox.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

**Objetivo:**  
Repositório para automação de infraestrutura em Home Lab usando Proxmox VE, focado em estudos práticos de Site Reliability Engineering (SRE), DevOps e tecnologias Cloud-Native.

## 🏗️ Arquitetura do Home Lab

### Hardware do Servidor
- **CPU:** Intel Core i5-10400F (6 Cores / 12 Threads)
- **RAM:** 28 GB DDR4
- **Storage Primário:** 1TB NVMe SSD (OS/VMs)
- **Storage Secundário:** 3TB HDD (Dados/Backup)
- **Placa-Mãe:** ASUS TUF GAMING Z490-PLUS

### Software Stack
- **Hipervisor:** Proxmox VE 8.0+
- **Automação:** Ansible 2.9+
- **OS Template:** Debian 12 (Cloud-Init)

### Rede
- **Subnet:** `192.168.50.0/24`
- **Gateway:** `192.168.50.1`
- **Proxmox Host:** `192.168.50.15/24`

## 📁 Estrutura do Projeto

```
├── playbooks/              # Playbooks Ansible
│   ├── create-vm.yml       # Criação básica de VM
│   └── create-vm-cloudinit.yml # Criação com Cloud-Init
├── scripts/                # Scripts auxiliares
│   ├── create-vm.sh       # Script bash para criação manual
│   ├── run-playbook.sh    # Script facilitador para execução
│   └── check-setup.sh     # Verificação do ambiente
├── examples/              # Arquivos de exemplo
│   └── inventory.ini.example # Template do inventário
├── vars/                  # Variáveis e configurações
│   └── defaults.yml       # Configurações padrão
├── docs/                  # Documentação
│   ├── setup.md          # Guia de configuração
│   └── usage.md          # Guia de uso
├── ansible.cfg           # Configurações do Ansible
├── CHANGELOG.md          # Histórico de mudanças
└── .gitignore            # Proteção de dados sensíveis
```

## 🚀 Quick Start

### 1. Pré-requisitos
```bash
# Instalar Ansible
sudo apt update && sudo apt install ansible

# Clonar o repositório
git clone https://github.com/seu-usuario/pve-homelab.git
cd pve-homelab
```

### 2. Configuração
```bash
# Configurar ambiente local
./scripts/setup-local.sh

# Editar com seu IP do Proxmox
nano inventory.ini

# Verificar configuração
./scripts/check-setup.sh
```

### 3. Uso Básico
```bash
# Método facilitado (recomendado)
./scripts/run-playbook.sh cloud-init

# Ou método direto
ansible-playbook -i inventory.ini playbooks/create-vm-cloudinit.yml

# Dry-run para testar
./scripts/run-playbook.sh cloud-init check
```

## 📚 Documentação

- **[Setup Guide](docs/setup.md)** - Configuração completa do ambiente
- **[Usage Guide](docs/usage.md)** - Guia detalhado de uso dos playbooks

## 🔧 Features

### ✅ Implementado
- [x] Criação automatizada de VMs
- [x] Configuração via Cloud-Init
- [x] Validação de parâmetros
- [x] Configuração de rede automática
- [x] Gestão de chaves SSH
- [x] Documentação completa

### 🚧 Em Desenvolvimento
- [ ] Playbook de destruição de VMs
- [ ] Templates múltiplos (Ubuntu, CentOS)
- [ ] Configuração de cluster
- [ ] Backup automatizado
- [ ] Monitoramento com Prometheus

## 🛡️ Segurança

Este repositório está configurado para **não expor informações sensíveis**:
- IPs e credenciais ficam em arquivos locais (`.gitignore`)
- Exemplos genéricos para referência
- Chaves SSH gerenciadas localmente

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor:
1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Contato

**Frederyck** – [LinkedIn](https://www.linkedin.com/in/frederyck-baleeiro-espinheiro-sales-4836b4125) – [GitHub](https://github.com/frederycksales)

---
⭐ **Star este repositório se foi útil para você!**
