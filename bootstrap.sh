#!/bin/bash


function win_install_fonts() {
  local dst_dir
  dst_dir=$(wslpath $(cmd.exe /c 'echo %LOCALAPPDATA%\Microsoft\Windows\Fonts' 2>/dev/null | sed 's/\r$//'))
  mkdir -p "$dst_dir"
  local src
  for src in "$@"; do
    local file=$(basename "$src")
    if [[ ! -f "$dst_dir/$file" ]]; then
      cp -f "$src" "$dst_dir/"
    fi
    local win_path
    win_path=$(wslpath -w "$dst_dir/$file")
    # Install font for the current user. It'll appear in "Font settings".
    reg.exe add                                                 \
      'HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts' \
      /v "${file%.*} (TrueType)" /t REG_SZ /d "$win_path" /f 2>/dev/null
  done
}

# Install a monospace font.
function install_fonts() {
  if [[ $WSL == 1 ]]; then
    win_install_fonts "$HOME"/.local/share/fonts/NerdFonts/*.ttf
  fi
}

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

if [[ $WSL == 1 ]]; then                                       
  echo "- Installing fonts in windows"
  win_inistall_fonts "$HOME"/.local/share/fonts/NerdFonts/*.ttf 
else
  echo "- Installing fonts"
  mkdir -p ~/.local/share/fonts/
  ln -s $DIR/.local/share/fonts/NerdFonts ~/.local/share/fonts/
fi                                                             

echo "- Creating initial directories"
mkdir -p $HOME/src $HOME/bin

init_git
init_zsh
init_vim
change_shell


