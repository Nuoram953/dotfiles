#!/bin/bash

# Web Link Selector with fzf
# Usage: ./web-selector.sh [file_path]

set -e

# Default file path
DEFAULT_FILE="$HOME/bookmarks.txt"

# Function to show usage
show_usage() {
    echo "Usage: $0 [file_path]"
    echo "Select and open web links from a file using fzf"
    echo ""
    echo "Arguments:"
    echo "  file_path    Path to file containing web links (default: ~/bookmarks.txt)"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 ~/my-links.txt"
    echo "  $0 ./urls.txt"
}

# Function to check if fzf is installed
check_fzf() {
    if ! command -v fzf &> /dev/null; then
        echo "Error: fzf is not installed."
        echo "Please install fzf first:"
        echo "  - macOS: brew install fzf"
        echo "  - Ubuntu/Debian: sudo apt install fzf"
        echo "  - Arch: sudo pacman -S fzf"
        echo "  - Or visit: https://github.com/junegunn/fzf#installation"
        exit 1
    fi
}

# Function to open URL in browser
open_url() {
    local url="$1"
    
    echo "🌐 Opening: $url"
    
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
                echo "❌ Error: Could not find a way to open URLs on this system"
                echo "Please install xdg-utils or a browser (zen, firefox, chrome, etc.)"
                return 1
            fi
            ;;
        CYGWIN*|MINGW32*|MSYS*|MINGW*)
            # Windows
            start "$url" 2>/dev/null
            ;;
        *)
            echo "❌ Error: Unsupported operating system"
            return 1
            ;;
    esac
    
    # Give the system a moment to process the command
    sleep 0.5
    
    echo "✅ Link sent to browser"
    return 0
}

# Function to extract URL from line
extract_url() {
    local line="$1"
    
    # Try to extract URL using regex
    # This handles various formats like:
    # - https://example.com
    # - Title - https://example.com
    # - [Title](https://example.com)
    # - Title: https://example.com
    
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

# Main function
main() {
    # Check for help flag
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        show_usage
        exit 0
    fi
    
    # Check if fzf is installed
    check_fzf
    
    # Set file path
    local file_path="${1:-$DEFAULT_FILE}"
    
    # Check if file exists
    if [[ ! -f "$file_path" ]]; then
        echo "Error: File '$file_path' not found."
        echo ""
        echo "Create a file with web links, one per line. Examples:"
        echo "  https://github.com"
        echo "  Google - https://google.com"
        echo "  https://stackoverflow.com"
        echo ""
        echo "Then run: $0 $file_path"
        exit 1
    fi
    
    # Check if file is empty
    if [[ ! -s "$file_path" ]]; then
        echo "Error: File '$file_path' is empty."
        exit 1
    fi
    
    echo "📖 Loading links from: $file_path"
    echo "🔍 Use fzf to search and select a link to open..."
    echo ""
    
    # Use fzf to select a line from the file
    local selected_line
    selected_line=$(cat "$file_path" | fzf \
        --height=50% \
        --layout=reverse \
        --border \
        --prompt="Select link: " \
        --preview="echo 'Preview: {}'" \
        --preview-window=up:3:wrap \
        --header="Press ENTER to open selected link, ESC to quit" \
        --color="header:italic:underline" \
        --no-sort \
        --cycle)
    
    # Check if user cancelled selection
    if [[ -z "$selected_line" ]]; then
        echo "❌ No link selected. Exiting."
        exit 0
    fi
    
    # Extract URL from the selected line
    local url
    url=$(extract_url "$selected_line")
    
    # Validate URL
    if ! is_valid_url "$url"; then
        echo "❌ Invalid URL: $url"
        echo "Please ensure the line contains a valid HTTP/HTTPS URL"
        exit 1
    fi
    
    # Open the URL
    open_url "$url"
}

# Run main function with all arguments
main "$@"
