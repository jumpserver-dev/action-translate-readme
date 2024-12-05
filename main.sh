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
  if git rev-parse --verify "${PUSH_BRANCH}" >/dev/null 2>&1; then
    echo "Branch ${PUSH_BRANCH} already exists. Switching to it..."
    git switch "${PUSH_BRANCH}"
  else
    echo "Branch ${PUSH_BRANCH} does not exist. Creating it..."
    git switch -c "${PUSH_BRANCH}"
  fi
}

function commit_push_github() {
  git add .
  git commit -m "Auto-translate README"
  echo "Pushing to branch ${PUSH_BRANCH}..."
  git push origin -f -v "${PUSH_BRANCH}"
}

function translate() {
  # 添加 github 认证
  add_remote_github
  cp /translation.py ./
  python translation.py
  rm -rf translation.py
  commit_push_github
}

translate
