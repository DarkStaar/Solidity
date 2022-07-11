// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Used for unique ID, create signature etc.
//Keccak256 returns bytes32 type of data

//Encode vs EncodePack
//Encode encodes data into bytes
//EncodePack encodes but also compresses (takes out 0s from hex hash)

//Downside of EncodePack is hash collision, if we encode 2 strings AAA BBB its 0x414141424242
//If we encode AA ABBB its also 0x414141424242

//Fix for this is to use encode or to just not connect 2 dynamic data types(strings etc.) when calling encodePacked (if we have more data types and more than 2 vars)
contract HashFunc
{
    function hash(string memory text, uint num, address addr) external pure returns(bytes32)
    {
        return keccak256(abi.encodePacked(text, num, addr));
    }
}