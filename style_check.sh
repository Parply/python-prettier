#!/bin/bash

function get_files {
    git diff --name-only HEAD^..HEAD | grep '*.py' | echo
}

function format {
    FILES = get_files
    isort $FILES
    black $FILES
    if ! git diff-files --quiet; then
        git commit -am 'Formatting'
        git push
    fi

    if $COMMENT; then
        mypy $FILES --ignore-missing-imports --strict --install-types --non-interactive --pretty --python-version 3.7 > mypy_report.txt
        pylint $FILES  --rcfile=./pylintrc > pylint_report.txt
        COMMENT_MYPY = $(cat mypy_report.txt)
        COMMENT_PYLINT = $(cat pylint_report.txt)
        curl -X POST $URL -H "Content-Type: application/json" -H "Authorization: token $GITHUB_TOKEN" --data "{ 'body': '<summary> <b> PEP8 Standard Report </b></summary> \n $COMMENT_PYLINT \n <summary> <b> Typing Report </b></summary> \n $COMMENT_MYPY' }"
    fi
}

### RUN ###

format