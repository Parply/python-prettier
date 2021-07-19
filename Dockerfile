FROM python:3.7-buster

ADD requirements.txt /requirements.txt
ADD style_check.sh /style_check.sh
RUN apt-get install -y enchant
RUN pip install -r requirements.txt

ENTRYPOINT ["style_check.sh"]