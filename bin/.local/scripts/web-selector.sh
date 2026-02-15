#!/bin/bash

# Web Link Selector with fzf (JSON Edition)
# Usage: ./web-selector.sh [file_path]

set -e

# Default file path
DEFAULT_FILE="$HOME/bookmarks.json"

# Function to show usage
show_usage() {
    echo "Usage: $0 [file_path]"
    echo "Select and open web links from a JSON file using fzf with hierarchical navigation"
    echo ""
    echo "Arguments:"
    echo "  file_path    Path to JSON file containing bookmarks (default: ~/bookmarks.json)"
    echo ""
    echo "JSON Format:"
    echo "{"
    echo "  \"bookmarks\": ["
    echo "    {"
    echo "      \"name\": \"Google\","
    echo "      \"url\": \"https://google.com\","
    echo "      \"tags\": [\"search\", \"popular\"]"
    echo "    },"
    echo "    {"
    echo "      \"name\": \"YouTube\","
    echo "      \"group\": true,"
    echo "      \"items\": ["
    echo "        {"
    echo "          \"name\": \"YouTube Home\","
    echo "          \"url\": \"https://youtube.com\","
    echo "          \"tags\": [\"video\"]"
    echo "        }"
    echo "      ]"
    echo "    }"
    echo "  ]"
    echo "}"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 ~/my-bookmarks.json"
    echo "  $0 ./bookmarks.json"
}

# Function to check if required tools are installed
check_dependencies() {
    if ! command -v fzf &> /dev/null; then
        echo "Error: fzf is not installed."
        echo "Please install fzf first:"
        echo "  - macOS: brew install fzf"
        echo "  - Ubuntu/Debian: sudo apt install fzf"
        echo "  - Arch: sudo pacman -S fzf"
        echo "  - Or visit: https://github.com/junegunn/fzf#installation"
        exit 1
    fi
    
    # Check for Python (JSON is built-in, no additional dependencies needed)
    local python_cmd
    python_cmd=$(get_python_cmd)
    
    if [[ -z "$python_cmd" ]]; then
        echo "Error: Python is not installed."
        echo "Please install Python 3 or Python 2.7+"
        echo "JSON parsing is built-in, no additional packages needed."
        exit 1
    fi
}

# Function to open URL in browser
open_url() {
    local url="$1"
    
    echo "Opening: $url"
    
    # Detect OS and open URL accordingly
    case "$(uname -s)" in
        Darwin*)
            # macOS
            open "$url" 2>/dev/null &
            ;;
        Linux*)
            # Linux - try different commands, including Zen Browser
            if command -v zen-browser &> /dev/null; then
                nohup zen-browser "$url" >/dev/null 2>&1 &
            elif command -v zen &> /dev/null; then
                nohup zen "$url" >/dev/null 2>&1 &
            elif command -v xdg-open &> /dev/null; then
                nohup xdg-open "$url" >/dev/null 2>&1 &
            elif command -v gnome-open &> /dev/null; then
                nohup gnome-open "$url" >/dev/null 2>&1 &
            elif command -v kde-open &> /dev/null; then
                nohup kde-open "$url" >/dev/null 2>&1 &
            elif command -v firefox &> /dev/null; then
                nohup firefox "$url" >/dev/null 2>&1 &
            elif command -v chromium-browser &> /dev/null; then
                nohup chromium-browser "$url" >/dev/null 2>&1 &
            elif command -v google-chrome &> /dev/null; then
                nohup google-chrome "$url" >/dev/null 2>&1 &
            else
                echo "Error: Could not find a way to open URLs on this system"
                echo "Please install xdg-utils or a browser (zen, firefox, chrome, etc.)"
                return 1
            fi
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            # Windows
            start "$url" 2>/dev/null
            ;;
        *)
            echo "Error: Unsupported operating system"
            return 1
            ;;
    esac
    
    # Give the system a moment to process the command
    sleep 0.5
    
    echo "Link sent to browser"
    return 0
}

