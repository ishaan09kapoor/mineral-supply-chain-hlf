#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

# imports
. scripts/utils.sh

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/msc.com/tlsca/tlsca.msc.com-cert.pem
export PEER0_ORG0_CA=${PWD}/organizations/peerOrganizations/org0.msc.com/tlsca/tlsca.org0.msc.com-cert.pem
export PEER0_ORG1_1_CA=${PWD}/organizations/peerOrganizations/org1-1.msc.com/tlsca/tlsca.org1-1.msc.com-cert.pem
export PEER0_ORG1_2_CA=${PWD}/organizations/peerOrganizations/org1-2.msc.com/tlsca/tlsca.org1-2.msc.com-cert.pem
export PEER0_ORG2_1_CA=${PWD}/organizations/peerOrganizations/org2-1.msc.com/tlsca/tlsca.org2-1.msc.com-cert.pem
export ORDERER_ADMIN_TLS_SIGN_CERT=${PWD}/organizations/ordererOrganizations/msc.com/orderers/rmi.msc.com/tls/server.crt
export ORDERER_ADMIN_TLS_PRIVATE_KEY=${PWD}/organizations/ordererOrganizations/msc.com/orderers/rmi.msc.com/tls/server.key

# Set environment variables for the peer org
setGlobals() {
  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  infoln "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 0 ]; then
    export CORE_PEER_LOCALMSPID="Org0MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG0_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org0.msc.com/users/Admin@org0.msc.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
  elif [ $USING_ORG -eq 1 ]; then
    USING_ORG='1_1'
    export CORE_PEER_LOCALMSPID="Org1-1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1-1.msc.com/users/Admin@org1-1.msc.com/msp
    export CORE_PEER_ADDRESS=localhost:9051

  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org1-2MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_2_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1-2.msc.com/users/Admin@org1-2.msc.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
    

  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_LOCALMSPID="Org2-1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2-1.msc.com/users/Admin@org2-1.msc.com/msp
    export CORE_PEER_ADDRESS=localhost:13051
  else
    errorln "ORG Unknown"
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# Set environment variables for use in the CLI container
setGlobalsCLI() {
  setGlobals $1

  local USING_ORG=""
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  if [ $USING_ORG -eq 0 ]; then
    export CORE_PEER_ADDRESS=peer0.org0.msc.com:7051
  elif [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_ADDRESS=peer0.org1-1.msc.com:9051
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_ADDRESS=peer0.org1-2.msc.com:11051
  elif [ $USING_ORG -eq 3 ]; then
    export CORE_PEER_ADDRESS=peer0.org2-1.msc.com:13051
  else
    errorln "ORG Unknown"
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
parsePeerConnectionParameters() {
  PEER_CONN_PARMS=()

  PEERS=""
  while [ "$#" -gt 0 ]; do
    setGlobals $1
    if [ $ORG -eq 0 ]; then
  	export ORG_1="Org0"
  	export ORG_2="Org0"
  elif [ $ORG -eq 1 ]; then
  	export ORG_1="Org1-1"
  	export ORG_2="Org1_1"
  elif [ $ORG -eq 2 ]; then
  	export ORG_1="Org1-2"
  	export ORG_2="Org2_1"
  elif [ $ORG -eq 3 ]; then
  	export ORG_1="Org2-1"
  	export ORG_2="Org2_1"
  else
    errorln "ORG Unknown"
  fi
    PEER="peer0.$ORG_1"
    ## Set peer addresses
    if [ -z "$PEERS" ]
    then
	PEERS="$PEER"
    else
	PEERS="$PEERS $PEER"
    fi
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" --peerAddresses $CORE_PEER_ADDRESS)
    ## Set path to TLS certificate
    CA=$CORE_PEER_TLS_ROOTCERT_FILE
    TLSINFO=(--tlsRootCertFiles "${CA}")
    infoln ${CA} 
    PEER_CONN_PARMS=("${PEER_CONN_PARMS[@]}" "${TLSINFO[@]}")
    # shift by one to get to the next organization
    shift
  done
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    fatalln "$2"
  fi
}
