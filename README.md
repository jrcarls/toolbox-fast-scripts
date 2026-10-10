# Toolbox Scripts

Coleção de scripts para inicializar projetos com stacks pré-configuradas.

## Como usar

Cada pasta contém o script de setup e um README com os detalhes da stack. Para
disponibilizar o setup Django como um comando global, execute uma vez na raiz
deste repositório:

```bash
bash django/install.sh
```

Depois, execute o comando a partir do diretório onde o projeto deve ser criado:

```bash
cd ~/Projects
setup-django meu_projeto
```

O exemplo cria o projeto em `~/Projects/meu_projeto`. Consulte a
[documentação do setup Django](django/README_setup_django.md) para os
pré-requisitos, uso sem instalação global e solução de problemas.

## Scripts disponíveis

| Script | Tecnologia | Descrição |
|---|---|---|
| [Setup Django](django/README_setup_django.md) | Python / Django | Inicializa projeto Django com uv, HTMX, Alpine.js, Tailwind + Flowbite e autenticação |
