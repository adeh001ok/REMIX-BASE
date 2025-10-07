// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ControlStructuresExercise {
    error AfterHours(uint256 time); // Custom error seperti instruksi
    error AtLunch();
    
    /// @notice Mengategorikan angka: negatif, nol, atau positif
    function categorize(int256 number) public pure returns (string memory) {
        if (number < 0) {
            return "Negative";
        } else if (number == 0) {
            return "Zero";
        } else {
            return "Positive";
        }
    }

    /// @notice FizzBuzz versi Base Docs:
    /// - kelipatan 3 & 5 -> "FizzBuzz"
    /// - kelipatan 3 -> "Fizz"
    /// - kelipatan 5 -> "Buzz"
    /// - selain itu -> "Splat"
    function fizzBuzz(uint256 number) public pure returns (string memory) {
        if (number % 3 == 0 && number % 5 == 0) {
            return "FizzBuzz";
        } else if (number % 3 == 0) {
            return "Fizz";
        } else if (number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    function doNotDisturb(uint256 _time) public pure returns (string memory) {
        // 1️⃣ Jika _time >= 2400 → trigger panic (assert)
        assert(_time < 2400);

        // 2️⃣ Jika _time > 2200 atau _time < 800 → revert custom error AfterHours
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        }

        // 3️⃣ Jika antara 1200 dan 1259 → revert dengan string “At lunch!”
        if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        }

        // 4️⃣ Jika antara 800 dan 1199 → “Morning!”
        if (_time >= 800 && _time <= 1199) {
            return "Morning!";
        }

        // 5️⃣ Jika antara 1300 dan 1799 → “Afternoon!”
        if (_time >= 1300 && _time <= 1799) {
            return "Afternoon!";
        }

        // 6️⃣ Jika antara 1800 dan 2200 → “Evening!”
        if (_time >= 1800 && _time <= 2200) {
            return "Evening!";
        }

        // Default fallback (harusnya tidak tercapai)
        revert("Invalid time");
    }
}