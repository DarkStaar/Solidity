// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Selfdestruct
// - delete contract
// - force send Ether to any address

contract Kill
{
    constructor() payable {}
    function kill() external 
    {
        selfdestruct(payable(msg.sender)); //Delete contract from blockchain and send all Ether it has to msg.sender
    }

    function testCall() external pure returns(uint)
    {
        return 123;
    }
}

contract helper
{
    function getBalance() external view returns(uint)
    {
        return address(this).balance;
    }

    function kill(Kill _kill) external //Provide address of contract that we want to kill
    {
        _kill.kill();
    }
}