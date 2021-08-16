FROM python:3.7-buster AS FORMAT
ADD requirements.txt /requirements.txt
ADD main.sh /main.sh
ADD comment_pr.py /comment_pr.py
ADD .pylintrc /.pylintrc
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt update -y && apt install -y jq hunspell-en-gb enchant nodejs
RUN npm install --global poor-mans-t-sql-formatter-cli
RUN export INSTALL_ON_LINUX=1; pip install -r requirements.txt
RUN echo $PWD
ENTRYPOINT ["/bin/bash","/main.sh"]