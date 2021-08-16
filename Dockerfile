FROM python:3.7-buster AS FORMAT
ADD requirements.txt /requirements.txt
ADD main.sh /main.sh
ADD comment_pr.py ./action/comment_pr.py
ADD .pylintrc ./action/.pylintrc
RUN apt update -y && apt install -y hunspell-en-gb enchant
RUN export INSTALL_ON_LINUX=1; pip install -r requirements.txt
ENTRYPOINT ["/bin/bash","/main.sh"]