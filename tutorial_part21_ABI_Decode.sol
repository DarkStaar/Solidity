// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//How to decode bytes back in data
contract AbiDecode
{
    struct MyStruct 
    {
        string name;
        uint[2] nums;
    }
    //Reminder: calldata is used for external calls
    function encode(
        uint x,
        address addr,
        uint[] calldata arr,
        MyStruct calldata myStruct
    ) external pure returns(bytes memory)
    {
        return abi.encode(x, addr, arr, myStruct);
    }

    function decode(bytes calldata data) external pure returns(
        uint x,
        address addr,
        uint[] memory arr,
        MyStruct memory myStruct
    )
    {
        //Decode data into these data types
        (x, addr, arr, myStruct) = abi.decode(data, (uint, address, uint[], MyStruct));
    }
}