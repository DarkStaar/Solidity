// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
Gas saving tips:
    start - 50908 gas
    use calldata - 49163 gas
    load state variables to memory - 48952 gas
    short circuit - 48634 gas
    loop increments - 48226 gas
    cache array length - 48191 gas
    load array elements to memory - 48029 gas
*/

contract GasGolf 
{
    uint public total;


    //This is not optimized code
    /*
    function sumIfEvenAndLessThan99(uint[] memory nums) external 
    {
        for (uint i = 0; i < nums.length; i+= 1)
        {
            bool isEven = nums[i] % 2 == 0;
            bool isLessThan99 = nums[i] < 99;
            if(isEven && isLessThan99)
            {
                total += nums[i];
            }
        }
    }
    */

    //This is optimized code
    function sumIfEvenAndLessThan99(uint[] calldata nums) external 
    {
        uint _total = total; //Dont access state var in loops, make its copy and then after loop is finished update it
        uint length = nums.length;
        for(uint i = 0; i < length; ++i)
        {
            uint num = nums[i];
            if(num % 2 == 0 && num < 99)
            {
                _total += num;
            }
        }
        total = _total;
    }
}