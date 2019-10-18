# phdelodder.zsh-theme

PROMPT='%{$fg[green]%}[%{$fg_bold[white]%}%n%{$reset_color%}%{$fg[green]%}@%{$fg_bold[white]%}%M%{$reset_color%}%{$fg[green]%}]%{$fg[white]%}-%{$fg[green]%}(%{$fg_bold[white]%}%~%{$reset_color%}%{$fg[green]%})$(git_prompt_info)$(svn_prompt_info)
➜ % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="-[%{$reset_color%}%{$fg[white]%}git://%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[green]%}]-"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"

SVN_SHOW_BRANCH="true"
ZSH_THEME_SVN_PROMPT_PREFIX="-[%{$reset_color%}%{$fg[white]%}svn://%{$fg_bold[white]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX=""
ZSH_THEME_SVN_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%} %{$fg[green]%}]-"
ZSH_THEME_SVN_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%} %{$fg[green]%}]-"

