// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//Inheritance - used to not duplicate code
contract A 
{
    function foo() public pure virtual returns(string memory)
    {
        return "A";
    } //keyword virtual means that contract that inherits this contract can use this function and modify it.

    function bar() public pure virtual returns (string memory)
    {
        return "A";
    }

    //more code
    function baz() public pure returns (string memory)
    {
        return "A";     //This function will be available for B
    }
}

contract B is A //B is A means B inherits A
{
    function foo() public pure override returns (string memory)
    {
        return "B";
    }

    function bar() public pure virtual override returns (string memory) //Can be overridden by child contract but still overrides parent contract function
    {
        return "B";
    }
}

contract C is B 
{
    function bar() public pure override returns(string memory)
    {
        return "C";
    }
}