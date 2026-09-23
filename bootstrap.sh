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

  mkdir -p $HOME/.vim/autoload
  ln -sf $DIR/modules/vim-plug/plug.vim $HOME/.vim/autoload/plug.vim
}

function init_zsh() {
  echo "- Initializing zsh"
  for file in .zshrc .p10k.zsh ; do
    ln -sf $DIR/$file $HOME/$file;
  done;

  ln -sf $DIR/modules/oh-my-zsh $HOME/.oh-my-zsh
  ln -sf $DIR/modules/powerlevel10k $HOME/.oh-my-zsh/themes/powerlevel10k
  ln -sf $DIR/zsh-themes/*.zsh-theme $HOME/.oh-my-zsh/themes/

  mkdir -p $HOME/.oh-my-zsh/custom/plugins
  ln -sf $DIR/modules/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  ln -sf $DIR/modules/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
}

function change_shell() {
  [[ "$SHELL" != */zsh ]] || return 0
  chsh -s "$(grep -E '/zsh$' /etc/shells | tail -1)"
}

function ensure_packages() {
  local missing=()
  for pkg_cmd in git zsh vim; do
    command -v "$pkg_cmd" >/dev/null 2>&1 || missing+=("$pkg_cmd")
  done

  if [ ${#missing[@]} -eq 0 ]; then
    return 0
  fi

  if ! command -v apt-get >/dev/null 2>&1; then
    echo "- Missing packages: ${missing[*]} (no apt-get found, install them manually)"
    return 0
  fi

  echo "- Installing missing packages: ${missing[*]}"
  sudo apt-get update -y
  sudo apt-get install -y "${missing[@]}"
}

echo "Bootstrapping Environment"

# '1' if running under Windows Subsystem for Linux, '0' otherwise.
readonly WSL=$(grep -q Microsoft /proc/version && echo 1 || echo 0)
# Find it's own location
readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ensure_packages

echo "- Installing fonts"
mkdir -p ~/.local/share/fonts/
ln -sf $DIR/.local/share/fonts/NerdFonts ~/.local/share/fonts/
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


