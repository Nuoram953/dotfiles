#jira.zsh

call_api(){
    local url=$1
    local data=$2

    local headers="-H 'Content-Type: application/json'"
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
        echo "Time argument is: $hours hours and $minutes minutes"
    else
        echo "Error: The fourth argument must be in the format 'Xh Ym', where X and Y are numbers."
        return 1
    fi



}
