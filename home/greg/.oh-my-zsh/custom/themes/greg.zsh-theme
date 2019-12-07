ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg[yellow]%}"

ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX=" %{$fg[red]%}↓"
ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX=" %{$fg[green]%}↑"

user=%{%(!.$fg[red].$fg[green])%}%n%{$reset_color%}
host=%{$fg[yellow]%}%m%{$reset_color%}
dir=%{$fg[cyan]%}%3~%{$reset_color%}

at=%{$terminfo[bold]$fg[grey]%}@%{$reset_color%}
input=%{$terminfo[bold]$fg[grey]%}\>%{$reset_color%}

local function git_prompt() {
  if [[ "$(< /proc/version)" == *@(Microsoft|WSL)* ]]; then return; fi
  if git rev-parse --git-dir > /dev/null 2>&1; then
    echo $(git_branch)$(git_commits)$(git_changes)%{$reset_color%}
  fi
}

local function git_branch() {
  echo %{$fg[blue]%}$(git_remote_status)$(git_current_branch)
}

local function git_commits() {
  remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  if [[ -n ${remote} ]]; then
    echo ""$(git_commits_behind)$(git_commits_ahead)
  fi
}

local function git_changes() {
  IFS=''

  stagedAdded=0
  stagedModified=0
  stagedDeleted=0

  unstagedAdded=0
  unstagedModified=0
  unstagedDeleted=0

  git -c color.status=false status --short | while read line
  do
    if [[ $line =~ '^(\w|\?|\s)(\w|\?|\s).+$' ]]; then

      [[ $match[1] == 'A' ]] && stagedAdded=$((stagedAdded + 1))
      [[ $match[1] == 'M' || $match[1] == 'R' || $match[1] == 'C' ]] && stagedModified=$((stagedModified + 1))
      [[ $match[1] == 'D' ]] && stagedDeleted=$((stagedDeleted + 1))

      [[ $match[2] == 'A' || $match[2] == '?' ]] && unstagedAdded=$((unstagedAdded + 1))
      [[ $match[2] == 'M' ]] && unstagedModified=$((unstagedModified + 1))
      [[ $match[2] == 'D' ]] && unstagedDeleted=$((unstagedDeleted + 1))

    fi
  done

  changes=""

  if [[ $stagedAdded != 0 || $stagedModified != 0 || $stagedDeleted != 0 ]]; then
    changes=" %{$fg[green]%}+$stagedAdded ~$stagedModified -$stagedDeleted"
  fi

  if [[ $unstagedAdded != 0 || $unstagedModified != 0 || $unstagedDeleted != 0 ]]; then
    changes="$changes %{$fg[red]%}+$unstagedAdded ~$unstagedModified -$unstagedDeleted"
  fi

  echo $changes
}

PROMPT='${user}${at}${host} ${dir} $(git_prompt)
${input} '

