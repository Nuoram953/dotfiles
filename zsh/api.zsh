#jira.zsh

call_api(){
    local url=$1
    local data=$2

    local headers="-H 'Content-Type: application/json' -H 'Accept: application/json'"
    local user="--user '$JIRA_EMAIL:$JIRA_TOKEN'"
    local response=$(curl -X POST $headers -d "$data" $url)

    echo "Response: $response"
}

jw(){
    local number_arg=$1
    local time_arg=$2

    if [[ $number_arg =~ ^[0-9]+$ ]]; then
        echo "Number argument is: $number_arg"
    else
        echo "Error: The third argument must be a number."
        return 1
    fi

    if [[ $time_arg =~ ^([0-9]+)h?([0-9]+)m$ ]]; then
        local hours=${match[1]}
        local minutes=${match[2]}
        local seconds=$((hours * 3600 + minutes * 60))
        echo "Time argument is: $hours hours and $minutes minutes ($seconds)"
    else
        echo "Error: The fourth argument must be in the format 'Xh Ym', where X and Y are numbers."
        return 1
    fi

    call_api "https://$JIRA_DOMAIN.atlassian.net/rest/api/3/issue/$number_arg/worklog" "{'timeSpentSeconds':$seconds}"

}
