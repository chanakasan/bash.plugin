#!/usr/bin/env bash

set -e

get_dotfiles_path() {
  local user=$(whoami)
  if [ "$user" = "codespace" ]; then
    echo /workspaces/.codespaces/.persistedshare/dotfiles
  else
    echo $HOME/dotfiles
  fi
}

remove_from_bashrc() {
  sed -i '/#__dotfiles_start/,/#__dotfiles_end/{d}' $bashrc
}

copy_to_bashrc() {
  local df_path=$(get_dotfiles_path)
  echo "" >> $bashrc
  echo '#__dotfiles_start' >> $bashrc
  echo 'export chk_dotfiles_path='$df_path >> $bashrc
  echo 'export chk_bash_path=$chk_dotfiles_path/bash' >> $bashrc
  echo 'source $chk_bash_path/main' >> $bashrc
  echo 'source $chk_bash_path/optional' >> $bashrc
  echo ''
  echo 'export PATH=$chk_dotfiles_path/bin:$PATH' >> $bashrc
  echo 'export PATH=$chk_dotfiles_path/mux:$PATH' >> $bashrc
  echo 'export PATH=$chk_dotfiles_path/tmux/bin:$PATH' >> $bashrc
  echo '#__dotfiles_end' >> $bashrc
  echo "" >> $bashrc
}

start_debug() {
  HOME=$hq/box1
}

mark_installed() {
  touch $installed_file
}

check_installed() {
  if [ -f "$installed_file" ]; then
    echo "Error: Already installed"
    echo "Aborted"
    exit 255
  fi
}

do_steps() {
  remove_from_bashrc
  copy_to_bashrc
}

main() {
  # start_debug
  echo "Dotfiles - Installation"
  local root=$HOME
  local bashrc="$root/.bashrc"
  local installed_file=$root/.chk_dotfiles_installed
  do_steps
  echo "Done"
  echo "Please run 'reload'"
  echo ""
}

main
