# README.md を他の言語に翻訳する

リポジトリのワークフローを設定します：
```
name: README を翻訳
on:
  workflow_dispatch:
    inputs:
      target_langs:
        description: "ターゲット言語"
        required: false
        default: "zh-hans,zh-hant,ja,pt-br"
      gen_dir_path:
        description: "生成ディレクトリ名"
        required: false
        default: "readmes/"
      push_branch:
        description: "プッシュブランチ"
        required: false
        default: "pr@dev@translate_readme"
      prompt:
        description: "AI 翻訳プロンプト"
        required: false
        default: ""
        
      gpt_mode:
        description: "GPT モード"
        required: false
        default: "gpt-4o-mini"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: 自動翻訳
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