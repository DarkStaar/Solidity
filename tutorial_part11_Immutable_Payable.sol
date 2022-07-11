// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Immutable 
{
    address public immutable owner; //Cannot be changed, like any other immutable... Uses less gas.

    constructor() //can be used, or we can just assign up there.
    {
        owner = msg.sender;
    }

    uint public x;
    function foo() external 
    {
        require(msg.sender == owner);
        x += 1;
    }

    //more code here
}

contract Payable
{
    address payable public owner; //Address will be able to send Ether.

    constructor() 
    {
        owner = payable(msg.sender); //Cast it to payable address.
    }

    function deposit() external payable //It can receive ETH
    {

    }

    function getBalance() external view returns(uint)
    {
        return address(this).balance;
    }
}