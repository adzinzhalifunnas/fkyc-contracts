// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/FKYCFactory.sol";
import "../src/FKYCStorage.sol";

contract FKYCStorageTest is Test {
    FKYCFactory public factory;
    FKYCStorage public storageContract;
    address public fi = address(0x1234);
    address public owner;

    function setUp() public {
        factory = new FKYCFactory();
        storageContract = new FKYCStorage(address(factory));

        owner = factory.owner();
        factory.assignRole(fi, FKYCFactory.Role.FinancialInstitution);
    }

    function testStoreKYC() public {
        vm.prank(fi);
        storageContract.storeKYC("fkycID1", "fkycHash1");

        FKYCStorage.FKYCRecord memory record = storageContract.getKYC("fkycID1");
        assertEq(record.fkycHash, "fkycHash1");
        assertEq(record.approvedBy, fi);
    }

    function testGetKYC() public {
        vm.prank(fi);
        storageContract.storeKYC("fkycID2", "fkycHash2");

        FKYCStorage.FKYCRecord memory record = storageContract.getKYC("fkycID2");
        assertEq(record.fkycHash, "fkycHash2");
        assertEq(record.approvedBy, fi);
    }

    function testUnauthorizedStoreKYC() public {
        vm.prank(owner);
        vm.expectRevert("Unauthorized: Only approved roles can store KYC");
        storageContract.storeKYC("fkycID3", "fkycHash3");
    }

    function testKYCAlreadyExists() public {
        vm.prank(fi);
        storageContract.storeKYC("fkycID4", "fkycHash4");

        vm.prank(fi);
        vm.expectRevert("KYC ID already exists");
        storageContract.storeKYC("fkycID4", "fkycHash4");
    }

    function testGetNonExistentKYC() public {
        vm.expectRevert("KYC record not found");
        storageContract.getKYC("nonExistentID");
    }
}