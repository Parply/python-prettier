FROM python:3.7-buster

ADD requirements.txt /requirements.txt
ADD style_check.sh /style_check.sh
ADD .pylintrc /.pylintrc
RUN apt update -y && apt install -y jq hunspell-en-gb libenchant
RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash","./style_check.sh"]