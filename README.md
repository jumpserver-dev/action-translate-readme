# Translate github README.md to other languages

Set up your repository workflow such as:
```
name: Translate README
on:
  workflow_dispatch:
    inputs:
      target_langs:
        description: "Target Languages"
        required: false
        default: "zh-hans,zh-hant,ja,pt-br"
      gen_dir_path:
        description: "Generate Dir Name"
        required: false
        default: "readmes/"
      push_branch:
        description: "Push Branch"
        required: false
        default: "pr@dev@translate_readme"
      prompt:
        description: "AI Translate prompt"
        required: false
        default: "Do not translate any content under the ‘## License’ section.\n"
        
      gpt_mode:
        description: "GPT Mode"
        required: false
        default: "gpt-4o-mini"

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Auto Translate
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