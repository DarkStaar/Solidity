// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract AccessControl
{
    event GrantRole(bytes32 indexed role, address indexed account);
    event RevokeRole(bytes32 indexed role, address indexed account);
    //role => account => bool
    //Check role for said account and if it exists then true

    mapping(bytes32 => mapping(address => bool)) public roles;

    //For testing make this public so you can get the hash value of constants(used in other functions)
    //0xdf8b4c520ffe197c5343c6f5aec59570151ef9a492f2c624fd45ddde6135ec42
    bytes32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
    //0x2db9fd3d099848027c2383d0a083396f6c41510d7acfd92adc99b6cffcf31e96
    bytes32 public constant USER = keccak256(abi.encodePacked("USER"));

    modifier onlyRole(bytes32 _role)
    {
        require(roles[_role][msg.sender], "Not authorized.");
        _;
    }

    constructor() 
    {
        _grantRole(ADMIN, msg.sender);
    }

    function _grantRole(bytes32 _role, address _account) internal 
    {
        roles[_role][_account] = true; //Give _role to _account
        emit GrantRole(_role, _account);
    }

    function grantRole(bytes32 _role, address _account) external onlyRole(ADMIN)
    {
        _grantRole(_role, _account);
    }

    function revokeRole(bytes32 _role, address _account) external onlyRole(ADMIN)
    {
        roles[_role][_account] = false; //Take _role from _account
        emit RevokeRole(_role, _account);
    }
}