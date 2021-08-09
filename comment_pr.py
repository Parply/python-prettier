import os

import argparse
from defusedxml.ElementTree import parse
from github import Github

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='GITHUB Action comment on PR')
    parser.add_argument('--pylint', type=str)

    MESSAGE = parser.parse_args()['pylint']

    GITHUB_TOKEN = os.getenv("GH_TOKEN")
    GITHUB_REPOSITORY = os.getenv("GITHUB_REPOSITORY")
    PR_NUMBER = os.getenv("PR_NUMBER")

    print(os.getcwd())

    MESSAGE += parse("/mypy.xml").findall("./testcase/failure")[0].text

    print(GITHUB_TOKEN,GITHUB_REPOSITORY,PR_NUMBER,MESSAGE)

    git = Github(GITHUB_TOKEN)

    repo = git.get_repo(GITHUB_REPOSITORY)
    pr = repo.get_pull(PR_NUMBER)

    pr.create_issue_comment(MESSAGE)