// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/FKYCToken.sol";
import "../src/FKYCFactory.sol";
import "../src/FKYCStorage.sol";

contract DeployFKYC is Script {
    function run() external {
        vm.startBroadcast();

        FKYCToken fkycToken = new FKYCToken(21000000 * 1e18);
        FKYCFactory factory = new FKYCFactory();
        FKYCStorage storageContract = new FKYCStorage(address(factory), address(fkycToken));

        console.log("FKYCToken deployed at:", address(fkycToken));
        console.log("FKYCFactory deployed at:", address(factory));
        console.log("FKYCStorage deployed at:", address(storageContract));

        vm.stopBroadcast();
    }
}