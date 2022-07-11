// SPDX-License-Identifier: MIT

// Declare the versions of the Solidity compiler
pragma solidity >= 0.7.0 < 0.9.0;

// Used to convert uint to string
import "@openzeppelin/contracts/utils/Strings.sol";

//Constants use less gas than regular variables.

//Bigger number of loops, more gas is used.


contract TestContract
{
    //Constant
    uint public constant MY_ADDRESS = 124124;
    // State variables
    bool public canVote = true; //public => can be accessed by everyone.
    int private myAge = 22; // private => can only be called within contract.
    uint internal favNum = 8; // internal => only accessed in contract or by contracts that inherit this contract. 
    string myName = "Milan";
    // Floats are not accurate so they dont exist in Solidity.

    // Default constructor

    constructor() {}

    uint toBig = 250; //Uses too much energy on blockchain so keep it on correct uint bit size.
    uint8 justRight = uint8(toBig); //Casting to 8bit uint because its enough for that number.

    // function funcName(parameters) scope returns() {statements} <= basic function layout.
    function getSum(uint _num1, uint _num2) public pure returns(uint)
    {
        uint _mySum = _num1 + _num2;
        
        return _mySum;
    }

    // pure => means that we are performing calculation and not touching state variables.
    // view => works with state variable(or data outside function) and allow us to view the result of function but wont modify state.
    // Pure used when we dont access variables outside of function.
    // View used when we access variables outside of function.

    // Functions can be:
    // internal => accessed only within the contract or by other contracts that inherit his contract.
    // external => accessed only with external contracts. Means we can call it on blockchain.

    function getResult() public pure returns(uint) 
    {
        uint a = 10;
        uint b = 5;
        uint result = a + b;

        return result;
    }

    uint specialVal = 10; //This is also state variable

    function changeSV(uint _value) external 
    {
        specialVal = _value;
    }

    function getSV() external view returns(uint)
    {
        return specialVal;
    }

    //Error handling
    //Require is used to validate input and control access to function. Whatever happened in function before this error will be undone.
    //Revert is mostly used in loops or ifs.
    //Assert is used to check for condition that should always be true, like check some global variable.
    //Custom error saves gas. The longer error message => more gas used.

    //error MyError(); create custom error.
    error MyError(address caller, uint i);
    function testCustomError(uint _i) public view 
    {
        if(_i > 10)
        {
            revert MyError(msg.sender, _i); //Logs senders address and input. Senders address is global so use view!!!! 
        }
    }


    function doMath(int _num1, int _num2) public pure returns(int, int, int, int, int, int)
    {
        require(_num2 != 0, "Second number cant be zero!"); //Ends function and prints error. Refunds any gas used.

        assert(_num2 > 0); //Doesnt have message associated with it. Ends function. If condition is false any changes done to state variables will be reverted.

        if(_num2 < 0)
        {
            revert("Second number cant be zero!"); //Shows message. Ends function.
        }

        int _add = _num1 + _num2;
        int _sub = _num1 - _num2;
        int _mult = _num1 * _num2;
        int _div = _num1 / _num2;
        int _mod = _num1 % _num2;
        int _sqr = _num1 ** 2;

        return(_add, _sub, _mult, _div, _mod, _sqr);
    }
    //Generate random value
    function getRandNum(uint _max) public view returns(uint)
    {
        //Keccak takes input and convert it to random 256bit hexadecimal number
        //abi.encodePacked does Packed encoding for keccak (must be done) 
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp)));
        return rand % _max;
    }

    // Strings

    string str1 = "Hello";

    //memory says that we want to temporarily store strings data (only with strings, arrays, bytes)
    function combineStrings(string memory _str1, string memory _str2) public pure returns(string memory)
    {
        return string(abi.encodePacked(_str1," ", _str2));
    }

    //Working with bytes saves computation (opposed to working with strings)

    function numChars(string memory _str1) public pure returns(uint)
    {
        bytes memory _byte1 = bytes(_str1);
        return _byte1.length;
    }

    // Conditionals
    // Comparison Operators: == != > < >= <=
    // Logical Operators: && || !

    uint age = 17;

    function whatSchool() public view returns(string memory)
    {
        if(age < 5)
        {
            return "Stay home!";
        }
        if(age >= 5 && age <= 6)
        {
            return "Go to kindergarten.";
        }
        if(age > 6 && age <= 17)
        {
            uint _grade = age - 5;
            string memory _gradeStr = Strings.toString(_grade);
            return string(abi.encodePacked("Grade ", _gradeStr));
        }
        else
        {
            return "Go to college.";
        }
    }

    // Dynamic array.
    uint[] arr1;
    //Static array (saves memory)
    uint[10] arr2;

    uint [] public numList = [1, 2, 3, 4, 5];

    function addToArr(uint num) public
    {
        arr1.push(num);
    }

    function removeFromArr() public
    {
        arr1.pop();
    }

    function getLength() public view returns(uint)
    {
        return arr1.length;
    }

    function setIndexValueToZero(uint _index) public
    {
        delete arr1[_index];
    }

    function forLoop() external pure 
    {
        for(uint i = 0; i < 10; i++)
        {
            //some code
            if (i == 3)
            {
                continue;   //Something like break, just goes instantly to next iteration.
            }
            //more code (wont be executed if i is 3).
            if(i == 5)
            {
                break;  //Exits loop when i is 5 so it wont go 6, 7...
            }
        }
    }

    function whileLoop() external pure
    {
        uint j = 0;

        while(j < 10)
        {
            //some code
            j++;
        }
    }

    function removeIndex(uint _index) public 
    {
        for(uint i = _index; i < arr1.length - 1; i++)
        {
            arr1[i] = arr1[i + 1];
        }
        arr1.pop(); //Duplicate on end.
    }

    function getArrVals() public view returns(uint[] memory)
    {
        return arr1;    //Return whole array.
    }

    function sumNums() public view returns(uint)
    {
        uint _sum = 0;

        for(uint i = 0; i < numList.length; i++)
        {
            _sum += numList[i];
        }
        return _sum;
    }

    //FUNCTION MODIFIER
    //- easier to understand,
    //- can be called before and after function,
    //- also probably cheaper than function because when the contract is compiled, all the code inside a modifier is copy and pasted into the function
    //function
    //- cheaper to deploy (unlike modifier, function code is not copy & pasted where it is invoked)

    bool public paused;
    uint public counter;
    //Basic modifier
    modifier whenNotPaused()
    {
        require(!paused, "paused");
        _; //This tells it to invoke the function it modifies
    }
    //Input modifier
    modifier cap(uint _x)
    {
        require(_x < 100, "x >= 100");
        _;
    }

    //Sandwich modifier
    modifier sandwich()
    {
        counter += 10;  //do something
        _;              //call function
        counter += 2;   //do something more for next call
    }

    function inc() external whenNotPaused
    {
        counter += 1;
    }


    //CONSTRUCTOR
    address public owner;
    uint public x;
    /*
    constructor(uint _x)
    {
        owner = msg.sender; //Set owner to account that deployed this contract.
        x = _x;
    }
    */


    //FUNCTION OUTPUTS
    //There can be: multiple outputs, named outputs, destructuring assignment
    
    //Returns multiple outputs
    function returnMany() public pure returns(uint, bool)
    {
        return(1, true);
    }

    //Returns named outputs
    function returnNamed() public pure returns(uint a, bool b)
    {
        a = 1;
        b = true; //Auto returns x and b
    }

    //Destructuring Assignment
    function destruct() public pure 
    {
        (uint c, bool b) = returnMany();
        (, bool _b) = returnMany(); //Take just second output
        //Added this code so errors would stop.
        c++;
        b = true;
        _b = true;
    }

}