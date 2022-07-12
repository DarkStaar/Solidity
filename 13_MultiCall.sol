// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Usage: Query multiple function calls in 1 call and execute them in the same time
contract TestMultiCall
{
    function func1() external view returns(uint, uint)
    {
        return (1, block.timestamp);
    }

    function func2() external view returns(uint, uint)
    {
        return (2, block.timestamp);
    }

    function getData1() external pure returns(bytes memory)
    {
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns(bytes memory)
    {
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall 
{
    function multiCall(address[] calldata targets, bytes[] calldata data)
    external
    view
    returns(bytes[] memory)
    {
        require(targets.length == data.length, "Target != data lengths");
        bytes[] memory results = new bytes[](data.length);

        for(uint i; i < targets.length; i++)
        {
            (bool success, bytes memory result) = targets[i].staticcall(data[i]);   //if we want to just query then we use staticcall and keep view if we want to send something then we do call and remove view
            require(success, "call failed");

            results[i] = result;
        }

        return results;
    } 
}