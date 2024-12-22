// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/FKYCFactory.sol";

contract FKYCFactoryTest is Test {
    FKYCFactory public factory;
    address public nonOwner = address(0x1234);

    function setUp() public {
        factory = new FKYCFactory();
    }

    function testAssignRole() public {
        factory.assignRole(nonOwner, FKYCFactory.Role.FinancialInstitution);

        FKYCFactory.Role role = factory.roles(nonOwner);
        assertEq(uint256(role), uint256(FKYCFactory.Role.FinancialInstitution));
    }

    function testRevokeRole() public {
        factory.assignRole(nonOwner, FKYCFactory.Role.FinancialInstitution);
        factory.revokeRole(nonOwner);

        FKYCFactory.Role role = factory.roles(nonOwner);
        assertEq(uint256(role), uint256(FKYCFactory.Role.None));
    }
}