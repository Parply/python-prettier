FROM continuumio/conda-ci-linux-64-python3.7 AS FORMAT
ADD requirements.txt /requirements.txt
ADD main.sh /main.sh
ADD .pylintrc /.pylintrc
ADD comment_pr.py /comment_pr.py
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
RUN apt update -y && apt install -y jq hunspell-en-gb enchant nodejs
RUN conda install --file requirements.txt -c conda-forge
RUN npm install --global poor-mans-t-sql-formatter-cli
RUN export INSTALL_ON_LINUX=1; pip install xlwings
ENTRYPOINT ["/bin/bash","./main.sh"]