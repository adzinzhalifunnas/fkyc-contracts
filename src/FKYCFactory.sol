// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract FKYCFactory is Ownable {
    enum Role { None, FinancialInstitution, Government }

    mapping(address => Role) public roles;

    event RoleAssigned(address indexed account, Role role);
    event RoleRevoked(address indexed account);

    constructor() Ownable(msg.sender) {}

    function assignRole(address account, Role role) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(role != Role.None, "Invalid role");
        roles[account] = role;
        emit RoleAssigned(account, role);
    }

    function revokeRole(address account) external onlyOwner {
        require(account != address(0), "Invalid address");
        require(roles[account] != Role.None, "Role not assigned");
        roles[account] = Role.None;
        emit RoleRevoked(account);
    }

    function hasRole(address account, Role role) public view returns (bool) {
        return roles[account] == role;
    }
}