#!/bin/bash

# Script para criar uma nova VM Debian a partir de um template no Proxmox

# --- Variáveis (ajuste conforme seu ambiente) ---
TEMPLATE_ID=301 # ID da VM Template
STORAGE_TARGET=local-lvm # Onde a nova VM será armazenada

# --- Coleta de Informações ---
read -p "Digite o ID para a nova VM: " VM_ID
read -p "Digite o nome (hostname) para a nova VM: " VM_NAME
read -p "Digite o tamanho do disco em GB (ex: 50): " DISK_SIZE
read -p "Digite a quantidade de memória em MB (ex: 4096): " MEMORY
read -p "Digite o número de cores de CPU (ex: 2): " CORES

echo "---"
echo "Resumo da Nova VM:"
echo "ID: $VM_ID"
echo "Nome: $VM_NAME"
echo "Template Base: $TEMPLATE_ID"
echo "Disco: ${DISK_SIZE}G"
echo "Memória: ${MEMORY}MB"
echo "CPU Cores: $CORES"
echo "---"
read -p "As informações estão corretas? (s/n): " CONFIRM

if [ "$CONFIRM" != "s" ]; then
    echo "Operação cancelada."
    exit 1
fi

# --- Execução dos Comandos Proxmox ---
echo "Clonando o template $TEMPLATE_ID para a nova VM $VM_ID..."
qm clone $TEMPLATE_ID $VM_ID --name $VM_NAME --full

echo "Configurando a nova VM..."
qm resize $VM_ID scsi0 ${DISK_SIZE}G
qm set $VM_ID --memory $MEMORY
qm set $VM_ID --cores $CORES

# Configuração de rede: IP, gateway e DNS
VM_IP="192.168.50.$VM_ID/24"
GATEWAY="192.168.50.1"
DNS="192.168.50.1"
qm set $VM_ID --ipconfig0 ip=${VM_IP},gw=${GATEWAY}
qm set $VM_ID --nameserver ${DNS}

echo "---"
echo "VM $VM_NAME (ID: $VM_ID) criada com sucesso!"
echo "---"