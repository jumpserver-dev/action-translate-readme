#!/bin/bash
# GITHUB_TOKEN
# GITHUB_REPOSITORY
# OPENAI_API_KEY
# GPT_MODE
# TARGET_LANGUAGES
# PUSH_BRANCH
# PROMPT
# GEN_DIR_PATH


PUSH_BRANCH=${PUSH_BRANCH:-pr@dev@translate_readme}
GEN_DIR_PATH=${GEN_DIR_PATH:-readmes/}

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
  
  # 检查更改文件是否匹配 GEN_DIR_PATH
  changed_files=$(git diff --name-only | grep -E "^${GEN_DIR_PATH}")

  if [[ -n "$changed_files" ]]; then
      echo "Detected changes in files: $changed_files"
      
      if [[ "$LATEST_COMMIT_MSG" != "Auto-translate README" ]]; then
          echo "Staging changes..."
          echo "$changed_files" | xargs git add

          echo "Committing changes..."
          git commit -m "Auto-translate README"
          
          # 确保分支存在，或删除并切换到新分支
          if git rev-parse --verify "${PUSH_BRANCH}" >/dev/null 2>&1; then
              echo "Branch ${PUSH_BRANCH} already exists. Deleting and recreating..."
              git branch -D "${PUSH_BRANCH}" # 删除本地分支
          fi
          git switch -c "${PUSH_BRANCH}"

          # 推送到远程分支
          echo "Pushing to branch ${PUSH_BRANCH}..."
          git push origin -f -v "${PUSH_BRANCH}"
      else
          echo "No commit made: latest commit message matches expected message."
      fi
  else
      echo "No changes detected in ${GEN_DIR_PATH}. Skipping commit."
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
