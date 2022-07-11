// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
 Fallback is executed when:
 -function doesnt exist
 -directly send ETH


    Fallback vs Receive

    Ether is sent to contract
                |
        Is msg.data empty?
            /       \
          yes       no
          /          \
  receive exists?     fallback
     /        \
    yes       no
    /           \
  receive       fallback


*/

contract Fallback 
{
    event Log(string func, address sender, uint value, bytes data);
    fallback() external payable
    {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable 
    {
        emit Log("receive", msg.sender, msg.value, "");
    }

}

// SENDING ETH

//3 ways to send ETH
// 1 -> transfer -> 2300 gas, reverts if fails
// 2 -> send     -> 2300 gas, returns bool if successful or not
// 3 -> call     -> all gas, returns bool and data

//Popular contracts on MainNet use transfer or call.
contract SendETH 
{
    //Send ETH when its deployed
    constructor() payable 
    {

    }
    //Have a direct receive function
    receive() external payable 
    {

    }

    function sendViaTransfer(address payable _to) external payable
    {
        _to.transfer(123);
    }

    function sendViaSend(address payable _to) external payable
    {
       bool sent = _to.send(123);
       require(sent, "Send failed.");
    }
    //For now this is most recommended way to send ETH (it sends all gas it has) (failsafe?)
    function sendViaCall(address payable _to) external payable
    {
        (bool success,) = _to.call{value: 123}("");

        require(success, "Call failed.");
    }
}

contract ETHReceiver 
{
    event Log(uint amount, uint gas);

    receive() external payable 
    {
        emit Log(msg.value, gasleft());
    }
}