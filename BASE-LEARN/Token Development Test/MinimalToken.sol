// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title UnburnableToken (Minimal Tokens Exercise)
/// @notice Implementasi minimal token sesuai exercise Base Learn
contract UnburnableToken {
    /* ========== STORAGE ========== */

    // mapping alamat => jumlah token mereka
    mapping(address => uint256) public balances;

    // total pasokan token
    uint256 public totalSupply;

    // berapa token yang sudah diklaim/distribusi sejauh ini
    uint256 public totalClaimed;

    // track apakah alamat sudah klaim
    mapping(address => bool) public hasClaimed;

    /* ========== EVENTS ========== */

    event Claimed(address indexed who, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);

    /* ========== ERRORS ========== */

    /// error bila wallet mencoba klaim lagi
    error TokensClaimed();

    /// error bila semua token sudah diklaim / tidak cukup token tersisa
    error AllTokensClaimed();

    /// error safe transfer tidak aman (mengandung alamat tujuan)
    error UnsafeTransfer(address to);

    /* ========== CONSTANTS ========== */

    // jumlah token yang diberikan per klaim
    uint256 public constant CLAIM_AMOUNT = 1000;

    /* ========== CONSTRUCTOR ========== */

    constructor() {
        // set totalSupply ke 100,000,000 seperti persyaratan
        totalSupply = 100_000_000;
        totalClaimed = 0;
        // balances kosong saat deploy; distribusi dilakukan lewat claim
    }

    /* ========== FUNCTIONS ========== */

    /// @notice Fungsi klaim: setiap wallet yang belum pernah klaim dapat menerima 1000 token
    /// @dev Revert dengan TokensClaimed jika sudah klaim sebelumnya.
    ///      Revert dengan AllTokensClaimed jika sisa token < CLAIM_AMOUNT atau sudah habis.
    function claim() public {
        // Jika totalClaimed sudah mencapai totalSupply -> semua token sudah dibagikan
        if (totalClaimed >= totalSupply) revert AllTokensClaimed();

        // Cek apakah alamat sudah mengklaim sebelumnya
        if (hasClaimed[msg.sender]) revert TokensClaimed();

        // Pastikan masih ada cukup token untuk klaim ini
        // (jika tersisa kurang dari CLAIM_AMOUNT, klaim ditolak)
        if (totalClaimed + CLAIM_AMOUNT > totalSupply) revert AllTokensClaimed();

        // Mark alamat sebagai sudah klaim
        hasClaimed[msg.sender] = true;

        // Tambahkan balance dan increment totalClaimed
        balances[msg.sender] += CLAIM_AMOUNT;
        totalClaimed += CLAIM_AMOUNT;

        emit Claimed(msg.sender, CLAIM_AMOUNT);
    }

    /// @notice Transfer token dengan pengecekan "aman"
    /// @dev Memastikan _to bukan zero address dan _to memiliki saldo ETH > 0.
    ///      Jika tidak, revert UnsafeTransfer(_to).
    function safeTransfer(address _to, uint256 _amount) public {
        // cek alamat tujuan valid
        if (_to == address(0)) revert UnsafeTransfer(_to);

        // cek saldo ETH penerima > 0 (satu dari requirement di exercise)
        if (_to.balance == 0) revert UnsafeTransfer(_to);

        // cek pengirim punya cukup token
        uint256 senderBal = balances[msg.sender];
        require(senderBal >= _amount, "Insufficient token balance");

        // lakukan transfer
        balances[msg.sender] = senderBal - _amount;
        balances[_to] += _amount;

        emit Transferred(msg.sender, _to, _amount);
    }
}