// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./FKYCFactory.sol";

contract FKYCStorage {
    struct FKYCRecord {
        string fkycHash;
        address approvedBy;
    }

    FKYCFactory public fkycFactory;
    mapping(string => FKYCRecord) public fkycRecords;

    event KYCStored(string indexed fkycID, string fkycHash, address indexed approvedBy);

    constructor(address _fkycFactory) {
        fkycFactory = FKYCFactory(_fkycFactory);
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