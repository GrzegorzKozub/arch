ZSH_THEME_GIT_PROMPT_PREFIX=""

ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}✗"

ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

PROMPT='\
%{$fg[cyan]%}%3~%{$reset_color%} \
%{$fg[blue]%}$(git_prompt_behind)$(git_prompt_ahead)$(git_prompt_info)\
%(?:%{$fg[green]%}:%{$fg[red]%})>%{$reset_color%} '

