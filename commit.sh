LATEST_COMMIT_MSG=$(git show -s --format='%s')

git add -N .

dir_files=$(ls)
changed_files=$(git diff --name-only)
current_branch=$(git branch --show-current)

echo "Current branch $current_branch"
echo "You auto changed $changed_files"

if [[ $changed_files =~ "readmes/README" ]]; then
    if [[ "$LATEST_COMMIT_MSG" != "Auto-translate README" ]]; then
        echo "Commit..."
        git add $(git diff --name-only)
        git commit -m "Auto-translate README"
        git push origin dev:pr@dev@translate_readme
    fi
fi
