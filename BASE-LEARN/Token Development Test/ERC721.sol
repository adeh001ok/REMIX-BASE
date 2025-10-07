// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    /// @notice Struktur untuk menyimpan satu Haiku
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    /// @notice Array publik untuk menyimpan semua Haiku
    Haiku[] public haikus;

    /// @notice Mapping alamat => daftar ID Haiku yang dibagikan ke alamat tersebut
    mapping(address => uint256[]) public sharedHaikus;

    /// @notice Mapping untuk memastikan keunikan setiap baris
    mapping(bytes32 => bool) private usedLines;

    /// @notice Counter publik untuk ID token berikutnya
    uint256 public counter = 1;

    /// @notice Custom errors
    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    constructor() ERC721("HaikuNFT", "HKNFT") {}

    /// @notice Mint NFT Haiku baru dan simpan isinya
    function mintHaiku(
        string calldata line1,
        string calldata line2,
        string calldata line3
    ) external {
        // Pastikan haiku unik
        if (_lineUsed(line1) || _lineUsed(line2) || _lineUsed(line3)) {
            revert HaikuNotUnique();
        }

        uint256 tokenId = counter;

        // Mint NFT
        _safeMint(msg.sender, tokenId);

        // Simpan haiku ke array
        haikus.push(
            Haiku({
                author: msg.sender,
                line1: line1,
                line2: line2,
                line3: line3
            })
        );

        // Tandai tiap baris sebagai sudah digunakan
        _markLineUsed(line1);
        _markLineUsed(line2);
        _markLineUsed(line3);

        // Naikkan counter untuk ID berikutnya
        counter++;
    }

    /// @notice Bagikan haiku ke alamat lain
    function shareHaiku(uint256 haikuId, address to) public {
        if (ownerOf(haikuId) != msg.sender) {
            revert NotYourHaiku(haikuId);
        }
        sharedHaikus[to].push(haikuId);
    }

    /// @notice Ambil semua haiku yang dibagikan ke wallet caller
    function getMySharedHaikus() public view returns (Haiku[] memory) {
        uint256[] memory ids = sharedHaikus[msg.sender];
        uint256 length = ids.length;

        if (length == 0) {
            revert NoHaikusShared();
        }

        Haiku[] memory result = new Haiku[](length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = haikus[ids[i] - 1]; 
            // -1 karena array mulai index 0, sedangkan ID mulai dari 1
        }
        return result;
    }

    /// @dev Cek apakah baris haiku sudah pernah dipakai
    function _lineUsed(string memory line) internal view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(line));
        return usedLines[hash];
    }

    /// @dev Tandai satu baris haiku sebagai sudah digunakan
    function _markLineUsed(string memory line) internal {
        bytes32 hash = keccak256(abi.encodePacked(line));
        usedLines[hash] = true;
    }
}