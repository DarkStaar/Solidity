// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//NEW
// 2 Ways to create contract from another contract:
// 1) Create (Explained now)
// 2) Create2 (Explained later)
contract Account 
{
    address public bank;
    address public owner;

    constructor(address _owner) payable 
    {
        bank = msg.sender;
        owner = _owner;
    }
}

contract AccountFactory //When we use some contract to create existing one we call it ContractsNameFactory
{
    Account[] public accounts; //Create array of accounts to be stored

    function createAccount(address _owner) external payable
    {
        Account account = new Account{value: 111}(_owner);  //Create Account with msg.sender as owner on address thats stored in accounts array
        accounts.push(account);
    }
}


//LIBRARY
// Separate and reuse code

//Restrictions for library
// You cant make global variables inside library
library Math 
{
    function max(uint x, uint y) internal pure returns(uint)//When deployed as public we need to deploy it, internal embeds it inside contract that calls it
    {
        return x >= y ? x : y;
    }
}

contract TestLibrary 
{
    function testMax(uint x, uint y) external pure returns(uint)
    {
        return Math.max(x, y);
    }
}

library ArrayLib 
{
    function find(uint[] storage arr, uint x) internal view returns(uint)
    {
        for(uint i = 0; i < arr.length; i++)
        {
            if(arr[i] == x)
            {
                return i;
            }
        }
        revert("Not found.");
    }
}

contract ArrayLibrary 
{
    using ArrayLib for uint[]; //We say that we are using Library for this data type
    uint[] public arr = [3, 2, 1];

    function testFind() external view returns(uint i)
    {
        //return ArrayLib.find(arr, 2);
        //When we input using Lib for.. we can work like this
        return arr.find(2);
    }
}