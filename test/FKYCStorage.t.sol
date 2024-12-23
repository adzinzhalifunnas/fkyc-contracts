// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/FKYCStorage.sol";
import "../src/FKYCFactory.sol";
import "../src/FKYCToken.sol";

contract FKYCStorageTest is Test {
    FKYCStorage public storageContract;
    FKYCFactory public factory;
    FKYCToken public token;

    address public financialInstitution = address(0x1234);
    address public government = address(0x5678);

    function setUp() public {
        factory = new FKYCFactory();
        token = new FKYCToken(1000 ether);
        storageContract = new FKYCStorage(address(factory), address(token));

        // Assign roles
        factory.assignRole(financialInstitution, FKYCFactory.Role.FinancialInstitution);
        factory.assignRole(government, FKYCFactory.Role.Government);

        // Mint tokens for testing
        token.mint(financialInstitution, 10 ether);
        token.mint(government, 10 ether);
    }

    function testStoreKYCByFinancialInstitution() public {
        // Assign role
        factory.assignRole(financialInstitution, FKYCFactory.Role.FinancialInstitution);

        // Simulate financial institution storing KYC
        vm.prank(financialInstitution);
        token.approve(address(storageContract), 1 ether);
        storageContract.storeKYC("KYC123", "HASH123");

        // Verify the KYC record
        FKYCStorage.FKYCRecord memory record = storageContract.getKYC("KYC123");
        assertEq(record.fkycHash, "HASH123", "KYC hash mismatch");
        assertEq(record.approvedBy, financialInstitution, "Approver mismatch");
    }

    function testStoreKYCByGovernment() public {
        // Assign role
        factory.assignRole(government, FKYCFactory.Role.Government);

        // Simulate government storing KYC
        vm.prank(government);
        token.approve(address(storageContract), 1 ether);
        storageContract.storeKYC("KYC456", "HASH456");

        // Verify the KYC record
        FKYCStorage.FKYCRecord memory record = storageContract.getKYC("KYC456");
        assertEq(record.fkycHash, "HASH456", "KYC hash mismatch");
        assertEq(record.approvedBy, government, "Approver mismatch");
    }

    function testStoreKYCWithoutApproval() public {
        vm.prank(financialInstitution); // Simulate financial institution
        vm.expectRevert(
            abi.encodeWithSignature("ERC20InsufficientAllowance(address,address,uint256,uint256)")
        );
        storageContract.storeKYC("KYC789", "HASH789");
    }

    function testUnauthorizedStoreKYC() public {
        vm.prank(address(0x9999)); // Simulate unauthorized address
        vm.expectRevert("Unauthorized: Only approved roles can store KYC");
        storageContract.storeKYC("KYC999", "HASH999");
    }

    function testDuplicateKYCID() public {
    // Assign role
        factory.assignRole(financialInstitution, FKYCFactory.Role.FinancialInstitution);

        // Simulate financial institution storing KYC
        vm.prank(financialInstitution);
        token.approve(address(storageContract), 1 ether);
        storageContract.storeKYC("KYC123", "HASH123");

        // Attempt to store duplicate KYC ID
        vm.prank(financialInstitution);
        token.approve(address(storageContract), 1 ether);
        vm.expectRevert("KYC ID already exists");
        storageContract.storeKYC("KYC123", "HASH456");
    }
}