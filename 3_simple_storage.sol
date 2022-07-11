// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract SimpleStorage
{
    string public text;
    //Can be also memory but calldata saves a bit of gas
    function set(string calldata _text) external
    {
        text = _text;
    }
    //Its state variable so we dont need getter but for example

    function get() external view returns (string memory)
    {
        return text;
    }
}