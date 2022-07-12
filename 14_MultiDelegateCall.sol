// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Why use multi delegate call? Why not multicall?
// user -> multi call ----- call -> test (msg.sender = multi call)
// user -> test ---- delegatecall ---> test (msg.sender = user)
contract MultiDelegateCall
{
    error DelegateCallFailed();
    function multiDelegateCall(bytes[] calldata data)
    external 
    payable
    returns(bytes[] memory results)
    {
        results = new bytes[](data.length);

        for(uint i; i < data.length; i++)
        {
            (bool ok, bytes memory res) = address(this).delegatecall(data[i]);
            if (!ok)
            {
                revert DelegateCallFailed();
            }

            results[i] = res;
        }
    }
}

contract TestMultiDelegateCall is MultiDelegateCall
{
    event Log(address caller, string func, uint i);

    function func1(uint x, uint y) external 
    {
        emit Log(msg.sender, "func1", x + y);
    }

    function func2() external returns(uint)
    {
        emit Log(msg.sender, "func2", 2);
        return 111;
    }

    mapping(address => uint) public balanceOf;

    //Unsafe code when used in combination with multi delegatecall
    //User can mint multiple times for the price of msg.value
    function mint() external payable 
    {
        balanceOf[msg.sender] += msg.value;
    }
}

//Helper to get byte data of functions
contract Helper 
{
    function getFunc1Data(uint x, uint y) external pure returns(bytes memory)
    {
        return abi.encodeWithSelector(TestMultiDelegateCall.func1.selector, x, y);
    }

    function getFunc2Data() external pure returns(bytes memory)
    {
        return abi.encodeWithSelector(TestMultiDelegateCall.func2.selector);
    }
}