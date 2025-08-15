#!/bin/bash

# Script to trigger GitHub Actions Windows build from a specific commit

echo "🎯 Build Windows .exe from specific commit"
echo "=========================================="
echo

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ This is not a git repository."
    exit 1
fi

# Show recent commits
echo "📋 Recent commits:"
git log --oneline -10
echo

# Get the commit SHA from user
read -p "🔍 Enter commit SHA (or press Enter for current): " commit_sha

if [ -z "$commit_sha" ]; then
    commit_sha=$(git rev-parse HEAD)
    echo "ℹ️  Using current commit: $commit_sha"
else
    # Validate commit exists
    if ! git cat-file -e "$commit_sha" 2>/dev/null; then
        echo "❌ Invalid commit SHA: $commit_sha"
        exit 1
    fi
    echo "✅ Valid commit: $commit_sha"
fi

# Get commit details
commit_message=$(git log -1 --pretty=format:"%s" "$commit_sha")
commit_date=$(git log -1 --pretty=format:"%ad" --date=short "$commit_sha")

echo
echo "📦 Building from commit:"
echo "   SHA: $commit_sha"
echo "   Message: $commit_message"
echo "   Date: $commit_date"
echo

# Check if GitHub CLI is available
if command -v gh &> /dev/null; then
    echo "🚀 Triggering GitHub Actions build..."
    if [ -z "$1" ] || [ "$commit_sha" = "$(git rev-parse HEAD)" ]; then
        # Build from current/specified commit using workflow dispatch
        gh workflow run build-windows.yml --field commit_sha="$commit_sha"
    else
        gh workflow run build-windows.yml --field commit_sha="$commit_sha"
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ Build triggered successfully!"
        echo
        echo "📋 Next steps:"
        echo "   1. Go to: $(git remote get-url origin | sed 's/\.git$//')/actions"
        echo "   2. Wait for the build to complete"
        echo "   3. Download the .exe from Artifacts"
        echo
        echo "💡 Monitor build: gh run list --workflow=build-windows.yml"
    else
        echo "❌ Failed to trigger build. Make sure you're authenticated with 'gh auth login'"
    fi
else
    echo "ℹ️  GitHub CLI not found. Manual steps:"
    echo
    echo "1. Go to your GitHub repository"
    echo "2. Click 'Actions' tab"
    echo "3. Click 'Build Windows Executable' workflow"
    echo "4. Click 'Run workflow' button"
    echo "5. Enter commit SHA: $commit_sha"
    echo "6. Click 'Run workflow'"
    echo
    echo "🔗 Repository: $(git remote get-url origin | sed 's/\.git$//')"
    echo "📁 Actions: $(git remote get-url origin | sed 's/\.git$//')/actions"
fi
