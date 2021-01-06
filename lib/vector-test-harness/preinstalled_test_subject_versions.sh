# vi: syntax=bash
# shellcheck shell=bash

# WARNING!
#
# Do not rely on version information from this file when runing tests.
# These versions are intended to be used only during the AMI build.
#
# This file is not loaded by default during lib initialization.

PREINSTALLED_TEST_SUBJECT_VERSION_heka="3_6_0.4"
PREINSTALLED_TEST_SUBJECT_VERSION_filebeat="7.10.1"
PREINSTALLED_TEST_SUBJECT_VERSION_fluentbit="1.6.9"
PREINSTALLED_TEST_SUBJECT_VERSION_fluentd="4.0.1"
PREINSTALLED_TEST_SUBJECT_VERSION_logstash="7.10.1"
PREINSTALLED_TEST_SUBJECT_VERSION_splunk_heavy_forwarder="8.1.1-08187535c166"
PREINSTALLED_TEST_SUBJECT_VERSION_splunk_universal_forwarder="8.1.1-08187535c166"
PREINSTALLED_TEST_SUBJECT_VERSION_telegraf="1.11.0-1"

print_preinstalled_test_subject_versions() {
  local PREFIX="${1:-""}"
  local VERSION_VAR

  for SUBJECT in "${TEST_SUBJECT_NAMES[@]}"; do
    VERSION_VAR="PREINSTALLED_TEST_SUBJECT_VERSION_${SUBJECT}"
    if [[ -n "${!VERSION_VAR:-""}" ]]; then
      echo "${PREFIX}${SUBJECT}: ${!VERSION_VAR}"
    fi
  done
}

prepare_preinstalled_test_subject_versions_ansible_vars() {
  local VERSION_VAR

  PREINSTALLED_TEST_SUBJECT_VERSIONS_ANSIBLE_VARS=""

  for SUBJECT in "${TEST_SUBJECT_NAMES[@]}"; do
    VERSION_VAR="PREINSTALLED_TEST_SUBJECT_VERSION_${SUBJECT}"
    if [[ -n "${!VERSION_VAR:-""}" ]]; then
      PREINSTALLED_TEST_SUBJECT_VERSIONS_ANSIBLE_VARS="$PREINSTALLED_TEST_SUBJECT_VERSIONS_ANSIBLE_VARS preinstalled_${SUBJECT}_version=${!VERSION_VAR}"
    fi
  done
}
