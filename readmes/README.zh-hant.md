# 將 github README.md 翻譯成其他語言

設置您的倉庫工作流程，例如：
```
name: 翻譯 README
on:
  workflow_dispatch:
    inputs:
      target_langs:
        description: "目標語言"
        required: false
        default: "zh-hans,zh-hant,ja,pt-br"
      gen_dir_path:
        description: "生成目錄名稱"
        required: false
        default: "readmes/"
      push_branch:
        description: "推送分支"
        required: false
        default: "pr@dev@translate_readme"
      prompt:
        description: "AI 翻譯提示"
        required: false
        default: ""
        
      gpt_mode:
        description: "GPT 模式"
        required: false
        default: "gpt-4o-mini"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: 自動翻譯
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