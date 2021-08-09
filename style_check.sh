#!/bin/bash

function format {
    git checkout $GITHUB_HEAD_REF
    FILES=$(git diff --name-only HEAD^..HEAD | grep \.py$)
    if [[ ! -z "$FILES" ]]; then 
        isort $FILES
        black $FILES
        if ! git diff-index --quiet HEAD --; then
            #git remote add github "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
            #ORIGIN = "https://$GITHUB_ACTOR:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git"
            git config --global user.email 'bot@example.com'
            git config --global user.name 'Python Formatting Bot'
            #git remote set-url origin "https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY"
            git commit -am 'Formatting'
            git push #$ORIGIN HEAD:$GITHUB_HEAD_REF
        fi
        mypy $FILES --ignore-missing-imports --strict --install-types --non-interactive --pretty --python-version 3.7 --junit-xml /mypy.xml
        #COMMENT_MYPY=$(sed -n '/^#/,/#$/ {<failure message=\"mypy produced messages\">/#//;</failure>;}' mypy.xml)
        pylint $FILES --enable spelling --spelling-dict en_GB --rcfile=./.pylintrc > /pylint.txt

        MESSAGE="<summary> <b> PEP8 Standard Report </b></summary> \n $COMMENT_PYLINT \n <summary> <b> Typing Report </b></summary> \n"
        #PAYLOAD=$(echo '{}' | jq --arg body "$MESSAGE" '.body = $body')
        #COMMENTS_URL=$(cat /github/workflow/event.json | jq -r .pull_request.comments_url)

        echo $MESSAGE
        echo $GH_TOKEN
        
        python ./comment_pr.py --pylint $MESSAGE
    fi
}

### RUN ###

format