// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract CallTestContract
{
    function setX(address _test, uint _x) external 
    {
        //Call test contract deployed at address _test and call function setX from him.
        TestContract(_test).setX(_x);
    }

    //We can also call it like this
    function getX(TestContract _test) external view returns(uint)
    {
       return _test.getX();
    }

    function setXandSendEther(address _test, uint _x) external payable 
    {
        //By adding {value: msg.value} we add how much ether will we send
        TestContract(_test).setXandReceiveEther{value: msg.value}(_x);
    }

    function getXandValue(TestContract _test) external view returns(uint, uint)
    {
       (uint x, uint value) = _test.getXandValue();

       return (x, value);
    }
}

contract TestContract 
{
    uint public x;
    uint public value = 123;

    function setX(uint _x) external 
    {
        x = _x;
    }

    function getX() external view returns(uint)
    {
        return x;
    }

    function setXandReceiveEther(uint _x) external payable 
    {
        x = _x;
        value = msg.value;
    }

    function getXandValue() external view returns(uint, uint)
    {
        return (x, value);
    }
}