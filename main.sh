#!/bin/bash

function commit_git {
    git config --global user.email 'bot@example.com'
    git config --global user.name "$1"

    git commit -am "$2"
    git push
}

function format_python {
    git diff --name-only HEAD^..HEAD
    FILES=$(git diff --name-only HEAD^..HEAD | grep \.py$)
    if [[ ! -z "$FILES" ]]; then 
        isort $FILES
        black $FILES
        if ! git diff-index --quiet HEAD --; then
            commit_git "Python Formatting Bot" ":snake:	Python Formatting :snake:"
        fi
        mypy $FILES --ignore-missing-imports --strict --install-types --non-interactive --pretty --python-version 3.7 --junit-xml "/action/mypy.xml"
        pylint $FILES --enable spelling --spelling-dict en_GB --rcfile="/action/.pylintrc" > "/action/pylint.txt"
        
        python "/action/comment_pr.py"
    fi
}

function main_script {
    cd repo
    git checkout $GITHUB_HEAD_REF
    format_python 
}

main_script