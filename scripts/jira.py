import json
import os
import sys

import requests
from requests.auth import HTTPBasicAuth


def get_issues_by_boards():
    print("test")


def get_issues_in_active_sprint(project=None):
    url = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/rest/api/3/search?maxResults=150&jql=sprint IN openSprints() AND project = {project} AND assignee= currentUser() ORDER BY priority DESC"
    issues = get(url)
    issues = parse_issues(issues)
    print_issues(issues)


def get_issues_assigned_to_me():
    url = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/rest/api/3/search?maxResults=150&jql=assignee=currentUser() AND status=Open"
    issues = get(url)
    print_issues(issues)


def parse_issues(issues):
    output = []
    for issue in issues:
        output.append({"key": issue["key"], "summary": issue["summary"]})
        return output


def print_issues(issues):
    for issue in issues:
        print(issue["key"], issue["summary"])


def get(url):
    auth = HTTPBasicAuth(os.environ.get("JIRA_EMAIL"), os.environ.get("JIRA_TOKEN"))
    response = requests.get(
        url=url,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        auth=auth,
    )

    return json.loads(response.text)["issues"]


if __name__ == "__main__":
    globals()[sys.argv[1]](sys.argv[2])
