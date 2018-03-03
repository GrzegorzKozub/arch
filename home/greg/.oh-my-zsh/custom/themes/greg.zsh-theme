PROMPT='${_current_dir} $(git_prompt_info)
${_return_status} '

local _current_dir="%{$fg[cyan]%}%5~%{$reset_color%}"
local _return_status="%(?:%{$fg[green]%}:%{$fg[red]%})>%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"

