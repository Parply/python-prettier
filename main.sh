#!/bin/bash

function commit_git {
    git config --global user.email 'bot@example.com'
    git config --global user.name "$1"

    git commit -am "$2"
    git push
}

function format_sql {
    FILES=$(git diff --name-only HEAD^..HEAD | grep \.sql$)
    if [[ ! -z "$FILES" ]]; then 
        echo $FILES | xargs -n 1 -P 8 - I sqlformat -f {} -g {}
        if ! git diff-index --quiet HEAD --; then
            commit_git "SQL Formatting Bot" ":whale: SQL Formatting :whale:"
        fi
    fi
}

function format_python {
    FILES=$(git diff --name-only HEAD^..HEAD | grep \.py$)
    if [[ ! -z "$FILES" ]]; then 
        isort $FILES
        black $FILES
        if ! git diff-index --quiet HEAD --; then
            commit_git "Python Formatting Bot" ":snake:	Python Formatting :snake:"
        fi
        mypy $FILES --ignore-missing-imports --strict --install-types --non-interactive --pretty --python-version 3.7 --junit-xml /mypy.xml
        pylint $FILES --enable spelling --spelling-dict en_GB --rcfile=./.pylintrc > /pylint.txt
        
        python ./comment_pr.py
    fi
}

git checkout $GITHUB_HEAD_REF
echo $PWD
format_sql
format_python