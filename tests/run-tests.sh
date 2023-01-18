#!/bin/bash

# This set of tests must be run in a clean environment
# It can either be run in docker of github actions

. $HOME/.asdf/asdf.sh

[[ -z ${DEBUGX:-} ]] || set -x
set -euo pipefail

sep=" "
[[ -z ${ASDF_LEGACY:-} ]] || sep="-"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
repo_dir="$script_dir/.."



function test_plugin() {
  local plugin_name=$1
  local version_command
  case $plugin_name in
    bosh)
      version_command="--version"
      ;;
    credhub)
      version_command="--version"
      ;;
    fly)
      version_command="--version"
      ;;
    om)
      version_command="--version"
      ;;
    pivnet)
      version_command="version"
      ;;
    *)
      echo "Product ${file_name} is not currently supported"
      exit 1
      ;;
  esac

  echo -e "\n#########################################"
  echo -e "####### Starting: ${plugin_name}\n"

  echo "Adding plugin $plugin_name"
  mkdir -p ${HOME}/.asdf/plugins/${plugin_name}
  cp -r $repo_dir ${HOME}/.asdf/plugins/${plugin_name}

  echo "Listing $plugin_name"
  asdf list${sep}all $plugin_name

  if [[ -z ${ASDF_LEGACY:-} ]]; then
    echo "Installing $plugin_name"
    asdf install $plugin_name latest
  else
    plugin_version=$(asdf list${sep}all $plugin_name |tail -1)
    echo "Installing $plugin_name $plugin_version"
    asdf install $plugin_name $plugin_version
  fi

  installed_version=$(asdf list $plugin_name | xargs)
  asdf global $plugin_name $installed_version

  if [[ $version_command != "test_not_possible" ]]; then
    echo -e "\nChecking $plugin_name is executable"
    echo "Running command '$plugin_name $version_command'"
    eval "$plugin_name $version_command"
  fi

  echo -e "\n####### Finished: $plugin_name"
  echo -e "#########################################\n"
}

function test_plugins() {
  plugin_name=${1:-}
  if [ -z "${plugin_name:-}" ]; then
    test_plugin om
    test_plugin pivnet
    test_plugin bosh
    test_plugin credhub
    test_plugin fly
  else
    test_plugin $plugin_name
  fi
}

test_plugins ${1:-}