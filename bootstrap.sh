#!/bin/bash

# Option defaulttring
# This string needs to be updated with the single character options (e.g. -f)
opts="fvo:"

usage(){
echo "\
`cmd` [OPTION...]
-n, --git_name; Set GIT Name with argument
-e, --git_email; Set GIT Email with argument
--chsh; Set chsh to true
" | column -t -s ";"
}


# Error message
error(){
    echo "`cmd`: invalid option -- '$1'";
    echo "Try '`cmd` -h' for more information.";
    exit 1;
}

# There's two passes here. The first pass handles the long options and
# any short option that is already in canonical form. The second pass
# uses `getopt` to canonicalize any remaining short options and handle
# them
for pass in 1 2; do
    while [ -n "$1" ]; do
        case $1 in
            --) shift; break;;
            -*) case $1 in
                --chsh)		  CHSH=1;;
		-n| --git_name)  GIT_NAME=$2; shift;;
		-e| --git_email) GIT_EMAIL=$2; shift;;
                --*)           error $1;;
                -*)            if [ $pass -eq 1 ]; then ARGS="$ARGS $1";
                               else error $1; fi;;
                esac;;
            *)  if [ $pass -eq 1 ]; then ARGS="$ARGS $1";
                else error $1; fi;;
        esac
        shift
    done
    if [ $pass -eq 1 ]; then ARGS=`getopt $opts $ARGS`
        if [ $? != 0 ]; then usage; exit 2; fi; set -- $ARGS
    fi
done

# Handle positional arguments
if [ -n "$*" ]; then
    echo "`cmd`: Extra arguments -- $*"
    echo "Try '`cmd` -h' for more information."
    exit 1
fi

function init_git() {
  echo "- Installing git config"
  if [[ -z "$GIT_NAME" ]]
  then
    echo ""
    echo "What's your full name (for git purposes)?"
 i   read GIT_NAME
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

if [[ -z "$CHSH" ]]; then 
  change_shell
fi


