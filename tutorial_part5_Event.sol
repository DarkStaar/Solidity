// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//Event - logs that something happened. Cheaper version of variable
contract Event 
{
    event Log(string message, uint val);
    event IndexedLog(address indexed sender, uint val); //Up to 3 params can be indexed

    function example() external //This is transactional function (not read-only) because we store Log data on blockchain
    {
        emit Log("foo", 123);   //Emit log event on blockchain
        emit IndexedLog(msg.sender, 567);
    }

    event Message(address indexed _from, address indexed _to, string message);

    function sendMessage(address _to, string calldata message) external 
    {
        emit Message(msg.sender, _to, message);
    }
}