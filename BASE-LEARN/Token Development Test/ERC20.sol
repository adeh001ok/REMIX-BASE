// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// ✅ Import langsung dari GitHub OpenZeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/structs/EnumerableSet.sol";

/// @title WeightedVoting (ERC-20 Exercise)
/// @notice Implementasi sesuai kriteria di https://docs.base.org/learn/token-development/erc-20-token/erc-20-exercise
contract WeightedVoting is ERC20 {
    using EnumerableSet for EnumerableSet.AddressSet;

    /* ======= KONSTANTA ======= */
    uint256 public constant MAX_SUPPLY = 1_000_000;
    uint256 public constant CLAIM_AMOUNT = 100; // Tiap wallet klaim 100 token

    /* ======= ERROR ======= */
    error TokensClaimed();
    error AllTokensClaimed();
    error NoTokensHeld();
    error QuorumTooHigh(uint256 quorum);
    error AlreadyVoted();
    error VotingClosed();

    /* ======= ENUM UNTUK VOTE ======= */
    enum Vote { AGAINST, FOR, ABSTAIN }

    /* ======= STRUKTUR ISSUE =======
       Urutan field HARUS sama dengan instruksi exercise:
       1. EnumerableSet.AddressSet voters
       2. string issueDesc
       3. uint256 votesFor
       4. uint256 votesAgainst
       5. uint256 votesAbstain
       6. uint256 totalVotes
       7. uint256 quorum
       8. bool passed
       9. bool closed
    ================================== */
    struct Issue {
        EnumerableSet.AddressSet voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    Issue[] internal issues; // Changed from `public` to `internal`
    mapping(address => bool) public hasClaimed;

    /* ======= EVENTS ======= */
    event Claimed(address indexed who, uint256 amount);
    event IssueCreated(uint256 indexed issueId, string desc, uint256 quorum);
    event Voted(uint256 indexed issueId, address indexed who, Vote vote, uint256 weight);

    /* ======= KONSTRUKTOR ======= */
    constructor() ERC20("WeightedVoting Token", "WVOTE") {
        // Index 0 "dibakar" agar issue nyata dimulai dari index 1
        issues.push();
        issues[0].closed = true;
    }

    /* ======= CLAIM ======= */
    function claim() public {
        if (totalSupply() >= MAX_SUPPLY) revert AllTokensClaimed();
        if (hasClaimed[msg.sender]) revert TokensClaimed();
        if (totalSupply() + CLAIM_AMOUNT > MAX_SUPPLY) revert AllTokensClaimed();

        _mint(msg.sender, CLAIM_AMOUNT);
        hasClaimed[msg.sender] = true;
        emit Claimed(msg.sender, CLAIM_AMOUNT);
    }

    /* ======= CREATE ISSUE ======= */
    function createIssue(string calldata _desc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) revert NoTokensHeld();
        if (_quorum > totalSupply()) revert QuorumTooHigh(_quorum);

        issues.push();
        uint256 idx = issues.length - 1;

        Issue storage it = issues[idx];
        it.issueDesc = _desc;
        it.quorum = _quorum;
        it.closed = false;
        it.passed = false;

        emit IssueCreated(idx, _desc, _quorum);
        return idx;
    }

    /* ======= GET ISSUE VIEW ======= */
    struct IssueView {
        address[] voters;
        string issueDesc;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 votesAbstain;
        uint256 totalVotes;
        uint256 quorum;
        bool passed;
        bool closed;
    }

    function getIssue(uint256 _id) external view returns (IssueView memory) {
        require(_id < issues.length, "Invalid issue id");
        Issue storage it = issues[_id];

        uint256 voterCount = it.voters.length();
        address[] memory voterArray = new address[](voterCount);
        for (uint256 i = 0; i < voterCount; i++) {
            voterArray[i] = it.voters.at(i);
        }

        return IssueView({
            voters: voterArray,
            issueDesc: it.issueDesc,
            votesFor: it.votesFor,
            votesAgainst: it.votesAgainst,
            votesAbstain: it.votesAbstain,
            totalVotes: it.totalVotes,
            quorum: it.quorum,
            passed: it.passed,
            closed: it.closed
        });
    }

    /* ======= VOTING ======= */
    function vote(uint256 _issueId, Vote _vote) public {
        require(_issueId < issues.length, "Invalid issue id");
        Issue storage it = issues[_issueId];

        if (it.closed) revert VotingClosed();
        if (it.voters.contains(msg.sender)) revert AlreadyVoted();

        uint256 weight = balanceOf(msg.sender);
        if (weight == 0) revert NoTokensHeld();

        if (_vote == Vote.FOR) {
            it.votesFor += weight;
        } else if (_vote == Vote.AGAINST) {
            it.votesAgainst += weight;
        } else {
            it.votesAbstain += weight;
        }

        it.totalVotes += weight;
        it.voters.add(msg.sender);

        emit Voted(_issueId, msg.sender, _vote, weight);

        if (it.totalVotes >= it.quorum) {
            it.closed = true;
            it.passed = (it.votesFor > it.votesAgainst);
        }
    }

    /* ======= JUMLAH ISSUE ======= */
    function issueCount() external view returns (uint256) {
        return issues.length;
    }
}