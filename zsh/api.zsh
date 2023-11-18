#jira.zsh

call_api(){
    local url=$1
    local data=$2

    local user="$JIRA_EMAIL:$JIRA_TOKEN"
    local encoded_credentials=$(echo -n $user | base64)

    local response=$(curl --location $url \
                            --header 'Content-Type: application/json' \
                            --header "Authorization: Basic '$encoded_credentials'" \
                            --data '{"timeSpentSeconds":'$data'}') \

    echo $response | jq '.'
}

jw(){
    local number_arg=$1
    local time_arg=$2


    if [[ $number_arg =~ ^[A-Z]+-[0-9]+$ ]]; then
        echo "Key argument is: $number_arg"
    else
        echo "Error: The third argument must be a valid key."
        return 1
    fi

    if [[ $time_arg =~ ^([0-9]+)h?([0-9]+)?m?$ ]]; then
        local hours=0
        local minutes=0

        if [[ $time_arg = *h* ]]; then
            hours=${match[1]}
            minutes=${match[2]}
        
        else
            minutes=${match[1]}
        fi

        local seconds=$((hours * 3600 + minutes * 60))
        echo "Time argument is: $hours hours and $minutes minutes ($seconds)"
    else
        echo "Error: The fourth argument must be in the format 'Xh Ym', where X and Y are numbers."
        return 1
    fi

    call_api "https://$JIRA_DOMAIN.atlassian.net/rest/api/3/issue/$number_arg/worklog" $seconds

}
