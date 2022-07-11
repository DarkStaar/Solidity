// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
    Calling parent functions
    - Direct
    - Super

        E
      /    \
     F      G
      \    /
        H
*/

contract E 
{
    event Log(string message);

    function foo() public virtual 
    {
        emit Log("E.foo");
    }

    function bar() public virtual 
    {
        emit Log("E.bar");
    }
}

contract F is E 
{
    function foo() public virtual override 
    {
        emit Log("F.foo");
        E.foo(); //Call parent function directly
    }

    function bar() public virtual override
    {
        emit Log("F.bar");
        super.bar(); //Call parent function using super
    }
}

contract G is E 
{
    function foo() public virtual override 
    {
        emit Log("G.foo");
        E.foo(); 
    }

    function bar() public virtual override
    {
        emit Log("G.bar");
        super.bar(); 
    }
}

contract H is F, G 
{
    function foo() public override(F, G) 
    {
        F.foo(); //Only calls that function
    }

    function bar() public override(F, G)
    {
        super.bar(); //Calls all parents
    }
}