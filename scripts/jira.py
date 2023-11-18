import json
import base64
import sys
import os
import requests

def get_issues_by_boards():
    print("test")

def get_issues_in_active_sprint(project=None):
    url = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/rest/api/3/search?maxResults=150&jql=sprint IN openSprints() AND project = {project} AND assignee= currentUser()"
    

def get_issues_assigned_to_me():
    url = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/rest/api/3/search?maxResults=150&jql=assignee=currentUser() AND status=Open"
    issues = get(url)
    print_issues(issues)


def parse_issues(issues):
    output = []
    for issue in issues:
        output.append(issue)

def print_issues(issues):
    for issue in issues:
        print(issue)

def get(url):
    auth = f"{os.environ.get('JIRA_EMAIL')}:{os.environ.get('JIRA_TOKEN')}"
    response = requests.get(
            url=url,
            headers={
                'Authorization': f"Basic {base64.b64encode(auth)}"
                }
            )

    return parse_issues(json.loads(response.text)["issues"])

if __name__ == '__main__':
    try:
        globals()[sys.argv[1]](sys.argv[2])
    except:
        globals()[sys.argv[1]]()


