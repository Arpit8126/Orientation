# Git & Terminal — Complete Guide from Zero to Real World

Every software engineer works inside the terminal and tracks code modifications using Git. This guide covers CLI (Command Line Interface) navigation and Git version control from basic to advanced workflows.

---

## PART 1: Terminal / Command Line Basics

The terminal is a text-based interface used to run commands and interact with the operating system.

### Command Syntax
```bash
command -options arguments
# Example:
ls -la /var/www
#  ^^  ^^^  ^^^^
# command | options | argument
```

- **Options (Flags)**: Modify how the command works (preceded by `-` or `--`).
- **Arguments**: The target of the command (e.g., a file path or URL).

### Directory Navigation
```bash
# Print Working Directory (Where am I?)
pwd

# List Directory Contents
ls             # List files and folders
ls -l          # Long format (shows permissions, sizes, dates)
ls -a          # List all (including hidden files starting with .)
ls -la         # Combine: long format, all files

# Change Directory (Navigate)
cd /path/to/dir # absolute path
cd documents    # relative path
cd ..           # move up one folder level
cd ../..        # move up two levels
cd ~            # go to user home directory
cd -            # go back to the previous directory you were in
```

### File Operations
```bash
# Create Empty File
touch index.html

# Create Directory
mkdir project
mkdir -p src/components # -p creates parent directories if they don't exist

# Copy
cp file.txt copy.txt          # copy file
cp -r folder/ new_folder/     # copy folder recursively (-r)

# Move / Rename
mv file.txt documents/        # move file
mv old.txt new.txt            # rename file

# Delete (Use with Caution!)
rm file.txt                   # delete file
rm -f file.txt                # force delete (no prompt)
rm -r folder/                 # delete folder recursively
rm -rf folder/                # force delete folder and everything inside!

# View File Contents
cat app.log                   # print entire file content to terminal
less app.log                  # view page-by-page (q to exit)
head -n 20 app.log            # view first 20 lines
tail -n 20 app.log            # view last 20 lines
tail -f app.log               # follow file in real-time (useful for logs)
```

### System & Networking
```bash
# System Info
clear                         # clear terminal screen (Ctrl + L)
history                       # view history of ran commands
whoami                        # show current logged-in username

# Search files (Grep)
grep "error" app.log          # find lines containing "error" in app.log
grep -rn "TODO" src/          # search recursively for "TODO" inside src/ directory
                              # -r: recursive, -n: show line numbers

# Network Utilities
ping google.com               # check network connectivity
curl https://api.github.com   # download data / call API from terminal
wget https://site.com/img.png # download file from web
```

---

## PART 2: Git Fundamentals

Git is a distributed version control system. It takes snapshots of your codebase, allowing you to track history, experiment without fear, and collaborate with teams.

```
Git Workspace Lifecycle:
 ┌───────────────┐     git add      ┌──────────────┐   git commit   ┌──────────────┐
 │ Working Direct│ ───────────────> │ Staging Area │ ─────────────> │ Local Repo   │
 │ (Untracked/Mod│                  │ (Index)      │                │ (.git folder)│
 └───────────────┘                  └──────────────┘                └──────────────┘
```

### Initialization & Setup
```bash
# Configure identity (once per machine)
git config --global user.name "Arpit Pandey"
git config --global user.email "arpit@example.com"

# Initialize local Git repository in current folder
git init

# Clone a remote repository from GitHub
git clone https://github.com/username/repo.git
```

### Basic Workflow
```bash
# Check repository status (which files are modified/unstaged/staged)
git status

# Stage changes (add to staging area)
git add index.html            # stage a single file
git add src/                  # stage an entire folder
git add .                     # stage ALL changes in current folder

# Commit changes (creates a snapshot of staged changes)
git commit -m "feat: implement user registration"

# View commit history
git log
git log --oneline             # compact single-line history
git log -n 5                  # show only the last 5 commits
```

### Undoing Changes
```bash
# Discard modifications in a file (revert to last commit state)
git checkout -- app.js
git restore app.js            # modern Git alternative

# Unstage a file (remove from staging area, keep edits in working directory)
git reset HEAD app.js
git restore --staged app.js   # modern Git alternative

# Amend the last commit (fix typo, add forgotten staged file)
git commit --amend -m "new commit message"

# Soft reset (undo commit, keep changes in staging area)
git reset --soft HEAD~1

# Mixed reset (undo commit and unstage, keep edits in working directory)
git reset HEAD~1

# Hard reset (completely discard last commit and all modifications!)
git reset --hard HEAD~1       # ⚠️ Destructive! Irreversible.
```

