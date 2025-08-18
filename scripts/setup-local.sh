#!/bin/bash

# Script simples para configurar ambiente local
# Uso: ./scripts/setup-local.sh

echo "🔧 Configurando ambiente local..."

# Criar inventory.ini se não existir
if [ ! -f "inventory.ini" ]; then
    echo "📝 Criando inventory.ini..."
    cp examples/inventory.ini.example inventory.ini
    echo "✏️  EDITE o arquivo inventory.ini com o IP do seu Proxmox!"
else
    echo "✅ inventory.ini já existe"
fi

# Criar vars/local.yml se não existir
if [ ! -f "vars/local.yml" ]; then
    echo "📝 Criando vars/local.yml..."
    cat > vars/local.yml << 'EOF'
# Configurações específicas do seu ambiente
# Este arquivo é ignorado pelo Git (.gitignore)

# Substitua pelos valores do seu ambiente
network:
  subnet: "192.168.50"          # Seus primeiros 3 octetos
  gateway: "192.168.50.1"       # Seu gateway
  dns: "192.168.50.1"           # Seu DNS

# Template ID do seu Proxmox
default_template_id: 301        # Ajuste conforme seu template

# Caminho para sua chave SSH
ssh:
  key_path: "~/.ssh/id_rsa.pub" # Caminho para sua chave pública
EOF
    echo "✏️  EDITE o arquivo vars/local.yml com suas configurações!"
else
    echo "✅ vars/local.yml já existe"
fi

# Verificar se chave SSH existe
if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
    echo "⚠️  Chave SSH não encontrada!"
    echo "   Execute: ssh-keygen -t rsa -b 4096"
fi

echo ""
echo "✅ Setup local concluído!"
echo ""
echo "📋 Próximos passos:"
echo "   1. Editar inventory.ini com IP do seu Proxmox"
echo "   2. Editar vars/local.yml se necessário"
echo "   3. Executar: ./scripts/check-setup.sh"
