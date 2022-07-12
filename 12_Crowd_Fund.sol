// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./IERC20.sol";

contract CrowdFund 
{

    event Launch(uint id, address indexed creator, uint goal, uint32 start, uint32 end);
    event Cancel(uint idOfCampaign);
    event Pledge(uint indexed idOfCampaign, address indexed pledger, uint amount);
    event Unpledge(uint indexed idofCampaign, address indexed pledger, uint amount);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed caller, uint amount);

    struct Campaign 
    {
        address creator;
        uint goal;
        uint pledged;
        uint32 startAt;
        uint32 endAt;   //uint32 can hold time until 100 years from now
        bool claimed; //Check if tokens are claimed
    }

    IERC20 public immutable token;

    uint public count; //unique id for campaign
    mapping(uint => Campaign) public campaigns; //uint is id of campaign
    mapping(uint => mapping(address => uint)) public pledgedAmount; //uint - ID of Campaing | address - address of pledger | uint - amount pledged

    constructor
    (
        address _token
    )
    {
        token = IERC20(_token);
    }

    function launch
    (
        uint _goal,
        uint32 _startAt,
        uint32 _endAt
    ) external
    {
        require(block.timestamp <= _startAt, "start < now");
        require(_endAt >= _startAt, "end < start");
        require(_endAt <= block.timestamp + 90 days, "end > max duration");

        count += 1;
        campaigns[count] = Campaign(
            {
                creator: msg.sender,
                pledged: 0,
                goal: _goal,
                startAt: _startAt,
                endAt: _endAt,
                claimed: false
            }
        );

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    //Cancel Campaign
    function cancel(uint _id) external 
    {
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp < campaign.startAt, "already started");

        delete campaigns[_id];

        emit Cancel(_id);
    }
    //Pledge tokens
    function pledge(uint _id, uint _amount) external 
    {
        Campaign storage campaign = campaigns[_id]; //storage because we update struct
        require(block.timestamp >= campaign.startAt, "Not started");
        require(block.timestamp <= campaign.endAt, "Ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;

        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }
    //Changed mind?
    function unpledge(uint _id, uint _amount) external 
    {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "Not started");
        require(block.timestamp <= campaign.endAt, "Ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;

        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }
    //Creator can claim all tokens if goal is met
    function claim(uint _id) external 
    {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "not creator");
        require(block.timestamp > campaign.endAt, "Ended");
        require(campaign.pledged >= campaign.goal, "Pledged < goal");
        require(!campaign.claimed, "claimed already");

        campaign.claimed = true;

        token.transfer(msg.sender, campaign.pledged);

        emit Claim(_id);
    }
    //If goal is not met users can refund their tokens
    function refund(uint _id) external 
    {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "Ended");
        require(campaign.pledged < campaign.goal, "Pledged < goal");

        uint balance = pledgedAmount[_id][msg.sender];

        pledgedAmount[_id][msg.sender] = 0;

        token.transfer(msg.sender, balance);

        emit Refund(_id, msg.sender, balance);
    }
}