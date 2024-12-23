// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./FKYCFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract FKYCStorage {
    struct FKYCRecord {
        string fkycHash;
        address approvedBy;
    }

    FKYCFactory public fkycFactory;
    IERC20 public fkycToken;
    mapping(string => FKYCRecord) public fkycRecords;

    uint256 public fee = 1e18;

    event KYCStored(string indexed fkycID, string fkycHash, address indexed approvedBy);

    constructor(address _fkycFactory, address _fkycToken) {
        fkycFactory = FKYCFactory(_fkycFactory);
        fkycToken = IERC20(_fkycToken);
    }

    function storeKYC(
        string memory fkycID,
        string memory fkycHash
    ) external {
        require(
            fkycFactory.hasRole(msg.sender, FKYCFactory.Role.FinancialInstitution) ||
            fkycFactory.hasRole(msg.sender, FKYCFactory.Role.Government),
            "Unauthorized: Only approved roles can store KYC"
        );

        require(bytes(fkycRecords[fkycID].fkycHash).length == 0, "KYC ID already exists");

        require(fkycToken.balanceOf(msg.sender) >= fee, "Insufficient balance");
        require(fkycToken.allowance(msg.sender, address(this)) >= fee, "Insufficient allowance");
        require(fkycToken.transferFrom(msg.sender, address(this), fee), "FKYC token transfer failed");

        fkycRecords[fkycID] = FKYCRecord({
            fkycHash: fkycHash,
            approvedBy: msg.sender
        });

        emit KYCStored(fkycID, fkycHash, msg.sender);
    }

    function getKYC(string memory fkycID) external view returns (FKYCRecord memory) {
        require(bytes(fkycRecords[fkycID].fkycHash).length != 0, "KYC record not found");
        return fkycRecords[fkycID];
    }
}