---

## PART 3: Branching & Merging

Branches allow you to work on multiple features or experiments in isolation without modifying the main line of code.

```
Visualizing Branches:
  main:    A ─── B ─────────────── C (Merge commit)
                  \               /
  feature:         D ─── E ──────/
```

### Branch Management
```bash
# List all branches (* indicates active branch)
git branch

# Create a new branch
git branch feature-auth

# Switch to a branch
git checkout feature-auth
git switch feature-auth        # modern Git alternative

# Create and switch to branch in one command
git checkout -b feature-chat
git switch -c feature-chat     # modern Git alternative

# Delete a branch (safe: only if merged)
git branch -d feature-auth

# Force delete a branch (even if unmerged)
git branch -D feature-auth
```

### Merging
```bash
# Merge feature branch into main
git checkout main
git merge feature-chat
```

#### Merge Conflicts:
A conflict happens when edits occur on the same lines of the same file on different branches.
1. Git will pause the merge and output conflict markers in the file:
   ```orcus
   <<<<<<< HEAD
   console.log("Hello from main");
   =======
   console.log("Hello from feature-chat");
   >>>>>>> feature-chat
   ```
2. Open the file, choose which code to keep, delete the conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`).
3. Save the file, stage it, and commit to complete the merge:
   ```bash
   git add resolved_file.js
   git commit -m "merge: resolve conflicts with feature-chat"
   ```

---

## PART 4: Collaborating with Remote Repositories (GitHub/GitLab)

```bash
# Add a remote repository pointer
git remote add origin https://github.com/Arpit8126/pookiz_guide.git

# View remote repositories
git remote -v

# Push local branch to remote (and link with -u)
git push -u origin main

# Subsequent pushes on linked branch
git push

# Fetch latest changes from remote (does NOT merge them)
git fetch origin

# Pull latest changes from remote (fetches and automatically merges)
git pull

# Push to a different remote branch
git push origin local-branch-name:remote-branch-name
```

---

## PART 5: Advanced Git Operations

### Stashing — Save Work Temporarily
Used when you have uncommitted edits but need to switch branches quickly without committing incomplete work.

```bash
# Save uncommitted changes to a temporary stash stack
git stash
git stash -m "WIP: messaging feature" # with label

# List saved stashes
git stash list

# Re-apply the last saved stash and remove it from stack
git stash pop

# Apply stash keeping it on the stack
git stash apply stash@{0}

# Discard stashes
git stash drop stash@{0}      # discard specific stash
git stash clear               # discard all stashes
```

### Rebase — Clean Git History
Integrate changes from one branch into another by applying commits on top of the target branch, keeping history linear.

```bash
git checkout feature-chat
git rebase main
# Commits from feature-chat are temporarily removed, main's updates 
# are pulled in, and feature-chat's commits are re-applied on top.
```
*Rule: Do not rebase commits that have already been pushed to a public/shared repository. Use merge instead.*

### Interactive Rebase — Rewriting History
```bash
# Rewrite/combine/delete the last 4 commits
git rebase -i HEAD~4
```
An editor opens with a list of commits:
- `pick`: Keep commit as-is.
- `reword`: Change commit message.
- `edit`: Stop and edit code in this commit.
- `squash`: Combine this commit with the previous one.
- `drop`: Delete this commit.

### Cherry-Pick — Porting Specific Commits
Apply a specific commit from one branch onto your current branch.

```bash
# Apply commit ABC123 from another branch to current branch
git cherry-pick ABC123
```

### Git Reflog — The Safety Net
Git records every action you take (commit, checkout, reset, merge) in the reference log. If you accidentially run `git reset --hard` and lose commits, you can find them here.

```bash
git reflog
# Find the hash BEFORE you made the mistake (e.g. HEAD@{2})
git reset --hard HEAD@{2}
# Your deleted commits are back!
```

---

## Summary: Essential Git Commands Cheat Sheet

| Command | Action |
|---|---|
| `git status` | Show current state of work directory / staging |
| `git add .` | Stage all changes for commit |
| `git commit -m "msg"` | Create local snapshot of staged files |
| `git push` | Upload local commits to remote server |
| `git pull` | Download and merge remote changes to local |
| `git checkout -b <name>`| Create and switch to new branch |
| `git checkout <name>` | Switch branches |
| `git merge <name>` | Merge target branch into current branch |
| `git stash` | Temporarily save dirty working state |
| `git stash pop` | Restore stashed changes |
```
