#!/bin/bash

clone_remote_branches() {
  branches=$(git branch -r | grep -v 'HEAD' | sed 's/origin\///' | sed 's/^ *//') # Trim leading spaces
  
  YELLOW='\033[1;33m'
  NC='\033[0m' # No Color

  for branch in $branches; do
    if ! git show-ref --quiet "refs/heads/$branch"; then
      git checkout -b "$branch" "origin/$branch"
      git pull origin "$branch"
      echo -e "${YELLOW}Updated branch: $branch${NC}"
    else
      git checkout "$branch"
      git pull origin "$branch"
      echo -e "${YELLOW}Branch '$branch' updated.${NC}"
    fi
  done

  echo -e "${YELLOW}All remote branches cloned and updated successfully.${NC}"
}
