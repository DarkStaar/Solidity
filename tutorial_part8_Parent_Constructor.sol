// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// 2 ways to call parent constructors
// Order of initialization
contract S 
{
    string public name;

    constructor(string memory _name)
    {
        name = _name;
    }
}

contract T 
{
    string public text;

    constructor(string memory _text)
    {
        text = _text;
    }
}

contract U is S("s"), T("t")    //First way to init constructors, used when we know what to input
{
    
}

contract V is S, T // Second way to init constructors
{
    constructor(string memory _name, string memory _text) S(_name) T(_text)
    {

    }
    // Order of execution is:
    // 1 - S
    // 2 - T
    // 3 - V
    // No matter how we type constructor it will always execute by order of inheritance
}

contract VV is S("s"), T // Can be used aswell 
{
    constructor(string memory _text) T(_text)
    {

    }
}