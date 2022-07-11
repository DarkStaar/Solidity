// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Example Contract 1
contract TestContract1
{
    address public owner = msg.sender;

    function setOwner(address _owner) public 
    {
        require(msg.sender == owner, "not owner");

        owner = _owner;
    }
}

//Example Contract 2
contract TestContract2 
{
    address public owner = msg.sender;
    uint public value = msg.value;
    uint public x;
    uint public y;

    constructor(uint _x, uint _y) payable
    {
        x = _x;
        y = _y;
    }
}

contract Proxy 
{
    event Deploy(address);

    fallback() external payable {}

    function deploy(bytes memory _code) external payable returns (address addr) //Input is compiled contract and returns address of contract
    {
        assembly
        {
             //create (v, p, n)
            // v => amount of ETH to send
            // p => pointer in memory to start code
            // n => size of code
            //First 32 bytes of _code is saved for the length of bytecode
            addr := create(callvalue(), add(_code, 0x20), mload(_code)) //callvalue() is assembly for msg.value || add(_code, 0x20) is beginning of code, 0x20 is hex for 32
        }

        require(addr != address(0), "not deployed"); //Check if create returned valid address or failed

        emit Deploy(addr); //call Deploy event
    }

    function execute(address _target, bytes memory _data) external payable
    {
        (bool success, ) = _target.call{value: msg.value}(_data);
        require(success, "failed");
    }
}