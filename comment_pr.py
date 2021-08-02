import os

from defusedxml.ElementTree import parse
from github import Github

if __name__ == '__main__':
    GITHUB_TOKEN = os.getenv("GH_TOKEN")
    GITHUB_REPOSITORY = os.getenv("GITHUB_REPOSITORY")
    PR_NUMBER = os.getenv("PR_NUMBER")

    MESSAGE = os.getenv("MESSAGE") + parse(".\mypy.xml").findall("./testcase/failure")[0].text

    git = Github(GITHUB_TOKEN)

    repo = git.get_repo(GITHUB_REPOSITORY)
    pr = repo.get_pull(PR_NUMBER)

    pr.create_issue_comment(MESSAGE)