// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EclipseAttackTimestampDetection {
    uint256 public constant thresholdTime = 3600; // 1 hour threshold in seconds
    uint256 public lastBlockTimestamp;
    uint256 public blockCount = 0;

    event SuspiciousActivityDetected(uint256 blockNumber, uint256 timeDifference, string message);

    constructor() {
        lastBlockTimestamp = block.timestamp; // Initialize with the deployment block timestamp
    }

    // Function to check current block timestamp
    function checkBlockTimestamp() public returns (bool) {
        uint256 timeDifference = block.timestamp - lastBlockTimestamp;

        // Update the last block timestamp and increment block count
        lastBlockTimestamp = block.timestamp;
        blockCount++;

        // Check if time difference exceeds the threshold
        if (timeDifference > thresholdTime) {
            emit SuspiciousActivityDetected(block.number, timeDifference, "Suspicious block interval detected!");
            return true;
        } else {
            return false;
        }
    }
}
