#!/bin/bash
source validation.sh
source cloneBranches.sh

# Define color codes and log file
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color
LOG_FILE="cloneRepos.log"

# Function to log messages
log() {
    echo -e "[$(date +"%Y-%m-%d %T")] $1" | tee -a $LOG_FILE
}

# Set variables
# Replace these with your organization, project, and Azure DevOps base URL
organization="YOUR_ORGANIZATION"
project="YOUR_PROJECT"
azure_devops_url="YOUR_AZURE_DEVOPS_URL"
pat=$1

# Check if PAT is provided
if [ -z "$pat" ]; then
    log "${RED}Error: Personal Access Token (PAT) not provided.${NC}"
    exit 1
fi

# Call the validation function to check if API call has good response
validate_api $pat || {
    log "${RED}API validation failed. Exiting script.${NC}"
    exit 1
}

# Encode PAT
encodedPat=$(printf "%s"":$pat" | base64)

# Define API URL to list repositories
apiUrl="$azure_devops_url/$organization/$project/_apis/git/repositories?api-version=6.0"

log "${GREEN}Fetching list of repositories...${NC}"

# Make API request to get list of repositories
response=$(curl -s -X GET -H "Authorization: Basic $encodedPat" -H "Content-Type: application/json" $apiUrl)
if [ $? -ne 0 ]; then
    log "${RED}Failed to fetch repositories from API.${NC}"
    exit 1
fi

# Parse and print repository names using jq
repos=$(echo $response | jq -r '.value[] | .name')
if [ -z "$repos" ]; then
    log "${RED}No repositories found or unable to fetch repositories.${NC}"
    exit 1
fi

# Save current IFS
OLDIFS=$IFS
# Set IFS to newline for iteration
IFS=$'\n'

log "${GREEN}Repositories found in project $project:${NC}"

# Iterate over each repository name and clone
for repo in $repos
do
    log "${YELLOW}Processing repository: $repo${NC}"
  
    if [ -d "$repo" ] && [ -d "$repo/.git" ]; then
        log "${GREEN}Updating repository: $repo${NC}"
        cd $repo
        git pull || log "${RED}Failed to pull updates for $repo.${NC}"
        clone_remote_branches
        git branch -a
        cd ../
    else
        log "${GREEN}Cloning repository: $repo${NC}"
        git clone "ssh://$azure_devops_url:22/$organization/$project/_git/$repo" || log "${RED}Failed to clone $repo.${NC}"
        cd $repo
        clone_remote_branches
        git branch -a
        cd ../
    fi  
done

# Restore IFS
IFS=$OLDIFS

log "${GREEN}All repositories processed successfully.${NC}"
