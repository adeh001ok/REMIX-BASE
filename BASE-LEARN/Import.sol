// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// Mengimpor library yang sudah dibuat pada file SillyStringUtils.sol
import "./SillyStringUtils/StringUtils.sol";

/// @title Kontrak ImportsExercise
/// @notice Kontrak ini menggunakan library untuk menyimpan dan memodifikasi haiku
contract ImportsExercise {
    // Menyimpan 1 haiku dalam bentuk struct dari library SillyStringUtils
    SillyStringUtils.Haiku public haiku;

    /// @notice Menyimpan haiku baru dengan 3 baris string
    /// @param _l1 Baris pertama haiku
    /// @param _l2 Baris kedua haiku
    /// @param _l3 Baris ketiga haiku
    function saveHaiku(
        string memory _l1,
        string memory _l2,
        string memory _l3
    ) public {
        // Menginisialisasi struct Haiku dengan nilai parameter dan menyimpannya di storage
        haiku = SillyStringUtils.Haiku({
            line1: _l1,
            line2: _l2,
            line3: _l3
        });
    }

    /// @notice Mengambil seluruh haiku dalam bentuk struct Haiku (bukan hanya satu per satu field)
    /// @return Struct Haiku yang disimpan saat ini
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    /// @notice Menghasilkan salinan haiku dengan baris ketiga ditambahkan shruggie
    /// @dev Tidak mengubah haiku asli di storage — hanya mengembalikan versi modifikasi
    /// @return Struct Haiku yang dimodifikasi (baris ketiga berisi shruggie)
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        // Membuat salinan haiku ke memori
        SillyStringUtils.Haiku memory modified = haiku;

        // Menambahkan shruggie pada baris ketiga salinan menggunakan fungsi dari library
        modified.line3 = SillyStringUtils.shruggie(modified.line3);

        // Mengembalikan hasil modifikasi tanpa menyimpan perubahan ke storage
        return modified;
    }
}