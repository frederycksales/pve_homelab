#!/bin/bash

# Script auxiliar para criação de VMs no Proxmox
# Uso: ./scripts/create-vm.sh [cloud-init|basic] [check]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Verificar se está no diretório correto
if [[ ! -f "ansible.cfg" ]] || [[ ! -d "playbooks" ]]; then
    error "Execute este script a partir do diretório raiz do projeto"
    exit 1
fi

# Verificar se inventory existe
if [[ ! -f "inventory.ini" ]]; then
    error "Arquivo inventory.ini não encontrado!"
    echo "Execute: cp examples/inventory.ini.example inventory.ini"
    echo "E configure com o IP do seu Proxmox"
    exit 1
fi

# Verificar conectividade
log "Testando conectividade com Proxmox..."
if ! ansible -i inventory.ini proxmox -m ping > /dev/null 2>&1; then
    error "Falha na conectividade com Proxmox!"
    echo "Verifique:"
    echo "  - IP do Proxmox no inventory.ini"
    echo "  - Conectividade de rede"
    echo "  - Chaves SSH configuradas"
    exit 1
fi
success "Conectividade OK"

# Determinar tipo de playbook
PLAYBOOK_TYPE=${1:-cloud-init}
CHECK_MODE=${2}

case $PLAYBOOK_TYPE in
    "cloud-init")
        PLAYBOOK="playbooks/create-vm-cloudinit.yml"
        log "Usando playbook Cloud-Init (recomendado)"
        ;;
    "basic")
        PLAYBOOK="playbooks/create-vm.yml"
        warning "Usando playbook básico (sem Cloud-Init)"
        ;;
    *)
        error "Tipo inválido: $PLAYBOOK_TYPE"
        echo "Uso: $0 [cloud-init|basic] [check]"
        exit 1
        ;;
esac

# Verificar se playbook existe
if [[ ! -f "$PLAYBOOK" ]]; then
    error "Playbook não encontrado: $PLAYBOOK"
    exit 1
fi

# Preparar comando Ansible
ANSIBLE_CMD="ansible-playbook -i inventory.ini $PLAYBOOK"

# Adicionar check mode se solicitado
if [[ "$CHECK_MODE" == "check" ]]; then
    ANSIBLE_CMD="$ANSIBLE_CMD --check"
    warning "Executando em modo CHECK (dry-run)"
fi

# Executar playbook
log "Executando: $ANSIBLE_CMD"
echo "----------------------------------------"

if $ANSIBLE_CMD; then
    success "Playbook executado com sucesso!"
    
    if [[ "$CHECK_MODE" != "check" ]] && [[ "$PLAYBOOK_TYPE" == "cloud-init" ]]; then
        echo ""
        echo "🎉 VM criada com Cloud-Init!"
        echo "📝 Próximos passos:"
        echo "   1. Aguarde a VM terminar de inicializar"
        echo "   2. Teste a conexão SSH"
        echo "   3. Configure os serviços necessários"
    fi
else
    error "Falha na execução do playbook!"
    exit 1
fi
