// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC20
{
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    //Send IERC20 token to recipient
    function transfer(address recipient, uint amount) external returns (bool);

    //Shows how much is spender allowed to spend from owner
    function allowance(address owner, address spender)
        external
        view
        returns(uint);

    //Owner of IERC20 token approves spender to spend some of his tokens
    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address spender,
        address recipient,
        uint amount
    ) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

//implements all functions from interface
contract ERC20 is IERC20 
{
    uint public override totalSupply;
    mapping(address => uint) public override balanceOf;
    mapping(address => mapping(address => uint)) public override allowance; //Allowance from owner address to spender address with amount

    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18; //How many 0's are used to represent ERC20 token

    function transfer(address recipient, uint amount) external override returns (bool)
    {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);

        return true;
    }

    function approve(address spender, uint amount) external override returns (bool)
    {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transferFrom(
        address spender,
        address recipient,
        uint amount
    ) external override returns(bool)
    {
        allowance[spender][msg.sender] -= amount;
        balanceOf[spender] -= amount;
        balanceOf[recipient] += amount;

        emit Transfer(spender, recipient, amount);

        return true;
    }

    function mint(uint amount) external 
    {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external 
    {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;

        emit Transfer(msg.sender, address(0), amount);       
    }
}