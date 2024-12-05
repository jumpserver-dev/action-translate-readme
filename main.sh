#!/bin/bash
# GITHUB_TOKEN
# GITHUB_REPOSITORY
# OPENAI_API_KEY
# GPT_MODE
# TARGET_LANGUAGES
# PUSH_BRANCH
# PROMPT


PUSH_BRANCH=${PUSH_BRANCH:-pr@dev@translate_readme}

function add_remote_github() {
  # Clone仓库
  git config --global user.name "github-actions[bot]"
  git config --global user.email "github-actions[bot]@users.noreply.github.com"
  remote_url="https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}"
  rm -rf GITHUB_REPO
  git clone "${remote_url}" "GITHUB_REPO" && cd "GITHUB_REPO" || exit 2
  git status
  git fetch origin
  git remote -v
}

function commit_push_github() {
  LATEST_COMMIT_MSG=$(git show -s --format='%s')
  
  git add -N .
  
  dir_files=$(ls)
  changed_files=$(git diff --name-only | grep "readmes/")
  current_branch=$(git branch --show-current)
  
  echo "You auto changed $changed_files"
  
  if [[ $changed_files =~ "readmes/README" ]]; then
      if [[ "$LATEST_COMMIT_MSG" != "Auto-translate README" ]]; then
          echo "Commit..."
          git add "${changed_files}"
          git commit -m "Auto-translate README"
          git switch -c ${PUSH_BRANCH}
          git push origin -f -v ${PUSH_BRANCH} 
      fi
  fi
}

function translate() {
  # 添加 github 认证
  add_remote_github
  cp /translation.py ./
  python translation.py
  commit_push_github
}

translate
