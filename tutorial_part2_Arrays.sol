// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract tutorial
{
    //Arrays can be dynamic or fixed size
    //Fixed size cant use pop and push methods
    uint[] public numbers = [1,2,3];
    uint[3] public fixedNums = [4,5,6];

    function modifyArray() external{
        numbers.push(4); //Inserts 4 as the last element of numbers
        numbers[0]; //Accessing array element
        numbers[2] = 777; //Modifying element in array
        delete numbers[1]; //Clears element and sets it to default value of that type
        numbers.pop(); //Removes last element from array completely
        numbers.length; //Returns length of array

        //Create array in memory

        uint[] memory a = new uint[](5); //Must be fixed size
        a[1] = 123;
    }

    function returnArray() external view returns(uint[] memory)
    {
        return numbers; //Bigger array => more gas (Try not to return arrays)
    }

    //Remove element by shifting
    // Before: [1, 0, 3] After [1, 3]
    uint[] public arr;
    function shift(uint _index) public 
    {
        require(_index < arr.length, "Out of bounds.");

        for(uint i = _index; i < arr.length - 1; i++)
        {
            arr[i] = arr[i+1];
        }

        arr.pop();
    }

    function test() external{
        arr = [1, 2, 3, 4, 5];
        shift(2);

        assert(arr[0] == 1);
        assert(arr[1] == 2);
        assert(arr[2] == 4);
        assert(arr[3] == 5);
        assert(arr.length == 4);
    }

    //More gas efficient way

    function remove(uint _index) public
    {
        arr[_index] = arr[arr.length - 1];

        arr.pop();
    }

    function testRemove() external
    {
        arr = [1, 2, 3, 4];

        remove(1);

        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        remove(2);

        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }


    //MAPPING
    //Simple and Nested mapping
    // Operations: set, get, delete

    //Mapping is like dictionary in Python
    // {"alice" : true, "bob" : true, "charlie" : true} set of value : key

    mapping(address => uint) public balances;

    mapping(address => mapping(address => bool)) public isFriend; //nested mapping

    function mappingExample() external
    {
        balances[msg.sender] = 123;
        uint bal = balances[msg.sender]; //returns uint
        uint bal2 = balances[address(1)]; // as we didnt set address(1) in balances it will return default value (0 because its uint)

        balances[msg.sender] += 456;
        bal = 0;
        bal2 = 0;
        delete balances[msg.sender]; //Reset balance for sender address to default value

        isFriend[msg.sender][address(this)] = true;
    }

    mapping(address => bool) public inserted;

    address[] public keys;

    function set(address _key, uint _val) external 
    {
        balances[_key] = _val;

        if(!inserted[_key])
        {
            inserted[_key] = true;
            keys.push(_key);
        }
    }

    function getSize() external view returns(uint)
    {
        return keys.length;
    }

    function getFirst() external view returns(uint)
    {
        return balances[keys[0]];
    }

    function getLast() external view returns(uint)
    {
        return balances[keys[keys.length - 1]];
    }
}