// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

interface IERC721 
{
    function transferFrom
    (
        address from,
        address to,
        uint nftId
    ) external;
}

contract EnglishAuction
{
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address bidder, uint amount);

    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor
    (
        address _nft,
        uint _nftId,
        uint _startingBid
    )
    {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external 
    {
        require(msg.sender == seller, "Not seller.");
        require(!started, "Already started");

        started = true;

        endAt = uint32(block.timestamp + 60); //set to 60 seconds, for testing
        nft.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    function bid() external payable 
    {
        require(started, "Not started");
        require(block.timestamp < endAt, "Ended");
        require(msg.value > highestBid, "value < highest bid");

        if(highestBidder != address(0))
        {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external 
    {
        uint balance = bids[msg.sender];
        bids[msg.sender] = 0;

        payable(msg.sender).transfer(balance);

        emit Withdraw(msg.sender, balance);
    }

    function end() external 
    {
        require(started, "Not started.");
        require(!ended, "ended");
        require(block.timestamp >= endAt, "Not ended");

        ended = true;

        if(highestBidder != address(0))
        {
            nft.transferFrom(address(this), highestBidder, nftId); //address(this) is contract

            seller.transfer(highestBid);
        }
        else 
        {
            nft.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}