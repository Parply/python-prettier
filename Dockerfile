FROM python:3.7-buster AS FORMAT
ADD requirements.txt /requirements.txt
ADD main.sh /main.sh
COPY comment_pr.py /action/comment_pr.py
COPY .pylintrc /action/.pylintrc
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt update -y && apt install -y jq hunspell-en-gb enchant nodejs
RUN npm install --global poor-mans-t-sql-formatter-cli
RUN export INSTALL_ON_LINUX=1; pip install -r requirements.txt
ENTRYPOINT ["/bin/bash","/main.sh"]