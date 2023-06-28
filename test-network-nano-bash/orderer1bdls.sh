#!/usr/bin/env sh
#
# SPDX-License-Identifier: Apache-2.0
#
set -eu

# look for binaries in local dev environment /build/bin directory and then in local samples /bin directory
#setx PATH ${PWD}/../../fabric/build/bin:${PWD}/../bin:$PATH
setx FABRIC_CFG_PATH "${PWD}/../config"

#setx FABRIC_LOGGING_SPEC debug:cauthdsl,policies,msp,common.configtx,common.channelconfig=info
setx ORDERER_GENERAL_LISTENPORT "6050"
setx ORDERER_GENERAL_LOCALMSPID "OrdererMSP"
setx ORDERER_GENERAL_LOCALMSPDIR "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp"
setx ORDERER_GENERAL_TLS_ENABLED "true"
setx ORDERER_GENERAL_TLS_PRIVATEKEY "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key"
setx ORDERER_GENERAL_TLS_CERTIFICATE "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt"
# following setting is not really needed at runtime since channel config has ca root certs, but we need to override the default in orderer.yaml
setx ORDERER_GENERAL_TLS_ROOTCAS "${PWD}/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt"
setx ORDERER_GENERAL_BOOTSTRAPMETHOD "none"
setx ORDERER_CHANNELPARTICIPATION_ENABLED "true"
setx ORDERER_FILELEDGER_LOCATION "${PWD}/data/orderer"
if [ $# -gt 0 ]
then
    if [ "$1" != "BFT" ] && [ "$1" != "etcdraft" ] && [ "$1" != "Bdls" ]
    then
        echo "Unsupported input consensus type ${1}"
        exit 1
    fi
    setx ORDERER_CONSENSUS_TYPE ${1}
fi
setx ORDERER_CONSENSUS_TYPE "Bdls"
setx ORDERER_CONSENSUS_WALDIR "${PWD}/data/orderer/consensus/wal"
setx ORDERER_CONSENSUS_SNAPDIR "${PWD}/data/orderer/consensus/snap"
setx ORDERER_OPERATIONS_LISTENADDRESS "127.0.0.1:8443"
setx ORDERER_ADMIN_LISTENADDRESS "127.0.0.1:9443"

# start orderer
orderer
