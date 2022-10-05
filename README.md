# Mineral Supply Chain Traceability using Blockchain

## Introduction
This projecct aims to leverage blockchain technology to implement traceability within the mineral supply chain (msc). The system was built on top of Hyperledger Fabric Opensource framework developed by IBM technologies. This Proof of Concept is part of the author's Master's thesis for the completion of his degree in Master's in Mining Engineering. 

## About the document
This markdown guides the reader through the various components of the code and how can they imlement it on their end. The doocumentation assumes you have basic knowledge of blockchain technology and can impliment a hyperledger-fabric test-network at your end. It also assumes that you have the necessary prerequesites in docker, docker-compose and git.  

## About the Blockchain
The exisitng blockchain has 4 peer orgainizations namely, org0.msc.com, org1-1.msc.com, org1-2.msc.com,and org2-1.msc.com. Apart from this we also have an orderer organisation which can be reached at rmi.msc.com. Each organization has one peer node with the name of peer0. 

For our proof of concept, we used only one orderer organisation, Responsible Mineral Initiative (rmi). More orderers can be setup and generted by following the instructions given in section _____. Similarly more organizations can join the mineral supply chain following the instructions in section ____.

## Running the Blockchain
In this section, we explain how one can run the msc blockchain on their organizational devices. 

### Starting the network

