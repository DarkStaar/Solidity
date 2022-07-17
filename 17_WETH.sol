// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Wrapped ETH
// WETH wraps into ERC20 token
// When you deposit ETH, ERC20 token is minted
// When you withdraw ETH, ERC20 token is burned
// Commonly used in DeFi projects

import "@rari-capital/solmate/src/tokens/ERC20.sol";

contract WETH is ERC20
{
    event Deposit(address indexed account, uint amount);
    event Withdraw(address indexed account, uint amount);

    constructor() ERC20("Wrapped Ether", "WETH", 18)
    {

    }

    fallback() external payable
    {
        deposit(); //Public because of this call
    }

    function deposit() public payable 
    {
        _mint(msg.sender, msg.value);

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) external 
    {
        _burn(msg.sender, _amount);

        payable(msg.sender).transfer(_amount);

        emit Withdraw(msg.sender, _amount);
    }
}