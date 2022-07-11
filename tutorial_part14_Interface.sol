// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Interface - used to call contract without its code
//This is some contract that we dont know what code it has, but we know what functions he has
contract Counter 
{
    uint public count;

    function inc() external 
    {
        count += 1;
    }

    function dec() external 
    {
        count -= 1;
    }
}

//Use interface to make something like header file in C++
interface ICounter 
{
    function count() external view returns (uint);

    function inc() external;

    function dec() external;
}

contract CallInterface 
{
    function examples(address _counter) external 
    {
        ICounter(_counter).inc();
        ICounter(_counter).count();
    }
}