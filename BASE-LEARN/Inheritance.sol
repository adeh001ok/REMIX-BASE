// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// ======================
// Abstract Employee
// ======================
abstract contract Employee {
    uint256 public idNumber;
    uint256 public managerId;

    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    function getAnnualCost() public view virtual returns (uint256);
}

// ======================
// Salaried
// ======================
contract Salaried is Employee {
    uint256 public annualSalary;

    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    function getAnnualCost() public view override returns (uint256) {
        return annualSalary;
    }
}

// ======================
// Hourly
// ======================
contract Hourly is Employee {
    uint256 public hourlyRate;

    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    function getAnnualCost() public view override returns (uint256) {
        return hourlyRate * 2080;
    }
}

// ======================
// Manager
// ======================
contract Manager {
    uint256[] public reportIds;

    function addReport(uint256 employeeId) public {
        reportIds.push(employeeId);
    }

    function resetReports() public {
        delete reportIds;
    }
}

// ======================
// Salesperson
// ======================
contract Salesperson is Hourly {
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Hourly(_idNumber, _managerId, _hourlyRate) {}
}

// ======================
// Engineering Manager
// ======================
contract EngineeringManager is Salaried, Manager {
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Salaried(_idNumber, _managerId, _annualSalary) {}
}

// ======================
// InheritanceSubmission
// ======================
contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}

// ======================
// 8️⃣ Factory Contract (Deploy semuanya sekaligus karena Saya tidak tahu bagaimana membuat contract abtract dapat dideploy)
// ======================
contract InheritanceFactory {
    Salesperson public salesperson;
    EngineeringManager public engineeringManager;
    InheritanceSubmission public submission;

    constructor() {
        // Deploy Salesperson
        salesperson = new Salesperson(
            55555,   // idNumber
            12345,   // managerId
            20       // hourlyRate
        );

        // Deploy EngineeringManager
        engineeringManager = new EngineeringManager(
            54321,    // idNumber
            11111,    // managerId
            200000    // annualSalary
        );

        // Deploy InheritanceSubmission dengan kedua alamat
        submission = new InheritanceSubmission(
            address(salesperson),
            address(engineeringManager)
        );
    }
}