FROM node:latest AS SQL_FORMAT
ADD functions.sh /functions.sh
ADD sql_check.sh /sql_check.sh
RUN npm install --global poor-mans-t-sql-formatter-cli
ENTRYPOINT ["/bin/bash","./sql_check.sh"]

FROM python:3.7-buster AS PYTHON_FORMAT
ADD requirements.txt /requirements.txt
ADD functions.sh /functions.sh
ADD python_check.sh /python_check.sh
ADD .pylintrc /.pylintrc
ADD comment_pr.py /comment_pr.py
RUN apt update -y && apt install -y jq hunspell-en-gb enchant
RUN export INSTALL_ON_LINUX=1; pip install -r requirements.txt
ENTRYPOINT ["/bin/bash","./python_check.sh"]