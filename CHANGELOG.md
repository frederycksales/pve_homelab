# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/lang/pt-BR/spec/v2.0.0.html).

## [1.0.0] - 2025-08-17

### Adicionado
- Estrutura organizada do projeto com diretórios dedicados
- Playbook `create-vm-cloudinit.yml` com Cloud-Init completo
- Playbook `create-vm.yml` para criação básica de VMs
- Sistema de validação de parâmetros de entrada
- Configuração de rede automática baseada em variáveis
- Gestão de chaves SSH com arquivo temporário
- Documentação completa (Setup e Usage Guide)
- Arquivo `.gitignore` para proteção de dados sensíveis
- Arquivo `defaults.yml` para configurações centralizadas
- Script auxiliar `run-playbook.sh` para execução facilitada
- Arquivo `ansible.cfg` com configurações otimizadas
- Licença MIT
- README.md profissional para portfólio

### Características
- ✅ Criação automatizada de VMs
- ✅ Configuração via Cloud-Init
- ✅ Validação de parâmetros (ID, Memória, CPU, Disco)
- ✅ Configuração de rede automática
- ✅ Gestão segura de chaves SSH
- ✅ Verificação de conectividade SSH
- ✅ Documentação completa
- ✅ Estrutura segura para GitHub

### Segurança
- Proteção de informações sensíveis via `.gitignore`
- Arquivo de exemplo `inventory.ini.example`
- Gestão segura de chaves SSH
- Validação de entrada de dados

### Documentação
- Guia de configuração detalhado (`docs/setup.md`)
- Guia de uso com exemplos (`docs/usage.md`)
- README.md com arquitetura e quick start
- Comentários explicativos nos playbooks

## [Unreleased]

### Planejado
- [ ] Playbook para destruição de VMs
- [ ] Suporte a múltiplos templates (Ubuntu, CentOS)
- [ ] Configuração de cluster Proxmox
- [ ] Backup automatizado de VMs
- [ ] Monitoramento com Prometheus/Grafana
- [ ] Integração com Terraform
- [ ] Testes automatizados com Molecule
