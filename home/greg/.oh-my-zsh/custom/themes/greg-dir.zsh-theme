local function current_dir() {
  echo %{$fg[cyan]%}%3~%{$reset_color%}" "
}

PROMPT='$(current_dir)'

