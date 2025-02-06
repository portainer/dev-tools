#!/usr/bin/env bash

# Script used to deploy the Portainer Edge agent inside a Nomad cluster.

# Requires:
# curl
# nomad

### COLOR OUTPUT ###

ESeq="\x1b["
RCol="$ESeq"'0m'    # Text Reset

# Regular               Bold                    Underline               High Intensity          BoldHigh Intens         Background              High Intensity Backgrounds
Bla="$ESeq"'0;30m';     BBla="$ESeq"'1;30m';    UBla="$ESeq"'4;30m';    IBla="$ESeq"'0;90m';    BIBla="$ESeq"'1;90m';   On_Bla="$ESeq"'40m';    On_IBla="$ESeq"'0;100m';
Red="$ESeq"'0;31m';     BRed="$ESeq"'1;31m';    URed="$ESeq"'4;31m';    IRed="$ESeq"'0;91m';    BIRed="$ESeq"'1;91m';   On_Red="$ESeq"'41m';    On_IRed="$ESeq"'0;101m';
Gre="$ESeq"'0;32m';     BGre="$ESeq"'1;32m';    UGre="$ESeq"'4;32m';    IGre="$ESeq"'0;92m';    BIGre="$ESeq"'1;92m';   On_Gre="$ESeq"'42m';    On_IGre="$ESeq"'0;102m';
Yel="$ESeq"'0;33m';     BYel="$ESeq"'1;33m';    UYel="$ESeq"'4;33m';    IYel="$ESeq"'0;93m';    BIYel="$ESeq"'1;93m';   On_Yel="$ESeq"'43m';    On_IYel="$ESeq"'0;103m';
Blu="$ESeq"'0;34m';     BBlu="$ESeq"'1;34m';    UBlu="$ESeq"'4;34m';    IBlu="$ESeq"'0;94m';    BIBlu="$ESeq"'1;94m';   On_Blu="$ESeq"'44m';    On_IBlu="$ESeq"'0;104m';
Pur="$ESeq"'0;35m';     BPur="$ESeq"'1;35m';    UPur="$ESeq"'4;35m';    IPur="$ESeq"'0;95m';    BIPur="$ESeq"'1;95m';   On_Pur="$ESeq"'45m';    On_IPur="$ESeq"'0;105m';
Cya="$ESeq"'0;36m';     BCya="$ESeq"'1;36m';    UCya="$ESeq"'4;36m';    ICya="$ESeq"'0;96m';    BICya="$ESeq"'1;96m';   On_Cya="$ESeq"'46m';    On_ICya="$ESeq"'0;106m';
Whi="$ESeq"'0;37m';     BWhi="$ESeq"'1;37m';    UWhi="$ESeq"'4;37m';    IWhi="$ESeq"'0;97m';    BIWhi="$ESeq"'1;97m';   On_Whi="$ESeq"'47m';    On_IWhi="$ESeq"'0;107m';

printSection() {
  echo -e "${BIYel}>>>> ${BIWhi}${1}${RCol}"
}

info() {
  echo -e "${BIWhi}${1}${RCol}"
}

success() {
  echo -e "${BIGre}${1}${RCol}"
}

error() {
  echo -e "${BIRed}${1}${RCol}"
}

errorAndExit() {
  echo -e "${BIRed}${1}${RCol}"
  exit 1
}

### !COLOR OUTPUT ###

main() {
    if [[ $# -lt 5 ]]; then
      error "Not enough arguments"
      error "Usage: ${0} <NOMAD_TOKEN> <EDGE_ID> <EDGE_KEY> <EDGE_INSECURE_POLL> <ENV_VARS> <AGENT_SECRET>"
      exit 1
    fi

    local NOMAD_TOKEN="$1"
    local EDGE_ID="$2"
    local EDGE_KEY="$3"
    local EDGE_INSECURE_POLL="$4"
    local ENV_VARS="$5"
    local AGENT_SECRET="$6"

    local default_nomad_addr="http://127.0.0.1:4646"
    local nomad_addr=${NOMAD_ADDR:-$default_nomad_addr}
    local job_file_name="portainer-agent-edge-nomad.hcl"
    local datacenter


    [[ "$(command -v curl)" ]] || errorAndExit "Unable to find curl binary. Please ensure curl is installed before running this script."
    [[ "$(command -v nomad)" ]] || errorAndExit "Unable to find nomad binary. Please ensure nomad is installed before running this script."
    [[ "$(command -v grep)" ]] || errorAndExit "Unable to find grep binary. Please ensure grep is installed before running this script."

    info "Downloading agent job spec..."
    curl -L https://downloads.portainer.io/ee2-13/portainer-agent-edge-nomad.hcl -o $job_file_name || errorAndExit "Unable to download agent jobspec"

    # if env vars is a valid string, try to append them to env section in the agent job file
    if [ ! -z "$ENV_VARS" ]; then
        if [ -f "portainer-agent-edge-nomad-new.hcl" ]; then
            rm portainer-agent-edge-nomad-new.hcl
        fi

        # split env vars into an arry
        IFS=',' read -r -a vars <<< "$ENV_VARS"

        local append=0

        while read line || [ -n "$line" ]; do
          if [ $append -eq 1 ]; then
            for var in "${vars[@]}"; do
                IFS='=' read -r -a temp <<< "$var"
                echo "${temp[0]} = \"${temp[1]}\"" >> portainer-agent-edge-nomad-new.hcl
            done
            append=0
          fi

          echo "$line" >> portainer-agent-edge-nomad-new.hcl

          if [[ $line == env* ]]; then
            append=1
          fi
        done < $job_file_name

        job_file_name="portainer-agent-edge-nomad-new.hcl"
    fi

    # try to retrieve node info to get datacenter info
    local node_info=$(nomad node status -address "$nomad_addr" -token "$NOMAD_TOKEN" -self | grep DC)
    IFS='=' read -r -a temp <<< "$node_info"
    datacenter=$(echo ${temp[1]##*( )})
    datacenter=$(echo ${datacenter%%*( )})



    info "Deploying agent..."
    ${NOMAD_ADDR:-}
    nomad job run -address "$nomad_addr" -token "$NOMAD_TOKEN" \
    -var "NOMAD_TOKEN=$NOMAD_TOKEN" -var "EDGE_ID=$EDGE_ID" -var "EDGE_KEY=$EDGE_KEY" -var "EDGE_INSECURE_POLL=$EDGE_INSECURE_POLL" -var "DC=$datacenter" -var "AGENT_SECRET=$AGENT_SECRET" \
    $job_file_name || errorAndExit "Unable to deploy agent jobspec"

    success "Portainer Edge agent successfully deployed"
    exit 0
}

main "$@"
