LATEST_COMMIT_MSG=$(git show -s --format='%s')

git config --global user.name 'BaiJiangJie'
git config --global user.email 'jiangjie.bai@fit2cloud.com'

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
        git switch -c pr@dev@translate_readmex
        git push origin -f -v pr@dev@translate_readmex 
    fi
fi
