import os

from defusedxml.ElementTree import parse
from github import Github

HEADER = "<h2>:snake: Python Styling :snake:</h2>\n"
PEP_HEADER = "<summary><h4><b>PEP8 Standard Report (pylint)</b></h4></summary>\n"
MYPY_HEADER = "<summary><h4><b>Typing Report (mypy)</b></summary></h4>\n"
if __name__ == "__main__":
    GITHUB_TOKEN = os.getenv("INPUT_GH_TOKEN")
    GITHUB_REPOSITORY = os.getenv("GITHUB_REPOSITORY")
    PR_NUMBER = int(os.getenv("INPUT_PR_NUMBER"))

    mypy = parse("/action/mypy.xml").findall("./testcase/failure")
    if len(mypy) > 0:
        mypy = "\n```Python\n"+'\n'.join(map(lambda x: x.text,mypy))+"\n```"
    else:
        mypy = "\nNo typing errors"

    message = (
        HEADER
        + PEP_HEADER
        + "\n```Python\n" + open("/action/pylint.txt", "r").read()+"\n```\n"
        + MYPY_HEADER
        + mypy
    )

    git = Github(GITHUB_TOKEN)

    repo = git.get_repo(GITHUB_REPOSITORY)
    pr = repo.get_pull(PR_NUMBER)

    pr.create_issue_comment(message)
