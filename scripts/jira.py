import argparse
import json
import os
import subprocess
import sys
import webbrowser

import requests
from requests.auth import HTTPBasicAuth

URL = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/rest/api/3/"


def get_issues_in_active_sprint(args):
    url = f"{URL}search?maxResults=150&jql=sprint IN openSprints() AND project = {args.project_sprint} AND assignee= currentUser() ORDER BY priority DESC"
    issues = get(url)
    issues = parse_issues(issues)
    print_issues(issues)


def get_issues_assigned_to_me(args):
    url = f"{URL}search?maxResults=150&jql=project={args.project_request} and due <= endOfMonth() and due >= startOfMonth() and status != closed"
    issues = get(url)
    issues = parse_issues(issues)
    print_issues(issues)

def get_status(args):
    print("--")
    get_issues_in_active_sprint(args)
    print("--")
    if args.project_request:
        get_issues_assigned_to_me(args)
        print("--")

def open_issue(args):
    url = f"https://{os.environ.get("JIRA_DOMAIN")}.atlassian.net/browse/{args.key}"
    command = f"cmd.exe /c start {url}"
    subprocess.run(command, shell=True)

def parse_issues(issues):
    output = []
    for issue in issues:
        output.append({
            "key": issue["key"], 
            "summary": issue["fields"]["summary"],
            "status":issue["fields"]['status']['name'],
            "due":issue['fields']['duedate']
            })
        return output


def print_issues(issues):
    for issue in issues:
        if len(issue["summary"])>55:
            issue["summary"] = issue["summary"][0:60] + "..."

    print(issue["key"], f"[{issue['status']}]", issue["due"] or "", "\n", issue["summary"], "\n")

def get(url):
    auth = HTTPBasicAuth(os.environ.get("JIRA_EMAIL"), os.environ.get("JIRA_TOKEN"))
    response = requests.get(
        url=url,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        auth=auth,
    )

    return json.loads(response.text)["issues"]

p = argparse.ArgumentParser()
subparsers = p.add_subparsers()

option_me_parser = subparsers.add_parser("me")
option_me_parser.add_argument("project_sprint")
option_me_parser.set_defaults(func=get_issues_assigned_to_me)

option_status_parser = subparsers.add_parser("status")
option_status_parser.add_argument("project_sprint")
option_status_parser.add_argument("project_request", nargs='?', default=None)
option_status_parser.set_defaults(func=get_status)

option_open_parser = subparsers.add_parser("open")
option_open_parser.add_argument("key")
option_open_parser.set_defaults(func=open_issue)

args = p.parse_args()
args.func(args)

