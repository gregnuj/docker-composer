#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

export WORKDIR="$(readlink -f .)"

if [ ! "$(ls -A ${WORKDIR})" ]; then

## install project with composer
    if [ "$PROJECT_VCS_METHOD" = composer ]; then
        if [ ! -z "$PROJECT_NAME" ]; then
            /usr/bin/composer create-project \
                --stability=dev \
                --prefer-source \
                --no-interaction \
                --keep-vcs \
                $PROJECT_REPO/$PROJECT_NAME:dev-$PROJECT_VCS_BRANCH "$(readlink -f ..)"
        fi 
    
    ## install project with git
    elif [ -n "$PROJECT_VCS_URL" ]; then
        git clone -b "$PROJECT_VCS_BRANCH" "$PROJECT_VCS_URL" "$(readlink -f .)"
    fi
    if [ -f "./composer.json" ]; then
        composer update --ignore-platform-reqs
    fi
else
    git stash save "container restart $(date +"%F_%T")"
    git pull
    if [ -f "./composer.json" ]; then
        composer update --ignore-platform-reqs
    fi
fi