# Function to extract URL from line
extract_url() {
    local line="$1"
    
    # Try to extract URL using regex
    if [[ "$line" =~ https?://[^[:space:]]+ ]]; then
        echo "${BASH_REMATCH[0]}"
    else
        echo "$line"
    fi
}

# Function to validate URL
is_valid_url() {
    local url="$1"
    [[ "$url" =~ ^https?:// ]]
}

# Function to get Python command
get_python_cmd() {
    if command -v python3 &>/dev/null; then
        echo "python3"
    elif command -v python &>/dev/null; then
        echo "python"
    else
        echo ""
    fi
}

# Function to parse JSON and get bookmarks structure
parse_bookmarks() {
    local file_path="$1"
    local path_query="$2"
    
    local python_cmd
    python_cmd=$(get_python_cmd)
    
    $python_cmd << EOF
import json
import sys

def navigate_path(data, path_parts):
    current = data
    for part in path_parts:
        if isinstance(current, dict) and part in current:
            current = current[part]
        elif isinstance(current, list) and part.isdigit():
            idx = int(part)
            if 0 <= idx < len(current):
                current = current[idx]
            else:
                return None
        else:
            return None
    return current

try:
    with open('$file_path', 'r') as f:
        data = json.load(f)
    
    if not data or 'bookmarks' not in data:
        print(json.dumps({'error': 'Invalid JSON: missing bookmarks key'}))
        sys.exit(1)
    
    if '$path_query':
        # Parse path like "bookmarks.0.items"
        path_parts = '$path_query'.split('.')
        result = navigate_path(data, path_parts)
    else:
        result = data['bookmarks']
    
    print(json.dumps(result if result is not None else []))
    
except Exception as e:
    print(json.dumps({'error': str(e)}))
    sys.exit(1)
EOF
}

# Function to build navigation menu for current level
build_menu() {
    local file_path="$1"
    local current_path="$2"
    local breadcrumb="$3"
    
    local menu_items=()
    local menu_display=()
    
    # Add back navigation if not at root
    if [[ -n "$current_path" ]]; then
        menu_items+=("__BACK__")
        menu_display+=("../")
    fi
    
    # Get JSON data for current level
    local json_data
    json_data=$(parse_bookmarks "$file_path" "$current_path")
    
    # Check for errors
    if echo "$json_data" | grep -q '"error"'; then
        echo "Error parsing YAML: $(echo "$json_data" | sed 's/.*"error":"\([^"]*\)".*/\1/')"
        return 1
    fi
    
    # Parse items using Python
    local python_cmd
    python_cmd=$(get_python_cmd)
    
    local items_data
    items_data=$($python_cmd << EOF
import json
import sys

try:
    data = json.loads('$json_data')
    
    if not isinstance(data, list):
        print("[]")
        sys.exit(0)
    
    for i, item in enumerate(data):
        if not isinstance(item, dict) or 'name' not in item:
            continue
            
        name = item['name']
        is_group = item.get('group', False)
        url = item.get('url', '')
        tags = item.get('tags', [])
        
        if is_group:
            print(f"GROUP|{i}|{name}")
        else:
            tags_str = ','.join(tags) if tags else ''
            print(f"URL|{url}|{name}|{tags_str}")
            
except Exception as e:
    print(f"ERROR|{e}", file=sys.stderr)
EOF
)
    
    # Process the parsed items
    while IFS='|' read -r type data1 data2 data3; do
        case "$type" in
            "GROUP")
                local index="$data1"
                local name="$data2"
                local new_path
                if [[ -n "$current_path" ]]; then
                    new_path="${current_path}.${index}.items"
                else
                    new_path="bookmarks.${index}.items"
                fi
                menu_items+=("$new_path")
                menu_display+=("$name")
                ;;
            "URL")
                local url="$data1"
                local name="$data2"
                local tags="$data3"
                menu_items+=("$url")
                if [[ -n "$tags" ]]; then
                    menu_display+=("$name [$tags]")
                else
                    menu_display+=("$name")
                fi
                ;;
        esac
    done <<< "$items_data"
    
    # Show menu with fzf
    local header="$breadcrumb"
    [[ -z "$header" ]] && header="Bookmarks"
    
    local selected_index
    selected_index=$(printf '%s\n' "${menu_display[@]}" | fzf)
    
    # Find the index of selected item
    for i in "${!menu_display[@]}"; do
        if [[ "${menu_display[$i]}" == "$selected_index" ]]; then
            echo "${menu_items[$i]}"
            return 0
        fi
    done
    
    # If no match found, return empty
    echo ""
}

# Function for hierarchical navigation
navigate_bookmarks() {
    local file_path="$1"
    local current_path=""
    local breadcrumb=""
    local navigation_stack=()
    
    while true; do
        local selection
        selection=$(build_menu "$file_path" "$current_path" "$breadcrumb")
        
        # Check if user cancelled
        if [[ -z "$selection" ]]; then
            echo "No selection made. Exiting."
            return 1
        fi
        
        # Handle back navigation
        if [[ "$selection" == "__BACK__" ]]; then
            if [[ ${#navigation_stack[@]} -gt 0 ]]; then
                # Pop from stack
                local stack_entry="${navigation_stack[-1]}"
                navigation_stack=("${navigation_stack[@]:0:${#navigation_stack[@]}-1}")
                
                IFS='|' read -r current_path breadcrumb <<< "$stack_entry"
            else
                current_path=""
                breadcrumb=""
            fi
            continue
        fi
        
        # Check if it's a group (path contains .items)
        if [[ "$selection" =~ \.items$ ]]; then
            # Save current state to stack
            navigation_stack+=("$current_path|$breadcrumb")
            
            # Navigate into group
            current_path="$selection"
            
            # Extract group name for breadcrumb
            local group_name
            group_name=$(parse_bookmarks "$file_path" "${selection%.items}" | \
                $(get_python_cmd) -c "import json, sys; data=json.load(sys.stdin); print(data.get('name', 'Unknown') if isinstance(data, dict) else 'Group')")
            
            if [[ -n "$breadcrumb" ]]; then
                breadcrumb="$breadcrumb > $group_name"
            else
                breadcrumb="$group_name"
            fi
            continue
        fi
        
        # It's a URL, validate and open it
        if is_valid_url "$selection"; then
            open_url "$selection"
            return 0
        else
            echo "Invalid URL: $selection"
            return 1
        fi
    done
}

# Main function
main() {
    # Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi
    
    # Check if required tools are installed
    check_dependencies
    
    # Set file path
    local file_path="${1:-$DEFAULT_FILE}"
    
    # Check if file exists
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File '$file_path' not found."
        echo ""
        echo "Create a JSON file with bookmarks structure. Example:"
        echo "{"
        echo "  \"bookmarks\": ["
        echo "    {"
        echo "      \"name\": \"Google\","
        echo "      \"url\": \"https://google.com\","
        echo "      \"tags\": [\"search\"]"
        echo "    },"
        echo "    {"
        echo "      \"name\": \"YouTube\","
        echo "      \"group\": true,"
        echo "      \"items\": ["
        echo "        {"
        echo "          \"name\": \"YouTube Home\","
        echo "          \"url\": \"https://youtube.com\","
        echo "          \"tags\": [\"video\"]"
        echo "        }"
        echo "      ]"
        echo "    }"
        echo "  ]"
        echo "}"
        echo ""
        echo "Then run: $0 $file_path"
        exit 1
    fi
    
    # Check if file is empty
    if [[ ! -s "$file_path" ]]; then
        echo "Error: File '$file_path' is empty."
        exit 1
    fi
    
    # Validate JSON structure
    local python_cmd
    python_cmd=$(get_python_cmd)
    
    if ! $python_cmd -c "
import json
try:
    with open('$file_path', 'r') as f:
        data = json.load(f)
    if not isinstance(data, dict) or 'bookmarks' not in data:
        exit(1)
except:
    exit(1)
" 2>/dev/null; then
        echo "Error: Invalid JSON structure. File must contain a 'bookmarks' key at root level."
        exit 1
    fi
    
    # Start hierarchical navigation
    navigate_bookmarks "$file_path"
}

# Run main function with all arguments
main "$@"
