// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Anyone can deposit but only owner can withdraw
//When owner withdraws we also destroy piggybank
contract PiggyBank
{
    address public owner = msg.sender;

    event Deposit(uint amount);
    event Withdraw(uint amount);

    receive() external payable
    {
        emit Deposit(msg.value);
    }

    function withdraw() external 
    {
        require(msg.sender == owner, "Not the owner.");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(owner));
    }
}