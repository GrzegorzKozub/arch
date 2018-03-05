ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg[yellow]%}"

ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX=" %{$fg[red]%}↓"
ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX=" %{$fg[green]%}↑"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}✗"

local function current_dir() {
  echo %{$fg[cyan]%}%3~%{$reset_color%}" "
}

local function git_prompt() {
  if [ -d .git ]; then
    echo $(git_remote_status)$(git_current_branch)$(git_commits_behind)$(git_commits_ahead)$(parse_git_dirty)%{$reset_color%}" "
  fi
}

local function delimiter() {
  echo "> "
}

PROMPT='$(current_dir)$(git_prompt)$(delimiter)'

