#!/bin/bash
# GITHUB_TOKEN
# GITHUB_REPOSITORY
# OPENAI_API_KEY
# GPT_MODE
# TARGET_LANGUAGES

function add_remote_github() {
  # Clone仓库
  git config --global user.name "BaiJiangJie"
  git config --global user.email "jiangjie.bai@fit2cloud.com"
  remote_url="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}"
  rm -rf GITHUB_REPO
  git clone "${remote_url}" "GITHUB_REPO" && cd "GITHUB_REPO" || exit 2
  cp ../translation.py ./
  git status
  git fetch origin
  git remote -v
}

commit_push_github() {
  LATEST_COMMIT_MSG=$(git show -s --format='%s')
  
  git add -N .
  
  dir_files=$(ls)
  changed_files=$(git diff --name-only | grep "readmes/")
  current_branch=$(git branch --show-current)
  
  echo "Current branch $current_branch"
  echo "You auto changed $changed_files"
  
  if [[ $changed_files =~ "readmes/README" ]]; then
      if [[ "$LATEST_COMMIT_MSG" != "Auto-translate README" ]]; then
          echo "Commit..."
          git add $(git diff --name-only)
          git commit -m "Auto-translate README"
          git switch -c pr@dev@translate_readmex
          git push origin -f -v pr@dev@translate_readmex 
      fi
  fi
}

translate() {
  # 添加 github 认证
  add_remote_github
  python translation.py
  commit_push_github
}

translate
