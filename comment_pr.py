import os
from html import escape

from defusedxml.ElementTree import parse
from github import Github

HEADER = "<h2>:snake: Python Styling :snake:</h2><br>"
PEP_HEADER = "<summary><h4><b>PEP8 Standard Report (pylint)</b></h4></summary><br>"
MYPY_HEADER = "<summary><h4><b>Typing Report (mypy)</b></summary></h4><br>"
if __name__ == "__main__":
    GITHUB_TOKEN = os.getenv("INPUT_GH_TOKEN")
    GITHUB_REPOSITORY = os.getenv("GITHUB_REPOSITORY")
    PR_NUMBER = int(os.getenv("INPUT_PR_NUMBER"))

    MESSAGE = (
        HEADER
        + PEP_HEADER
        + "```" + open("/action/pylint.txt", "r").read()+"```"#).replace('\n',"<br>").replace(' ',"&nbsp;")
        + MYPY_HEADER
        + "```"+parse("/action/mypy.xml").findall("./testcase/failure")[0].text+"```"#).replace('\n',"<br>").replace(' ',"&nbsp;")
    )

    git = Github(GITHUB_TOKEN)

    repo = git.get_repo(GITHUB_REPOSITORY)
    pr = repo.get_pull(PR_NUMBER)

    pr.create_issue_comment(MESSAGE)
