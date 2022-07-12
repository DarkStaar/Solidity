// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FunctionSelector
{
    function getSelector(string calldata _func) external pure returns(bytes4)
    {
        return bytes4(keccak256(bytes(_func)));
        //bytes4: 0xa9059cbb
    }
}

contract Receiver 
{
    event Log(bytes data);

    function transfer(address _to, uint _amount) external 
    {
        emit Log(msg.data);
        //0xa9059cbb0000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4000000000000000000000000000000000000000000000000000000000000000b
        //First 4 bytes(8 hex) encodes function to call
        //Others are parameters
    }
}