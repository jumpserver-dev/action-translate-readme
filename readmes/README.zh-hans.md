# 将 github README.md 翻译成其他语言

设置您的代码库工作流，如下所示：
```
name: 翻译 README
on:
  workflow_dispatch:
    inputs:
      target_langs:
        description: "目标语言"
        required: false
        default: "zh-hans,zh-hant,ja,pt-br"
      gen_dir_path:
        description: "生成目录名称"
        required: false
        default: "readmes/"
      push_branch:
        description: "推送分支"
        required: false
        default: "pr@dev@translate_readme"
      prompt:
        description: "AI 翻译提示"
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
      - name: 自动翻译
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