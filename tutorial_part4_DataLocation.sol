// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Data locations - storage, memory and calldata

// Storage - variable is state variable
// Memory  - data is loaded on memory
// Calldata - like memory except it can only be used in function inputs
// Calldata != Memory, calldata doesnt copy variable so it saves on gas 
contract DataLocations
{
    struct MyStruct 
    {
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public MyStructs;

    function examples() external 
    {
        MyStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});

        MyStruct storage myStruct = MyStructs[msg.sender];
        myStruct.text = "foo";  //We can modify it.
        
        MyStruct memory readOnly = MyStructs[msg.sender];
        readOnly.foo = 456; //WE can modify it but once function is finished this change wont be saved.


    }
}