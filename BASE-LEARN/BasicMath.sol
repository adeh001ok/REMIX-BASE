// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BasicMath {
    // Fungsi penjumlahan
    function adder(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b; // Akan revert otomatis jika overflow
    }

    // Fungsi pengurangan
    function subtractor(uint256 a, uint256 b) public pure returns (uint256) {
        return a - b; // Akan revert otomatis jika underflow (misal 1 - 2)
    }
}
