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

  if git ls-remote --heads origin | grep -q "refs/heads/$PUSH_BRANCH"; then
    echo "Remote branch '$PUSH_BRANCH' exists. Creating and tracking locally..."
    # 创建本地分支并跟踪远程分支
    git checkout -b "$PUSH_BRANCH" origin/"$PUSH_BRANCH"
  else
    echo "Remote branch '$PUSH_BRANCH' does not exist. Creating a new local branch..."
    # 创建一个新的本地分支
    git checkout -b "$PUSH_BRANCH"
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
