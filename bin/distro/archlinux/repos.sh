REPOS=(
  "https://github.com/tmux-plugins/tpm.git:/$HOME/.tmux/plugins/tpm"
)

for repo in "${REPOS[@]}"; do
  IFS=":" read -r REPO_URL TARGET_DIR <<< "$repo"

  if [ -d "$TARGET_DIR" ]; then
    echo "Target directory '$TARGET_DIR' already exists. Skipping..."
  else
    echo "Cloning '$REPO_URL' into '$TARGET_DIR'..."
    git clone "$REPO_URL" "$TARGET_DIR"
    if [ $? -eq 0 ]; then
      echo "Successfully cloned '$REPO_URL'."
    else
      echo "Failed to clone '$REPO_URL'."
    fi
  fi
done
