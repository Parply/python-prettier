#!/bin/bash

function format {
    FILES=$(git diff --name-only HEAD^..HEAD | grep \.py$)
    if [[ ! -z "$FILES" ]]; then 
        isort $FILES
        black $FILES
        if ! git diff-index --quiet HEAD --; then
            git remote add github "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
            git config --global user.email 'bot@example.com'
            git config --global user.name 'Python Formatting Bot'
            git commit -am 'Formatting'
            git push github HEAD:$GITHUB_HEAD_REF
        fi

        if [ "$COMMENT" = "true" ]; then
            mypy $FILES --ignore-missing-imports --strict --install-types --non-interactive --pretty --python-version 3.7 > mypy_report.txt
            pylint $FILES  --rcfile=./pylintrc > pylint_report.txt
            COMMENT_MYPY=$(cat mypy_report.txt)
            COMMENT_PYLINT=$(cat pylint_report.txt)
            curl -X POST $URL -H "Content-Type: application/json" -H "Authorization: token $GITHUB_TOKEN" --data "{ 'body': '<summary> <b> PEP8 Standard Report </b></summary> \n $COMMENT_PYLINT \n <summary> <b> Typing Report </b></summary> \n $COMMENT_MYPY' }"
        fi
    fi
}

### RUN ###

format