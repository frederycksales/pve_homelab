#!/bin/bash

# Script de verificação da configuração do ambiente
# Uso: ./scripts/check-setup.sh

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Contadores
CHECKS_PASSED=0
CHECKS_FAILED=0

# Função para verificações
check() {
    local description="$1"
    local command="$2"
    local suggestion="$3"
    
    echo -n "Verificando $description... "
    
    if eval "$command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
        ((CHECKS_PASSED++))
    else
        echo -e "${RED}✗${NC}"
        if [[ -n "$suggestion" ]]; then
            echo -e "  ${YELLOW}Sugestão:${NC} $suggestion"
        fi
        ((CHECKS_FAILED++))
    fi
}

echo -e "${BLUE}=== Verificação do Ambiente PVE Home Lab ===${NC}\n"

# Verificações básicas
check "Ansible instalado" "which ansible" "sudo apt install ansible"
check "Python 3 disponível" "which python3" "sudo apt install python3"
check "SSH cliente disponível" "which ssh" "sudo apt install openssh-client"
check "Git disponível" "which git" "sudo apt install git"

echo ""

# Verificações de estrutura do projeto
check "Diretório raiz do projeto" "test -f ansible.cfg && test -d playbooks" "Execute a partir do diretório raiz do projeto"
check "Arquivo inventory.ini existe" "test -f inventory.ini" "cp examples/inventory.ini.example inventory.ini"
check "Playbooks existem" "test -f playbooks/create-vm-cloudinit.yml && test -f playbooks/create-vm.yml" "Verifique se os playbooks estão no lugar correto"
check "Variáveis padrão existem" "test -f vars/defaults.yml" "Verifique se o arquivo vars/defaults.yml existe"

echo ""

# Verificações de configuração
if [[ -f "inventory.ini" ]]; then
    check "Inventory não é o exemplo" "! grep -q 'YOUR_PROXMOX_IP' inventory.ini" "Configure o IP real do Proxmox no inventory.ini"
fi

check "Chave SSH pública existe" "test -f ~/.ssh/id_rsa.pub" "ssh-keygen -t rsa -b 4096"

echo ""

# Verificações de conectividade (se inventory configurado)
if [[ -f "inventory.ini" ]] && ! grep -q 'YOUR_PROXMOX_IP' inventory.ini 2>/dev/null; then
    echo -e "${BLUE}Testando conectividade...${NC}"
    check "Ping para o Proxmox" "ansible -i inventory.ini proxmox -m ping" "Verifique IP, SSH e credenciais"
    
    if [[ $CHECKS_FAILED -eq 0 ]]; then
        check "Comando PVE disponível" "ansible -i inventory.ini proxmox -m command -a 'pveversion'" "Verifique se o Proxmox está instalado corretamente"
    fi
else
    echo -e "${YELLOW}Pulando testes de conectividade (inventory não configurado)${NC}"
fi

echo ""

# Relatório final
echo -e "${BLUE}=== Relatório Final ===${NC}"
echo -e "Verificações passaram: ${GREEN}$CHECKS_PASSED${NC}"
echo -e "Verificações falharam: ${RED}$CHECKS_FAILED${NC}"

if [[ $CHECKS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}🎉 Ambiente configurado corretamente!${NC}"
    echo -e "${GREEN}Você pode executar os playbooks agora.${NC}"
    echo ""
    echo "Comandos úteis:"
    echo "  ./scripts/run-playbook.sh cloud-init    # Criar VM com Cloud-Init"
    echo "  ./scripts/run-playbook.sh basic         # Criar VM básica"
    echo "  ./scripts/run-playbook.sh cloud-init check  # Dry-run"
    exit 0
else
    echo -e "\n${RED}❌ Ambiente não está completamente configurado.${NC}"
    echo -e "${YELLOW}Resolva os problemas acima antes de continuar.${NC}"
    exit 1
fi
