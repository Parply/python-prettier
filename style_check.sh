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
            git push --force github HEAD:$GITHUB_HEAD_REF
        fi

        COMMENT_MYPY=$(mypy $FILES --ignore-missing-imports --strict --install-types --non-interactive --pretty --python-version 3.7)
        COMMENT_PYLINT=$(pylint $FILES  --rcfile=./.pylintrc)

        COMMENT_MAGIC_HEADER="Formatter"
        MESSAGE="<summary> <b> PEP8 Standard Report </b></summary> \n $COMMENT_PYLINT \n <summary> <b> Typing Report </b></summary> \n $COMMENT_MYPY"
        
        curl --retry 1 -H "Authorization: Token $GITHUB_TOKEN" -X POST -d '{ "body": "$MESSAGE", "start_line": 1, "start_side":"left"}' \
        "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/issues/${PR_NUMBER}/comments"      
    fi
}

### RUN ###

format