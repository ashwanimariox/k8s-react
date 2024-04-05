#!/bin/bash

set -e

echo "Deployment Started"

# Check if NVM is installed
if ! command -v nvm &> /dev/null; then
    echo "NVM is not installed, installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    # Source NVM script
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
    echo "NVM is already installed"
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Node.js is not installed"
    echo "Installing Node.js version 20"
    
    # Install Node.js version 20 using NVM
    nvm install 20
else
    echo "Node.js is already installed"
fi

# git branch=$(git rev-parse --abbrev-ref HEAD)
branch=$(git symbolic-ref --short HEAD)

if [ "$branch" == "staging" ]; then
    project_dir=~/staging
elif [ "$branch" == "main" ]; then
    project_dir=~/project
else
    echo "Branch not found."
    exit 1
fi

if [ ! -d "$project_dir" ]; then
    echo "Project Directory is not found. Please check once."
    exit 1
fi

cd "$project_dir"

git pull origin "$branch"

if [ ! -f package.json ]; then
    echo "package.json is not available in this directory, Please ensure that you have correct Directory Access"
    exit 1
else
    echo "package.json is available now we are installing npm, Please wait!"
    npm install
fi

if [ ! -f "package.json" ]; then
    echo "Please ensure that you have package.json in your project"
    exit 1
else
    echo "We have found package.json file available in your project directory. We are going to execute command for running project npm run start"
    npm run start
fi

echo "Deployment successfully done"
echo "Thank you Developer"
