#!/bin/bash

usage(){
echo "\
$(basename "$0") [OPTION...]
-n, --git_name; Set GIT Name with argument
-e, --git_email; Set GIT Email with argument
--chsh; Set chsh to true
" | column -t -s ";"
}

# Error message
error(){
    echo "$(basename "$0"): invalid option -- '$1'";
    echo "Try '$(basename "$0") -h' for more information.";
    exit 1;
}

while [ -n "$1" ]; do
    case "$1" in
        -n|--git_name)  GIT_NAME="$2"; shift 2;;
        -e|--git_email) GIT_EMAIL="$2"; shift 2;;
        --chsh)         CHSH=1; shift;;
        -h|--help)      usage; exit 0;;
        *)              error "$1";;
    esac
done

function init_git() {
  echo "- Installing git config"
  if [[ -z "$GIT_NAME" ]]
  then
    echo ""
    echo "What's your full name (for git purposes)?"
    read GIT_NAME
  fi
  if [[ -z "$GIT_EMAIL" ]]
  then
    echo ""
    echo "What's your email address?"
    read GIT_EMAIL
  fi

  for file in .gitignore .gitconfig; do
    cp -p $DIR/$file $HOME/$file;
  done;

  # replace the placeholders in .gitconfig with user input
  sed -i -e "s/GIT_NAME/$GIT_NAME/g" $HOME/.gitconfig
  sed -i -e "s/GIT_EMAIL/$GIT_EMAIL/g" $HOME/.gitconfig
}

function init_vim() {
  echo "- Initializing vim"
  for file in .vimrc ; do
    ln -sf $DIR/$file $HOME/$file;
  done;
}

function init_zsh() {
  echo "- Initializing zsh"
  for file in .zshrc .p10k.zsh ; do
    ln -sf $DIR/$file $HOME/$file;
  done;

  ln -sf $DIR/modules/oh-my-zsh $HOME/.oh-my-zsh
  ln -sf $DIR/modules/powerlevel10k $HOME/.oh-my-zsh/themes/powerlevel10k
  ln -sf $DIR/zsh-themes/*.zsh-theme $HOME/.oh-my-zsh/themes/
}

function change_shell() {
  [[ "$SHELL" != */zsh ]] || return 0
  chsh -s "$(grep -E '/zsh$' /etc/shells | tail -1)"
}

echo "Bootstrapping Environment"

# '1' if running under Windows Subsystem for Linux, '0' otherwise.
readonly WSL=$(grep -q Microsoft /proc/version && echo 1 || echo 0)
# Find it's own location
readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "- Installing fonts"
mkdir -p ~/.local/share/fonts/
ln -s $DIR/.local/share/fonts/NerdFonts ~/.local/share/fonts/
if [[ $WSL == 1 ]]; then                                       
  echo "- Installing fonts in windows"
  echo " Don't forget to install them manually, you need to fix this!"
fi                                                             

echo "- Creating initial directories"
mkdir -p $HOME/src $HOME/bin

init_git
init_zsh
init_vim

if [[ -z "$CHSH" ]]; then 
  change_shell
fi