Before you can deploy the test network, you need to follow the instructions to [Install the Samples, Binaries and Docker Images](https://hyperledger-fabric.readthedocs.io/en/latest/install.html) in the Hyperledger Fabric documentation.

To get the relevant hyperledger fabric dependnecies run the following commands:
```
mkdir -p $HOME/go/src/github.com/<your_github_userid>
cd $HOME/go/src/github.com/<your_github_userid>
curl -sSL https://bit.ly/2ysbOFE | bash -s
```

This way you will clone and run the relevant dependencies on your machine. By using the -s flag, you are ignoring downloading the samples. Once all dependencies have been installed, you can download the msc blockchain sourcecode by running the following commands:
```
cd fabric-samples
git clone https://github.com/ishaan09kapoor/mineral-supply-chain-hlf
git checkout master
cd msc
```

After setting up the msc repository onto your machine, you can run the blockchain using the following commands:
```
./network.sh up createChannel -c <name-of-mineral-for-which-you-are-creating-the-channel>
```
Once the network is up and running, you can deploy the chaincode on each of the peers and node. To deploy the chaincode, run the following commands:
```
./network.sh deployCC -ccn <name_of_organization> -ccp ./rmi-chaincode-go -ccv <version_of_chaincode> -ccl go -c '<name_of_channel>'
```
### Using the Peer commands to execute Chaincode
Once the chaincode has been deployed on our node, we need to initialise the chaincode in order to execute our use case. To initialise the chaincode, we first need to set the environment variables. For each peer node the environment will need to be set. The same can be achieved by executing the following set of commands for various organisations
#### Org0:
```
export PATH=${PWD}/../bin/:$PATH
cd ~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/
export FABRIC_CFG_PATH=${PWD}/configtx/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org0MSP" 
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org0.msc.com/users/User1@org0.msc.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org0.msc.com/peers/peer0.org0.msc.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:7051
export TARGET_TLS_OPTIONS=(-o localhost:7050 ordererTLSHostnameOverride rmi.msc.com --tls --cafile "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/ordererOrganizations/msc.com/msp/tlscacerts/tlsca.msc.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles /home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org0.msc.com/peers/peer0.org0.msc.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-1.msc.com/peers/peer0.org1-1.msc.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-2.msc.com/peers/peer0.org1-2.msc.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org2-1.msc.com/peers/peer0.org2-1.msc.com/tls/ca.crt")
```
Similarly, open 4 more terminals, one for each organisation and export the following properties for each organisation. 
#### Org1-1:
```
cd ~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/
export PATH=${PWD}/../bin/:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1-1MSP" 
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1-1.msc.com/users/User1@org1-1.msc.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-1.msc.com/peers/peer0.org1-1.msc.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:9051
export TARGET_TLS_OPTIONS=(-o localhost:7050 ordererTLSHostnameOverride rmi.msc.com --tls --cafile "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/ordererOrganizations/msc.com/msp/tlscacerts/tlsca.msc.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles /home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org0.msc.com/peers/peer0.org0.msc.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-1.msc.com/peers/peer0.org1-1.msc.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-2.msc.com/peers/peer0.org1-2.msc.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org2-1.msc.com/peers/peer0.org2-1.msc.com/tls/ca.crt")
```
#### Org1-2:
```
cd ~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/
export PATH=${PWD}/../bin/:$PATH
export FABRIC_CFG_PATH=${PWD}/configtx/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1-2MSP" 
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1-2.msc.com/users/User1@org1-2.msc.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-2.msc.com/peers/peer0.org1-2.msc.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:11051
export TARGET_TLS_OPTIONS=(-o localhost:7050 ordererTLSHostnameOverride rmi.msc.com --tls --cafile "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/ordererOrganizations/msc.com/msp/tlscacerts/tlsca.msc.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles /home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org0.msc.com/peers/peer0.org0.msc.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-1.msc.com/peers/peer0.org1-1.msc.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-2.msc.com/peers/peer0.org1-2.msc.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org2-1.msc.com/peers/peer0.org2-1.msc.com/tls/ca.crt")
```

#### Org2-1:
```
export PATH=${PWD}/../bin/:$PATH
cd ~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/
export FABRIC_CFG_PATH=${PWD}/configtx/
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org2-1MSP" 
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2-1.msc.com/users/User1@org2-1.msc.com/msp
export CORE_PEER_TLS_ROOTCERT_FILE=~/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org2-1.msc.com/peers/peer0.org2-1.msc.com/tls/ca.crt
export CORE_PEER_ADDRESS=localhost:13051
export TARGET_TLS_OPTIONS=(-o localhost:7050 ordererTLSHostnameOverride rmi.msc.com --tls --cafile "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/ordererOrganizations/msc.com/msp/tlscacerts/tlsca.msc.com-cert.pem" --peerAddresses localhost:7051 --tlsRootCertFiles /home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org0.msc.com/peers/peer0.org0.msc.com/tls/ca.crt --peerAddresses localhost:9051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-1.msc.com/peers/peer0.org1-1.msc.com/tls/ca.crt" --peerAddresses localhost:11051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org1-2.msc.com/peers/peer0.org1-2.msc.com/tls/ca.crt" --peerAddresses localhost:13051 --tlsRootCertFiles "/home/ishaan/go/src/github.com/ishaan09kapoor/fabric-samples/msc/organizations/peerOrganizations/org2-1.msc.com/peers/peer0.org2-1.msc.com/tls/ca.crt")

```
Once we have set up our environment, we can initialise our chaincode using the following set of commands in terminal for Org0:
```
peer chaincode invoke "${TARGET_TLS_OPTIONS[@]}" -C <channel_name> -n <organization_name> -c '{"function": "Initialize", "Args": ["dummy_value_1", "dummy_symbol"]}'
```
Once we have initialised our chaincode, we can now mint some tokens. Continue on the terminal for Org0. **Note: This will not work on any terminal other than that of Org0 and any token you want has to be minted from Org0's terminal.** To mint tokens, run the following peer command:
```
peer chaincode invoke "${TARGET_TLS_OPTIONS[@]}" -C <channel_name> -n <organization_name> -c '{"function": "Mint", "Args": ["<amt>"]}'
```
This will generate a UTXO_Key that will represent this transaction. Whenever you want to make a new transaction, you will need a utxo\_key that you will feed into the transfer function in order to make the transaction. To execute transfer of assets run the following command: **For this command to successfully work, you will need to run in from the terminal of the organization that has those assets.** In this case,the terminal is the terminal for org0. 
```
peer chaincode invoke "${TARGET_TLS_OPTIONS[@]}" -C copper -n rmi -c '{"function":"Transfer","Args":["[\"<your_UTXO_KEY_here>\"]","[{\"utxo_key\":\"\",\"owner\":\"<ID_of_receiver_1>\",\"amount\":<amt_1>},{\"utxo_key\":\"\",\"owner\":\"<ID_of_receiver_2>\",\"amount\":<amt_2>}]"]}'
```
You can get the ID of the receiver by running the following command on the terminal of the desired receiver:
```
peer chaincode query -C test14 -n mycc2 -c '{"function": "ClientID", "Args":[]}'
```

## Contributing To The Project

