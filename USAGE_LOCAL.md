# Como Usar Este Projeto Localmente

## 🚀 Setup Rápido

1. **Configure ambiente local:**
   ```bash
   ./scripts/setup-local.sh
   ```

2. **Edite suas configurações:**
   ```bash
   nano inventory.ini      # Coloque o IP do seu Proxmox
   nano vars/local.yml     # Ajuste se necessário
   ```

3. **Teste a configuração:**
   ```bash
   ./scripts/check-setup.sh
   ```

4. **Use os playbooks:**
   ```bash
   # Criar VM com Cloud-Init (recomendado)
   ./scripts/run-playbook.sh cloud-init

   # Criar VM básica
   ./scripts/run-playbook.sh basic

   # Testar antes de executar (dry-run)
   ./scripts/run-playbook.sh cloud-init check
   ```

## 🔒 Segurança

- ✅ Arquivos `inventory.ini` e `vars/local.yml` são **ignorados pelo Git**
- ✅ Suas configurações ficam **apenas local**
- ✅ Repositório público **não expõe dados sensíveis**

## 📁 Arquivos Importantes

- `inventory.ini` - Seu IP do Proxmox (local, ignorado)
- `vars/local.yml` - Suas configurações (local, ignorado)
- `examples/inventory.ini.example` - Template público
