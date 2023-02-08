#!/bin/bash

# Intructions
# This test is designed to be run from the root of the project in a docker container:
#	$ docker run -v ${PWD}/bin:/buildpack-apt -v ${PWD}/e2e/e2e.sh:/e2e/e2e.sh ubuntu:latest /e2e/e2e.sh


#################
#     Utils
#################
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
check_file_exists() {
  local file_path="$1"
  if [[ ! -f "${file_path}" ]]; then
    echo -e "${RED}Error: file not found:${NC} ${LRED}${file_path}${NC}" >&2
	return 1
  fi
}
assert_file_exists() {
	check_file_exists "$1" || exit 1
}

check_file_content() {
  local file_path="$1"
  local expected_content="$2"

  check_file_exists "$file_path" || return 1

  local file_content
  file_content="$(cat "${file_path}")"

  if [[ "${file_content}" != "${expected_content}" ]]; then
    echo -e "${RED}Error: file content mismatch${NC}" >&2
    echo -e "${RED}File:${NC}\t\t${LRED}${file_path}${NC}" >&2
    echo -e "${RED}Expected:${NC}\t${LRED}'${expected_content}'${NC}" >&2
    echo -e "${RED}Actual:${NC}\t\t${LRED}'${file_content}'${NC}" >&2
	return 1
  fi
}
assert_file_content() {
	check_file_content "$1" "$2" || exit 1
}

#################
#     Setup
#################
stack_id="e2e-test-stack-$(date +%s)"
buildsh=/buildpack-apt/build
assert_file_exists $buildsh
layer_dir=/e2e/layers
mkdir /workspace
cd /workspace || exit 1
echo tree > Aptfile
assert_file_content "Aptfile" "tree"

#################
#    Execute
#################
CNB_STACK_ID="${stack_id}" "$buildsh" "$layer_dir" aptgetversion

#################
#    Validate
#################
apt_dir="${layer_dir}/apt"
assert_file_content "${apt_dir}/Aptfile" "tree"
assert_file_content "${apt_dir}/STACK" "$stack_id"
assert_file_exists "${apt_dir}/usr/bin/tree"

# if we get here the tests passed
echo -e "\n\n🎉 ${GREEN}e2e tests passed successfully!${NC}"
