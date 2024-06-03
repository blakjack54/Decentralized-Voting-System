// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Proposal {
        string description;
        uint256 voteCount;
    }

    address public chairperson;
    mapping(address => bool) public voters;
    Proposal[] public proposals;

    event ProposalCreated(uint256 proposalId, string description);
    event Voted(address voter, uint256 proposalId);

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Not chairperson");
        _;
    }

    constructor() {
        chairperson = msg.sender;
    }

    function addVoter(address voter) external onlyChairperson {
        require(!voters[voter], "Already a voter");
        voters[voter] = true;
    }

    function createProposal(string memory description) external onlyChairperson {
        proposals.push(Proposal({description: description, voteCount: 0}));
        emit ProposalCreated(proposals.length - 1, description);
    }

    function vote(uint256 proposalId) external {
        require(voters[msg.sender], "Not a registered voter");
        require(proposalId < proposals.length, "Invalid proposal");

        proposals[proposalId].voteCount += 1;
        emit Voted(msg.sender, proposalId);
    }

    function getWinningProposal() external view returns (uint256 winningProposalId) {
        uint256 maxVoteCount = 0;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > maxVoteCount) {
                maxVoteCount = proposals[i].voteCount;
                winningProposalId = i;
            }
        }
    }

    function getProposal(uint256 proposalId) external view returns (string memory description, uint256 voteCount) {
        require(proposalId < proposals.length, "Invalid proposal");
        Proposal storage proposal = proposals[proposalId];
        return (proposal.description, proposal.voteCount);
    }
}
