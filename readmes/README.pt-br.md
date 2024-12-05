# Traduzir github README.md para outros idiomas

Configure o fluxo de trabalho do seu repositório da seguinte forma:
```
name: Traduzir README
on:
  workflow_dispatch:
    inputs:
      target_langs:
        description: "Idiomas Alvo"
        required: false
        default: "zh-hans,zh-hant,ja,pt-br"
      gen_dir_path:
        description: "Nome do Diretório Gerado"
        required: false
        default: "readmes/"
      push_branch:
        description: "Ramo para Push"
        required: false
        default: "pr@dev@translate_readme"
      prompt:
        description: "Prompt para Tradução da IA"
        required: false
        default: ""
        
      gpt_mode:
        description: "Modo GPT"
        required: false
        default: "gpt-4o-mini"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Tradução Automática
        uses: BaiJiangJie/translate-readme@main
        env:
          GITHUB_TOKEN: ${{ secrets.PRIVATE_TOKEN }}
          OPENAI_API_KEY: ${{ secrets.GPT_API_TOKEN }}
          GPT_MODE: ${{ github.event.inputs.gpt_mode }}
          TARGET_LANGUAGES: ${{ github.event.inputs.target_langs }}
          PUSH_BRANCH: ${{ github.event.inputs.push_branch }}
          GEN_DIR_PATH: ${{ github.event.inputs.gen_dir_path }}
          PROMPT: ${{ github.event.inputs.prompt }}
```