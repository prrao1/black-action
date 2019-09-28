#!/bin/bash
set -e

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

echo "## Initializing git repo..."
git init
echo "### Adding git remote..."
git remote add origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
echo "### git fetch..."
git fetch
echo "### Setting branch"
BRANCH=$(basename $GITHUB_REF)
echo "### Branch: $BRANCH"
git checkout $BRANCH

echo "## Login into git..."
git config --global user.email "black_code_formatter@gmail.com"
git config --global user.name "Black Code Formatter"

# echo "## Installing Black"
# pip install black
echo "## Running Black Code Formatter"
black $BLACK_ARGS

echo "## Staging changes..."
git add .
echo "## Commiting files..."
git commit -m "Formatted code" || true
echo "## Pushing to $BRANCH"
git push -u origin $BRANCH
