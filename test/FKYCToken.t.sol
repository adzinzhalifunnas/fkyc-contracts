// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../src/FKYCToken.sol";

contract FKYCTokenTest is Test {
    FKYCToken public token;

    function setUp() public {
        token = new FKYCToken(1000 ether);
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), 1000 ether, "Initial supply should be 1000 ether");
    }

    function testMint() public {
        token.mint(address(this), 500 ether);
        assertEq(token.balanceOf(address(this)), 1500 ether, "Balance after mint should be 1500 ether");
    }

    function testBurn() public {
        token.burn(address(this), 200 ether);
        assertEq(token.balanceOf(address(this)), 800 ether, "Balance after burn should be 800 ether");
    }

    function testUnauthorizedMint() public {
        vm.prank(address(0x1234)); // Simulate another address
        vm.expectRevert(abi.encodeWithSignature("Ownable: caller is not the owner"));
        token.mint(address(this), 100 ether);
    }

    function testUnauthorizedBurn() public {
        vm.prank(address(0x1234)); // Simulate another address
        vm.expectRevert(abi.encodeWithSignature("Ownable: caller is not the owner"));
        token.burn(address(this), 100 ether);
    }
}