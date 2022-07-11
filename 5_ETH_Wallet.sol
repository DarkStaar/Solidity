// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract EtherWallet
{
    address payable public owner;

    constructor() 
    {
        owner = payable(msg.sender);
    }

    receive() external payable 
    {

    }

    function withdraw(uint _amount) external 
    {
        require(msg.sender == owner, "You are not an owner.");

        payable(msg.sender).transfer(_amount); //saves a bit of gas instead of writing owner.transfer
    }

    function getBalance() external view returns(uint)
    {
        return address(this).balance;
    }
}