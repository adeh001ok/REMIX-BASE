// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/// @title ErrorTriageExerciseFixed
/// @notice Kontrak ini memperbaiki potensi error pada exercise Error Triage
contract ErrorTriageExerciseFixed {

    /// @notice Menghitung selisih absolut antar elemen bertetangga
    /// @param _a Angka pertama
    /// @param _b Angka kedua
    /// @param _c Angka ketiga
    /// @param _d Angka keempat
    /// @return results Array berisi selisih absolut [_a-_b, _b-_c, _c-_d]
    function diffWithNeighbor(
        uint _a,
        uint _b,
        uint _c,
        uint _d
    ) public pure returns (uint[] memory) {
        // Buat array di memori untuk menyimpan hasil perhitungan
        uint[] memory results = new uint[](3);

        // Gunakan ternary operator agar tidak terjadi underflow (selisih absolut)
        results[0] = _a >= _b ? _a - _b : _b - _a; // Selisih pertama
        results[1] = _b >= _c ? _b - _c : _c - _b; // Selisih kedua
        results[2] = _c >= _d ? _c - _d : _d - _c; // Selisih ketiga

        return results; // Kembalikan array hasil
    }

    /// @notice Menyesuaikan nilai _base dengan modifier, menghindari underflow
    /// @param _base Nilai awal (uint)
    /// @param _modifier Modifier (int, bisa negatif)
    /// @return Hasil penyesuaian
    function applyModifier(uint _base, int _modifier) public pure returns (uint) {
        if (_modifier < 0) {
            // Jika modifier negatif, pastikan _base cukup besar agar tidak underflow
            require(_base >= uint(-_modifier), "Underflow risk");
            return _base - uint(-_modifier); // Kurangi _base
        } else {
            return _base + uint(_modifier); // Tambahkan jika modifier positif
        }
    }

    // --------------------------
    // Array untuk fungsi popWithReturn
    // --------------------------
    uint[] private arr; // Array private agar hanya bisa diakses melalui fungsi publik

    /// @notice Menghapus elemen terakhir dari array arr dan mengembalikan nilainya
    /// @return value Nilai elemen terakhir yang dihapus
    function popWithReturn() public returns (uint) {
        require(arr.length > 0, "Array empty"); // Pastikan array tidak kosong
        uint value = arr[arr.length - 1];       // Ambil elemen terakhir
        arr.pop();                               // Hapus elemen terakhir dari array
        return value;                            // Kembalikan nilai
    }

    // --------------------------
    // Utility functions
    // --------------------------

    /// @notice Menambahkan angka ke array arr
    /// @param _num Nilai yang ingin ditambahkan
    function addToArr(uint _num) public { 
        arr.push(_num); 
    }

    /// @notice Mengambil seluruh isi array arr
    /// @return Array berisi semua elemen arr
    function getArr() public view returns (uint[] memory) { 
        return arr; 
    }

    /// @notice Menghapus seluruh array arr
    function resetArr() public { 
        delete arr; 
    }
}
