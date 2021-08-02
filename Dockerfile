FROM python:3.7-buster

ADD requirements.txt /requirements.txt
ADD style_check.sh /style_check.sh
ADD .pylintrc /.pylintrc
ADD comment_pr.py /comment_pr.py
RUN apt update -y && apt install -y jq hunspell-en-gb enchant
RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash","./style_check.sh"]