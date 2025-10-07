// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GarageManager {
    // Struct Car
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    // Custom error untuk index salah
    error BadCarIndex(uint256 idx);

    // Mapping dari address ke daftar mobil
    mapping(address => Car[]) public garage;

    /// @notice Tambah mobil ke garasi pemanggil
    function addCar(
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint256 _numberOfDoors
    ) public {
        Car memory newCar = Car({
            make: _make,
            model: _model,
            color: _color,
            numberOfDoors: _numberOfDoors
        });
        garage[msg.sender].push(newCar);
    }

    /// @notice Ambil semua mobil pemanggil
    function getMyCars() public view returns (Car[] memory) {
        return garage[msg.sender];
    }

    /// @notice Ambil semua mobil user tertentu
    function getUserCars(address user) public view returns (Car[] memory) {
        return garage[user];
    }

    /// @notice Update mobil di index tertentu
    function updateCar(
        uint256 idx,
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint256 _numberOfDoors
    ) public {
        Car[] storage userCars = garage[msg.sender];
        if (idx >= userCars.length) revert BadCarIndex(idx);

        userCars[idx].make = _make;
        userCars[idx].model = _model;
        userCars[idx].color = _color;
        userCars[idx].numberOfDoors = _numberOfDoors;
    }

    /// @notice Kosongkan garasi pemanggil
    function resetMyGarage() public {
        delete garage[msg.sender];
    }
}
