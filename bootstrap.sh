#!/bin/bash

function init_git() {
  echo "- Installing git config"
  echo ""
  echo "What's your full name (for git purposes)?"
  read full_name
  echo ""
  echo "What's your email address?"
  read email

  for file in .gitignore .gitconfig; do
    cp -p $DIR/$file $HOME/$file;
  done;

  # replace the placeholders in .gitconfig with user input
  sed -i -e "s/GIT_NAME/$full_name/g" $HOME/.gitconfig
  sed -i -e "s/GIT_EMAIL/$email/g" $HOME/.gitconfig
}

function init_vim() {
  echo "- Initializing vim"
  for file in .vimrc ; do
    ln -s $DIR/$file $HOME/$file;
  done;
}

function init_zsh() {
  echo "- Initializing zsh"
  for file in .zshrc .p10k.zsh ; do
    ln -s $DIR/$file $HOME/$file;
  done;

  ln -s $DIR/modules/oh-my-zsh $HOME/.oh-my-zsh
  ln -s $DIR/modules/powerlevel10k $HOME/.oh-my-zsh/themes/powerlevel10k
  curl -L https://git.io/fjuUx -o  $HOME/.oh-my-zsh/themes/nox.zsh-theme
  ln -s $DIR/zsh-themes/*.theme $HOME/.oh-my-zsh/themes/
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
change_shell


