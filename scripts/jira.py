import json
import os
import re
import subprocess

import click
import requests
from requests.auth import HTTPBasicAuth

URL = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/rest/api/3/"


@click.group()
def cli():
    pass


@click.command()
@click.argument("key", type=str)
@click.argument("time", type=str)
@click.option("-m", "--message", help="The message for your worklog", required=0)
def add_worklog(key, time, message=None):
    if not re.match(r"^([0-9]+)h?([0-9]+)?m?$", time):
        time = click.prompt("Enter a valid worklog")

    if not re.match(r"^[a-zA-Z]+-[0-9]+$", key):
        key = click.prompt("Enter a valid key")

    if "h" in time:
        time_splitted = time.split("h")
        hours = time_splitted[0]
        minutes = time_splitted[1].split("m")[0]
    else:
        hours = 0
        minutes = time.split("m")[0]

    seconds = (int(hours) * 3600) + (int(minutes) * 60)

    click.echo(f"Your time in seconds: {seconds}")
    url = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/rest/api/3/issue/{key}/worklog"
    data = {"timeSpentSeconds": seconds}

    if message:
        data["comment"] = {
            "content": [
                {"content": [{"text": message, "type": "text"}], "type": "paragraph"}
            ],
            "type": "doc",
            "version": 1,
        }

    post(url, json.dumps(data))


@click.command()
@click.argument("project", type=str)
@click.option(
    "--project-type", type=click.Choice(["sprint", "board"], case_sensitive=False)
)
def get_board_issues(project, project_type):
    if project_type.upper() == "SPRINT":
        url = f"{URL}search?maxResults=150&jql=sprint IN openSprints() AND project = {project} AND assignee= currentUser() ORDER BY priority DESC"

    if project_type.upper() == "BOARD":
        url = f"{URL}search?maxResults=150&jql=project={project} and due <= endOfMonth() and due >= startOfMonth() and status != closed"

    issues = get(url)
    parsed_issues = parse_issues(issues)
    print_issues(parsed_issues)

@click.command()
@click.argument("project", type=str)
@click.option("-p", "--parent", help="Enter the parent's key if you want to create a child task", required=0, default=None)
@click.option("-s", "--summary", prompt="Enter the summary", help="Task summary and description")
@click.option("-a", "--assignee", prompt="Enter the assignee", help="Task's assignee")
@click.option("-t", "--issue-type", prompt="Choose the task's type", help="Task's type")
@click.option("-e", "--estimate", prompt="Enter the estimate time", help="How much time the task will take")
def create_task(project, parent, summary, assignee, issue_type, estimate):
    pass


def post(url, data):
    auth = HTTPBasicAuth(os.environ.get("JIRA_EMAIL"), os.environ.get("JIRA_TOKEN"))
    response = requests.post(
        url=url,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        auth=auth,
        data=data,
    )

    return json.loads(response.text)


def get(url):
    auth = HTTPBasicAuth(os.environ.get("JIRA_EMAIL"), os.environ.get("JIRA_TOKEN"))
    response = requests.get(
        url=url,
        headers={"Content-Type": "application/json", "Accept": "application/json"},
        auth=auth,
    )

    return json.loads(response.text)["issues"]

def parse_issues(issues):
    output = []
    for issue in issues:
        output.append(
            {
                "key": issue.get("key", None),
                "summary": issue["fields"].get("summary", None),
                "status": issue["fields"]["status"].get("name", None),
                "due": issue["fields"].get("duedate", None),
            }
        )
    return output


def print_issues(issues):
    for issue in issues:
        if len(issue["summary"]) > 55:
            issue["summary"] = issue["summary"][0:60] + "..."

        print(
            issue["key"],
            f"[{issue['status']}]",
            issue["due"] or "",
            "\n",
            issue["summary"],
            "\n",
        )

cli.add_command(add_worklog)
cli.add_command(get_board_issues)

if __name__ == "__main__":
    cli()


def open_issue(args):
    url = f"https://{os.environ.get('JIRA_DOMAIN')}.atlassian.net/browse/{args.key}"
    command = f"cmd.exe /c start {url}"
    subprocess.run(command, shell=True)



