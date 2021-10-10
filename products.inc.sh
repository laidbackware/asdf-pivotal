#!/usr/bin/env bash

[[ "${BASH_SOURCE[0]}" != "${0}" ]] || {
  echo "${BASH_SOURCE[0]} should not be called but only sourced." >&2
  exit 1
}

setEnv() {
  local product="${1:-}"
  local v="${2:-}"
  local o="${3:-}"

  case "${product}" in
    bosh)
      REPO_SLUG='cloudfoundry/bosh-cli'
      GIT_FILE_NAME_TEMPLATE="v${v}/bosh-cli-${v}-${o}-amd64"
      VERSION_COMMAND='--version'
      ;;
    credhub)
      REPO_SLUG='cloudfoundry-incubator/credhub-cli'
      GIT_FILE_NAME_TEMPLATE="${v}/credhub-${o}-${v}.tgz"
      VERSION_COMMAND='--version'
      ;;
    fly)
      REPO_SLUG='concourse/concourse'
      GIT_FILE_NAME_TEMPLATE="v${v}/fly-${v}-${o}-amd64.tgz"
      VERSION_COMMAND='--version'
      ;;
    om)
      REPO_SLUG='pivotal-cf/om'
      GIT_FILE_NAME_TEMPLATE="${v}/om-${o}-${v}"
      VERSION_COMMAND='--version'
      ;;
    pivnet)
      REPO_SLUG='pivotal-cf/pivnet-cli'
      GIT_FILE_NAME_TEMPLATE="v${v}/pivnet-${o}-amd64-${v}"
      VERSION_COMMAND='version'
      ;;
    bbr)
      REPO_SLUG='cloudfoundry-incubator/bosh-backup-and-restore'
      GIT_FILE_NAME_TEMPLATE="v${v}/bbr-${v}-${o}-amd64"
      VERSION_COMMAND='--version'
      ;;
    bbr-s3-config-validator)
      REPO_SLUG='cloudfoundry-incubator/bosh-backup-and-restore'
      GIT_FILE_NAME_TEMPLATE="v${v}/bbr-s3-config-validator-${v}-${o}-amd64"
      VERSION_COMMAND='--help'
      ;;
    *)
      echo "Product '${product}' is not currently supported" >&2
      return 2
      ;;
  esac

  declare -rx REPO_SLUG GIT_FILE_NAME_TEMPLATE VERSION_COMMAND
}

setEnv "$@"
