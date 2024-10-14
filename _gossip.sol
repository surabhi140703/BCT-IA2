// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EclipseAttackGossipProtocol {
    struct BlockHeader {
        uint256 blockNumber;
        bytes32 blockHash;
    }

    mapping(address => BlockHeader[]) public serverHeaders; // Mapping of server address to block headers

    event BlockHeadersShared(address indexed client, address indexed server, uint256 blockNumber, bytes32 blockHash);
    event StrongestChainDetected(address indexed server, string message);

    // Share block headers with a server
    function shareBlockHeader(uint256 _blockNumber, bytes32 _blockHash, address _server) public {
        BlockHeader memory newHeader = BlockHeader({
            blockNumber: _blockNumber,
            blockHash: _blockHash
        });

        // Append the block header to the server's history
        serverHeaders[_server].push(newHeader);

        emit BlockHeadersShared(msg.sender, _server, _blockNumber, _blockHash);
    }

    // Check if the server's block header matches the strongest chain
    function checkStrongestChain(address _server, uint256 _blockNumber, bytes32 _blockHash) public returns (bool) {
        require(serverHeaders[_server].length > 0, "No headers available from this server");

        // Get the latest block header from the server
        BlockHeader memory latestHeader = serverHeaders[_server][serverHeaders[_server].length - 1];

        if (latestHeader.blockNumber == _blockNumber && latestHeader.blockHash == _blockHash) {
            emit StrongestChainDetected(_server, "Matching strongest chain");
            return true;
        } else {
            emit StrongestChainDetected(_server, "Mismatch detected, potential eclipse attack!");
            return false;
        }
    }
}
