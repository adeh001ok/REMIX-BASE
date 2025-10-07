// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FavoriteRecords {
    // public mapping dari album name ke bool
    mapping(string => bool) public approvedRecords;

    // mapping nested: user address => (album name => bool)
    mapping(address => mapping(string => bool)) private userFavorites;

    // helper array untuk menyimpan semua nama album yang approved (agar bisa iterate)
    string[] private approvedList;

    // custom error jika nama tidak approved
    error NotApproved(string name);

    constructor() {
        // Daftar album yang disetujui
        string[9] memory initial = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        for (uint256 i = 0; i < initial.length; i++) {
            approvedRecords[initial[i]] = true;
            approvedList.push(initial[i]);
        }
    }

    /// @notice Ambil semua album yang approved
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedList;
    }

    /// @notice Tambahkan album ke favorit pengguna, jika sudah approved
    function addRecord(string memory name) public {
        if (!approvedRecords[name]) {
            revert NotApproved(name);
        }
        userFavorites[msg.sender][name] = true;
    }

    /// @notice Ambil daftar favorit suatu pengguna
    function getUserFavorites(address user) public view returns (string[] memory) {
        // Hitung jumlah favorit user
        uint256 count = 0;
        for (uint256 i = 0; i < approvedList.length; i++) {
            string memory nm = approvedList[i];
            if (userFavorites[user][nm]) {
                count++;
            }
        }
        // Buat array hasil
        string[] memory favs = new string[](count);
        uint256 idx = 0;
        for (uint256 i = 0; i < approvedList.length; i++) {
            string memory nm = approvedList[i];
            if (userFavorites[user][nm]) {
                favs[idx] = nm;
                idx++;
            }
        }
        return favs;
    }

    /// @notice Reset semua favorit pengguna (pesan ke mapping)
    function resetUserFavorites() public {
        for (uint256 i = 0; i < approvedList.length; i++) {
            string memory nm = approvedList[i];
            if (userFavorites[msg.sender][nm]) {
                userFavorites[msg.sender][nm] = false;
            }
        }
    }
}