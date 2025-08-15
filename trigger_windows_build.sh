#!/bin/bash

# Script to trigger GitHub Actions Windows build from macOS

echo "🚀 Setting up automated Windows build..."
echo

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ This is not a git repository."
    echo "   Please run: git init"
    exit 1
fi

# Check if we have a remote origin
if ! git remote get-url origin >/dev/null 2>&1; then
    echo "❌ No remote origin found."
    echo "   Please add your GitHub repository:"
    echo "   git remote add origin https://github.com/yourusername/Meulade_RVSQ.git"
    exit 1
fi

echo "✅ Git repository detected"
echo "📤 Pushing to GitHub to trigger Windows build..."
echo

# Add all files
git add .

# Commit if there are changes
if git diff --staged --quiet; then
    echo "ℹ️  No changes to commit"
else
    echo "📝 Committing changes..."
    git commit -m "Add Windows build automation and scripts"
fi

# Push to trigger GitHub Actions
echo "🔄 Pushing to GitHub..."
git push origin main 2>/dev/null || git push origin master 2>/dev/null || {
    echo "❌ Failed to push. Please check your repository setup."
    echo "   Make sure you have:"
    echo "   1. Created a GitHub repository"
    echo "   2. Added it as origin: git remote add origin <your-repo-url>"
    echo "   3. Have push permissions"
    exit 1
}

echo
echo "🎉 Success! GitHub Actions will now build your Windows executable."
echo
echo "📋 Next steps:"
echo "   1. Go to your GitHub repository"
echo "   2. Click on the 'Actions' tab"
echo "   3. Wait for the 'Build Windows Executable' workflow to complete"
echo "   4. Download the .exe from the 'Artifacts' section"
echo
echo "🔗 Repository: $(git remote get-url origin)"
echo "📁 Actions: $(git remote get-url origin | sed 's/\.git$//')/actions"
echo
