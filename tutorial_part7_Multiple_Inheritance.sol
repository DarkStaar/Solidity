// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Order of Inheritance - most base-like to derived
// Most-Base like means the contract that inherits the least
/*
    X
  / |
Y   |
  \ |
    Z
*/

// Order of most base like to most derived:
// X, Y, Z

/*
    X
  /   \
 Y     A
 |     |
 |     B
 \    /
   Z
*/

// Order of most base like to most derived:
// X, Y, A, B, Z

//Syntax for multiple inheritance (using first example X Y Z)

contract X 
{
    function foo() public pure virtual returns(string memory)
    {
        return "X";
    }

    function bar() public pure virtual returns(string memory)
    {
        return "X";
    }

    function x() public pure returns(string memory)
    {
        return "X";
    }
}

contract Y is X 
{
    function foo() public pure virtual override returns(string memory)
    {
        return "Y";
    }

    function bar() public pure virtual override returns(string memory)
    {
        return "Y";
    }

    function y() public pure returns(string memory)
    {
        return "Y";
    }
}

contract Z is X, Y //declare from most based like to most derived
{
    function foo() public pure override(X, Y) returns(string memory) //Add both inheritances in override
    {
        return "Z";
    }

    function bar() public pure override(X,Y) returns(string memory)
    {
        return "Z";
    }
}