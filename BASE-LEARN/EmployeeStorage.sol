// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EmployeeStorage {
    // PRIVATE variables
    uint16 private shares;     // bisa cukup uint16 karena batasnya kecil (≤ 5000)
    uint32 private salary;     // gaji maksimum 1,000,000 — fits in uint32
    // PUBLIC variables
    string public name;
    uint256 public idNumber;

    // Custom Error untuk overshoot shares
    error TooManyShares(uint256 wouldBeShares);

    constructor(
        uint16 _shares,
        string memory _name,
        uint32 _salary,
        uint256 _idNumber
    ) {
        // Inisialisasi state
        shares = _shares;
        name = _name;
        salary = _salary;
        idNumber = _idNumber;
    }

    // View Salary & Shares
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    function viewShares() public view returns (uint16) {
        return shares;
    }

    // Grant Shares
    function grantShares(uint16 _newShares) public {
        // Jika _newShares > 5000, langsung error
        if (_newShares > 5000) {
            revert("Too many shares");
        }
        uint256 newTotal = uint256(shares) + uint256(_newShares);
        if (newTotal > 5000) {
            revert TooManyShares(newTotal);
        }
        shares = uint16(newTotal);
    }

    // Fungsi test / packing — **jangan diubah**
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    function debugResetShares() public {
        shares = 1000;
    }
}
