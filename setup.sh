
set -e

git clone https://github.com/patham9/PeTTa
cd PeTTa || exit 1

git fetch origin
git checkout "$(git rev-parse origin/HEAD)"

# Ensure run.sh has a proper bash shebang
if ! grep -q "^#!/bin/bash" run.sh; then
    sed -i '1i#!/bin/bash' run.sh
fi

# Build absolute paths
SCRIPT_DIR="$(pwd)/src/main.pl"


# Update paths inside run.sh
sed -i "s|./src/main.pl|$SCRIPT_DIR|" run.sh

# Make run.sh executable
chmod +x run.sh

# Add repo path to PATH (local shell)
repo_path="$(pwd)"
if ! echo "$PATH" | grep -q "$repo_path"; then
    export PATH="$PATH:$repo_path"
fi

# Add to GitHub Actions env only if running in CI
if [ -n "$GITHUB_ENV" ]; then
    echo "PATH=$PATH" >> "$GITHUB_ENV"
fi

echo "PeTTa setup complete."
