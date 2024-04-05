#!/bin/bash

set -e

echo "Deployment Started"

git branch=$(git rev-parse --abbrev-ref HEAD)

if [ "$branch" == "staging" ]; then
     project_dir=~/staging
elif [ "$branch" == "main" ]; then
     project_dir=~/production
else
     echo "Branch not found."
     exit 1
fi

if [ ! -d "$project_dir" ]; then
     echo "Project Directory is not found Please check once"
     exit 1
fi

cd "$project_dir"

git pull origin "$branch"

if [ ! -f composer.json ]; then
    echo "composer.json is not available in this directory, Please ensure that you have correct Directory Access"
    exit 1
else
     echo "Composer.json is available now we are installing npm ,Please wait!"
     npm i
fi

if [ ! -f "composer.json" ]; then
     echo "Please ensure that you have composer.json in your project"
     exit 1
else
    echo "We have found composer.json file available in your project directory. We are going to execute command for running project npm run start"
    npm run start
fi

echo "Deployment successfully done"
echo "Thank you Developer"
