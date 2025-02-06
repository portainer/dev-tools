#!/bin/bash

# requires jq to run

# strict mode - based on http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

############################################################
# Config                                                   #
############################################################

TESTS="./tests"
USERS="./users.json"

############################################################
# Help                                                     #
############################################################
Help() {
  # Display Help
  echo "Add description of the script functions here."
  echo
  echo "Syntax: scriptTemplate [-g|h|v|V]"
  echo "options:"
  echo "g     Print the GPL license notification."
  echo "h     Print this Help."
  echo "v     Verbose mode."
  echo "V     Print software version and exit."
  echo
}

# Set variables
REMOTE_URL="localhost:9000"

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hu:" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  -u) # Enter a name
    Name=$OPTARG ;;
  \?) # Invalid option
    echo "Error: Invalid option"
    exit
    ;;
  esac
done

echo "hello $Name!"

# walk() {
#   LOC=$1

#   for f in $(find "${LOC}" -type d); do

#     # for f in "$PATH"; do
#     if [[ -d "$f" && ! -L "$f" && "$f" != "${LOC}" ]]; then
#       # $f is a directory and not a symlink
#       echo "DIR > $f"
#       # walk $f
#     elif [[ $f == *.json ]]; then
#       # $f is a file
#       echo "$f"
#     fi
#   done
# }

# walk "${TESTS}"

# # {username: "test", password: "portainer1234", role: 2}
