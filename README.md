# Azure DevOps Repositories Clone & Update Script

This collection of Bash scripts is designed for efficiently managing the cloning and updating of all repositories and their branches from a specified Azure DevOps project. The main script (`cloneAllRepos.sh`) automates the fetching of repository lists and ensures each repository is cloned or updated. The auxiliary scripts (`cloneBranches.sh` and `validation.sh`) handle the cloning of all branches within each repository and validate API responses, respectively.

## Features

- **Automated Cloning & Updating**: Clones new repositories and updates existing ones from the specified Azure DevOps project.
- **Comprehensive Logging**: Includes detailed logging of all operations, aiding in troubleshooting and tracking script execution.
- **Error Handling**: Robust error handling to ensure reliable script execution.
- **Color-Coded Output**: Enhances readability of the output, making it easier to follow the script's progress.

## `cloneBranches.sh`

This script contains the `clone_remote_branches` function, which clones all branches from the remote repository. If a branch already exists locally, it updates it to match the remote version. This script is sourced and used in `cloneAllRepos.sh` to ensure that not only the repositories are cloned or updated, but also all their branches.

### Key Functions

- **Cloning Remote Branches**: Efficiently clones each branch that doesn't exist locally.
- **Updating Existing Branches**: Checks out and updates each branch that already exists locally.
- **Color-Coded Branch Processing Output**: Provides clear, visually distinct feedback on the process of each branch.

## `validation.sh`

This script is responsible for validating the API call to Azure DevOps. It checks if the API call to fetch the list of repositories is successful. If the call fails, it outputs an error message and terminates the script, preventing any further actions on invalid or error responses.

### Key Functions

- **API Call Validation**: Ensures the API call is successful before proceeding.
- **Error Handling**: Provides clear error messages and stops script execution on API call failure.

## Prerequisites

- Bash environment
- `curl` and `jq` for API requests and JSON parsing
- `git` for cloning and updating repositories

## Usage

1. Ensure all prerequisites are installed.
2. Clone this repository or copy the script files to your machine.
3. Make the script executable: `chmod +x cloneAllRepos.sh`.
4. Execute the script with a Personal Access Token as an argument: `./cloneAllRepos.sh <PAT>`.
