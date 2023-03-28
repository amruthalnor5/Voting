// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Voting {
    address public owner;
    mapping(address => bool) public voters;
    string[] public candidates;
    uint timeLimit;
    mapping(string => uint) public votesReceived;

    constructor(string[] memory _candidates) {
        owner = msg.sender;
        candidates = _candidates;
        timeLimit = block.timestamp + 600;
    }

    function acceptVote(string memory candidate) public {
        require(block.timestamp < timeLimit, "Voting is ended!");
        require(!voters[msg.sender], "Already voted.");
        require(candidateExists(candidate), "Candidate does not exist.");
        voters[msg.sender] = true;
        votesReceived[candidate]++;
    }

    function candidateExists(string memory candidate) internal view returns (bool) {
        for (uint i = 0; i < candidates.length; i++) {
            if (keccak256(abi.encodePacked(candidates[i])) == keccak256(abi.encodePacked(candidate)) ) {
                return true;
            }
        }
        return false;
    }

    function declareResult() public view returns (string memory) {
        require(block.timestamp >= timeLimit, "Voting not ended!");
        uint maxVotes = 0;
        string memory winner = "";
        for (uint i = 0; i < candidates.length; i++) {
            if (votesReceived[candidates[i]] > maxVotes) {
                winner = candidates[i];
                maxVotes = votesReceived[candidates[i]];
            }
        }
        return winner;
    }

    function getCandidates() public view returns (string[] memory) {
        return candidates;
    }
}
