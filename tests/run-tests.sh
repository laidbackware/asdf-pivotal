#!/bin/bash

# This set of tests must be run in a clean environment
# It can either be run in docker of github actions

set -exo pipefail

[[ -z ${DEBUGX:-} ]] || set -x
trap 'set +x' EXIT

sep=" "
[[ -z ${ASDF_LEGACY:-} ]] || sep="-"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. $HOME/.asdf/asdf.sh

repo_dir=$HOME/.asdf/repository/plugins
plugin_text="repository = https://github.com/laidbackware/asdf-github-tools"

function test_plugin() {
  plugin_name=$1
  version_command=$2

  echo -e "\n#########################################"
  echo -e "####### Starting: ${plugin_name}\n"


  echo $plugin_text > ${repo_dir}/$plugin_name
  asdf plugin${sep}add $plugin_name

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

test_plugin antctl test_not_possible
test_plugin bosh --version
test_plugin credhub --version
test_plugin fly --version
test_plugin govc version
test_plugin om --version
test_plugin pivnet version
test_plugin s5cmd version
