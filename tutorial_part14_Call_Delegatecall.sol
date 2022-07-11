// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//CALL
contract TestCall 
{
    string public message;
    uint public x;

    event Log(string message);

    fallback() external payable 
    {
        emit Log("Fallback was called.");
    }

    function foo(string memory _message, uint _x) external payable returns (bool, uint)
    {
        message = _message;

        x = _x;

        return (true, 999);
    }
}

contract Call 
{
    bytes public data;

    //.call() is low level function that has input like this "functionName(type,type)",param1,param2
    //With {value: 111, gas: 5000} you send 111 wei and 5000 of gas for that function 
    function callFoo(address _test) external payable
    {
        (bool success, bytes memory _data) = _test.call{value: 111}(abi.encodeWithSignature(
            "foo(string,uint256)", "call foo", 123
        ));

        require(success, "Call failed.");
        data = _data;
    }
    //Calls function that doesnt exist, it will emit Fallback, if it doesnt have fallback it will turn error
    function callDoesntExist(address _test) external 
    {
        (bool success, ) = _test.call(abi.encodeWithSignature("doesNotExist()"));

        require(success, "Call failed.");
    }
}

/* DELEGATECALL

A calls B, sends 100 wei
        B calls C, sends 50 wei
    
A ----> B ----> C
                msg.sender = B
                msg.value = 50
                execute code on Cs state vars
                use ETH in C


A calls B, sends 100 wei   
        B delegatecall C        

A ----> B -----------> C
                        msg.sender = A
                        msg.value = 100
                        execute code in C on Bs state variables
                        use ETH from B
*/

// We need to have same global vars in both contracts and in the same order, if something is different it will give weird results
//thats because it will change storage layout.
contract TestDelegateCall
{
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) external payable 
    {
        num = 2 * _num; //We change something in code, 
        sender = msg.sender;
        value = msg.value;
    }
}

contract DelegateCall 
{
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _test, uint _num) external payable 
    {   /*
       _test.delegatecall(
           abi.encodeWithSignature("setVars(uint256)", _num)
        ); 
        */
        //Does the same, both can be used
        (bool success, ) = _test.delegatecall(
            abi.encodeWithSelector(TestDelegateCall.setVars.selector, _num)
        );

        require(success, "Delegate call failed.");
    }
}