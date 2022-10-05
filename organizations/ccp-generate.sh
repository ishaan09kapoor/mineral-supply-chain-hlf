#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=0
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/org0.msc.com/tlsca/tlsca.org0.msc.com-cert.pem
CAPEM=organizations/peerOrganizations/org0.msc.com/ca/ca.org0.msc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org0.msc.com/connection-org0.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org0.msc.com/connection-org0.yaml

ORG=1-1
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/org1-1.msc.com/tlsca/tlsca.org1-1.msc.com-cert.pem
CAPEM=organizations/peerOrganizations/org1-1.msc.com/ca/ca.org1-1.msc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org1-1.msc.com/connection-org1-1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org1-1.msc.com/connection-org1-1.yaml

ORG=1-2
P0PORT=11051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/org1-2.msc.com/tlsca/tlsca.org1-2.msc.com-cert.pem
CAPEM=organizations/peerOrganizations/org1-2.msc.com/ca/ca.org1-2.msc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org1-2.msc.com/connection-org1-2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org1-2.msc.com/connection-org1-2.yaml

ORG=2-1
P0PORT=13051
CAPORT=10054
PEERPEM=organizations/peerOrganizations/org2-1.msc.com/tlsca/tlsca.org2-1.msc.com-cert.pem
CAPEM=organizations/peerOrganizations/org2-1.msc.com/ca/ca.org2-1.msc.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org2-1.msc.com/connection-org2-1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/org2-1.msc.com/connection-org2-1.yaml
