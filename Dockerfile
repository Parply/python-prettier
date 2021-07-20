FROM python:3.7-buster

ADD requirements.txt /requirements.txt
ADD style_check.sh /style_check.sh
ADD .pylintrc /.pylintrc
RUN apt-get update && apt-get install -y hunspell-en-gb
RUN pip install -r requirements.txt

ENTRYPOINT ["/bin/bash","./style_check.sh"]