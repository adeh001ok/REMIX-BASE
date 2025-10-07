// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/// @notice Kontrak AddressBook
contract AddressBook is Ownable {
    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }

    mapping(uint256 => Contact) public contacts;

    /// @notice Constructor menerima initial owner
    constructor(address initialOwner) Ownable(initialOwner) {}

    /// @notice Menambahkan kontak baru (hanya owner)
    function addContact(
        uint256 _id,
        string memory _firstName,
        string memory _lastName,
        uint256[] memory _phoneNumbers
    ) public onlyOwner {
        contacts[_id] = Contact(_id, _firstName, _lastName, _phoneNumbers);
    }

    /// @notice Menghapus kontak berdasarkan ID (hanya owner)
    function deleteContact(uint256 _id) public onlyOwner {
        if (contacts[_id].id == 0) revert("ContactNotFound");
        delete contacts[_id];
    }

    /// @notice Mengambil informasi kontak berdasarkan ID
    function getContact(uint256 _id) public view returns (Contact memory) {
        Contact memory contact = contacts[_id];
        if (contact.id == 0) revert("ContactNotFound");
        return contact;
    }
}

/// @notice Kontrak AddressBookFactory
contract AddressBookFactory {
    /// @notice Membuat instance baru dari AddressBook
    function deploy() public returns (address) {
        // Kirim msg.sender sebagai owner
        AddressBook newAddressBook = new AddressBook(msg.sender);
        return address(newAddressBook);
    }
}