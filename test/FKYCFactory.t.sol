// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/FKYCFactory.sol";

contract FKYCFactoryTest is Test {
    FKYCFactory public factory;

    function setUp() public {
        factory = new FKYCFactory();
    }

    function testAssignRole() public {
        factory.assignRole(address(0x1234), FKYCFactory.Role.FinancialInstitution);
        assertTrue(factory.hasRole(address(0x1234), FKYCFactory.Role.FinancialInstitution), "Role should be assigned");
    }

    function testRevokeRole() public {
        factory.assignRole(address(0x1234), FKYCFactory.Role.FinancialInstitution);
        factory.revokeRole(address(0x1234));
        assertFalse(factory.hasRole(address(0x1234), FKYCFactory.Role.FinancialInstitution), "Role should be revoked");
    }

    function testUnauthorizedAssignRole() public {
        vm.prank(address(0x1234)); // Simulate another address
        vm.expectRevert("Ownable: caller is not the owner");
        factory.assignRole(address(0x5678), FKYCFactory.Role.FinancialInstitution);
    }

    function testInvalidRoleAssignment() public {
        vm.expectRevert("Invalid role");
        factory.assignRole(address(0x1234), FKYCFactory.Role.None);
    }
}