import os

from defusedxml.ElementTree import parse
from github import Github

HEADER = "<h3>:snake: Python Styling :snake:</h3>\n"
PEP_HEADER = "<summary><b>PEP8 Standard Report (pylint)</b></summary>\n"
MYPY_HEADER = "<summary><b>Typing Report (mypy)</b></summary>\n"
if __name__ == "__main__":
    GITHUB_TOKEN = os.getenv("INPUT_GH_TOKEN")
    GITHUB_REPOSITORY = os.getenv("GITHUB_REPOSITORY")
    PR_NUMBER = int(os.getenv("INPUT_PR_NUMBER"))
    GITHUB_WORKSPACE = os.getenv("GITHUB_WORKSPACE")

    print(os.getcwd())
    print(os.listdir())

    MESSAGE = (
        HEADER
        + PEP_HEADER
        + open("/action/pylint.txt", "r").read().replace('\n',"<br>")
        + MYPY_HEADER
        + parse("/action/mypy.xml").findall("./testcase/failure")[0].text.replace('\n',"<br>")
    )

    print(GITHUB_TOKEN, GITHUB_REPOSITORY, PR_NUMBER, MESSAGE)

    git = Github(GITHUB_TOKEN)

    repo = git.get_repo(GITHUB_REPOSITORY)
    pr = repo.get_pull(PR_NUMBER)

    pr.create_issue_comment(MESSAGE)
