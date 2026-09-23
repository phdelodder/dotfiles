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
  if [[ -f "$HOME/.gitconfig" ]]; then
    echo "- Git config already installed, leaving \$HOME/.gitconfig as-is"
    return 0
  fi

  echo "- Installing git config"
  if [[ -z "$GIT_NAME" ]]
  then
    if [[ ! -t 0 ]]; then
      echo "$(basename "$0"): no TTY to prompt for a name -- pass --git_name" >&2
      exit 1
    fi
    echo ""
    echo "What's your full name (for git purposes)?"
    read GIT_NAME
  fi
  if [[ -z "$GIT_EMAIL" ]]
  then
    if [[ ! -t 0 ]]; then
      echo "$(basename "$0"): no TTY to prompt for an email -- pass --git_email" >&2
      exit 1
    fi
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
    ln -sfn $DIR/$file $HOME/$file;
  done;

  mkdir -p $HOME/.vim/autoload
  ln -sfn $DIR/modules/vim-plug/plug.vim $HOME/.vim/autoload/plug.vim
}

function init_zsh() {
  echo "- Initializing zsh"
  for file in .zshrc ; do
    ln -sfn $DIR/$file $HOME/$file;
  done;

  ln -sfn $DIR/modules/oh-my-zsh $HOME/.oh-my-zsh

  mkdir -p $HOME/.oh-my-zsh/custom/plugins
  ln -sfn $DIR/modules/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  ln -sfn $DIR/modules/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

  mkdir -p $HOME/.config
  ln -sfn $DIR/starship.toml $HOME/.config/starship.toml
}

function change_shell() {
  [[ "$SHELL" != */zsh ]] || return 0
  chsh -s "$(grep -E '/zsh$' /etc/shells | tail -1)"
}

function install_starship_fallback() {
  # Not packaged for apt on every distro (e.g. Ubuntu 24.04/noble) -- fall
  # back to the official installer, non-interactively.
  curl -sS https://starship.rs/install.sh | "$@" sh -s -- -y
}

function ensure_packages() {
  local missing=()
  for pkg_cmd in git zsh vim curl; do
    command -v "$pkg_cmd" >/dev/null 2>&1 || missing+=("$pkg_cmd")
  done

  local need_starship=0
  command -v starship >/dev/null 2>&1 || need_starship=1

  if [ ${#missing[@]} -eq 0 ] && [ "$need_starship" -eq 0 ]; then
    return 0
  fi

  local as_root=()
  if [[ "$(id -u)" -ne 0 ]]; then
    as_root=(sudo)
  fi

  if ! command -v apt-get >/dev/null 2>&1; then
    [ ${#missing[@]} -gt 0 ] && echo "- Missing packages: ${missing[*]} (no apt-get found, install them manually)"
    [ "$need_starship" -eq 1 ] && install_starship_fallback "${as_root[@]}"
    return 0
  fi

  DEBIAN_FRONTEND=noninteractive "${as_root[@]}" apt-get update -y

  if [ ${#missing[@]} -gt 0 ]; then
    echo "- Installing missing packages: ${missing[*]}"
    DEBIAN_FRONTEND=noninteractive "${as_root[@]}" apt-get install -y "${missing[@]}"
  fi

  if [ "$need_starship" -eq 1 ]; then
    echo "- Installing starship"
    if ! DEBIAN_FRONTEND=noninteractive "${as_root[@]}" apt-get install -y starship 2>/dev/null; then
      echo "  starship isn't packaged for apt here, falling back to the official installer"
      install_starship_fallback "${as_root[@]}"
    fi
  fi
}

echo "Bootstrapping Environment"

# '1' if running under Windows Subsystem for Linux, '0' otherwise.
readonly WSL=$(grep -q Microsoft /proc/version && echo 1 || echo 0)
# Find it's own location
readonly DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

ensure_packages

echo "- Installing fonts"
mkdir -p ~/.local/share/fonts/
FONTS_LINK="$HOME/.local/share/fonts/NerdFonts"
if [ -L "$FONTS_LINK" ]; then
  ln -sfn "$DIR/.local/share/fonts/NerdFonts" "$FONTS_LINK"
elif [ -e "$FONTS_LINK" ]; then
  echo "  $FONTS_LINK already exists and isn't a symlink -- leaving it alone (remove it yourself first if you want this repo's fonts linked in)"
else
  ln -s "$DIR/.local/share/fonts/NerdFonts" "$FONTS_LINK"
fi
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


