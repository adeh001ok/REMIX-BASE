// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ArraysAndTimestampExercise {
    uint256[] public numbers;
    address[] public senders;
    uint256[] public timestamps;

    constructor() {
        resetNumbers();
    }

    function resetNumbers() public {
        delete numbers;
        for (uint i = 1; i <= 10; i++) {
            numbers.push(i);
        }
    }

    function appendToNumbers(uint[] calldata _toAppend) external {
        for (uint i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function getNumbers() external view returns (uint[] memory) {
        return numbers;
    }

    /// @notice Menyimpan alamat pemanggil & timestamp custom
    function saveTimestamp(uint256 _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    /// @notice Mengambil semua data setelah Y2K
    /// @return recentTimestamps daftar timestamp setelah 946702800
    /// @return recentSenders alamat pengirim yang sesuai
    function afterY2K()
        public
        view
        returns (uint256[] memory recentTimestamps, address[] memory recentSenders)
    {
        uint256 count = 0;
        uint256 length = timestamps.length;

        // Hitung jumlah data yang valid
        for (uint256 i = 0; i < length; i++) {
            if (timestamps[i] > 946702800) {
                count++;
            }
        }

        // Buat array baru
        recentTimestamps = new uint256[](count);
        recentSenders = new address[](count);

        // Isi array dengan data valid
        uint256 index = 0;
        for (uint256 i = 0; i < length; i++) {
            if (timestamps[i] > 946702800) {
                recentTimestamps[index] = timestamps[i];
                recentSenders[index] = senders[i];
                index++;
            }
        }
    }

    /// @notice Reset array senders
    function resetSenders() public {
        delete senders;
    }

    /// @notice Reset array timestamps
    function resetTimestamps() public {
        delete timestamps;
    }
}
