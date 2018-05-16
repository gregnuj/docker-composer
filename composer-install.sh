#!/bin/sh -e

# Enable debugging
if [ ! -z "$DEBUG" ]; then
    set -x
fi

export WORKDIR="$(readlink -f .)"

## install project with git
if [ "$PROJECT_VCS_METHOD" = git ]; then
    if [ -n "$PROJECT_VCS_URL" ]; then
        if [ ! "$(ls -A ${WORKDIR})" ]; then
            git clone -b "$PROJECT_VCS_BRANCH" "$PROJECT_VCS_URL" "$(readlink -f .)"
        else
            git stash save "container restart $(date +"%F_%T")"
            git pull
        fi
        if [ -f "./composer.json" ]; then
            composer install --ignore-platform-reqs
        fi
    fi

## install project with composer
elif [ "$PROJECT_VCS_METHOD" = composer ]; then
    if [ ! -z "$PROJECT_NAME" ]; then
        if [ ! "$(ls -A ${WORKDIR})" ]; then
            /usr/bin/composer create-project \
                --stability=dev \
                --prefer-source \
                --no-interaction \
                --keep-vcs \
                $PROJECT_REPO/$PROJECT_NAME:dev-$PROJECT_VCS_BRANCH "$(readlink -f ..)"
        elif [ -f "./composer.json" ]; then
            composer install --ignore-platform-reqs
        fi
    fi
fi

