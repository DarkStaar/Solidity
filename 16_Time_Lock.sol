// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

//Purpose is to delay transaction
contract TimeLock 
{
    address public owner;
    uint public constant MIN_DELAY = 10; //usually from 1 day to 2 weeks
    uint public constant MAX_DELAY = 1000; //30 days usually
    uint public constant GRACE_PERIOD = 1000; //After tx is queued we have GRACE_PERIOD time to execute it

    event Queue(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );

    event Execute(
        bytes32 indexed txId,
        address indexed target,
        uint value,
        string func,
        bytes data,
        uint timestamp
    );

    event Cancel(bytes32 indexed txId);

    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInRangeError(uint blocktimestamp,uint _timestamp);
    error NotQueuedError(bytes32 txId);
    error TimestampNotPassedError(uint blocktimestamp, uint _timestamp);
    error TimestampExpiredError(uint blocktimestamp, uint _timestampgrace);
    error TxFailedError();

    mapping(bytes32 => bool) public queued;

    constructor()
    {
        owner = msg.sender;
    }

    receive() external payable {}

    modifier onlyOwner() 
    {
        if(msg.sender != owner)
        {
            revert NotOwnerError();
        }
        _;
    }

    function getTxId(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns(bytes32 txId)
    {
        return keccak256(abi.encode(
            _target, _value, _func, _data, _timestamp
        ));
    }
    //Queue signals that transaction will be executed
    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external onlyOwner
    {
        // Create tx id
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        // check tx id unique
        if(queued[txId])
        {
            revert AlreadyQueuedError(txId);
        }
        // check timestamp
        //                        this interval!                                  
        // ------|---------------|-------------|--------
        //     block       block + min      block + max

        if(_timestamp < block.timestamp + MIN_DELAY ||
           _timestamp > block.timestamp + MAX_DELAY)
           {
               revert TimestampNotInRangeError(block.timestamp, _timestamp);
           }
        // queue tx 
        queued[txId] = true;

        emit Queue(
            txId, _target, _value, _func, _data, _timestamp
        );
    }
    //Execute transaction
    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable onlyOwner returns(bytes memory)
    {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

        //check tx is queued
        if(!queued[txId])
        {
            revert NotQueuedError(txId);
        }
        //check block.timestamp > _timestamp
        if(block.timestamp < _timestamp)
        {
            revert TimestampNotPassedError(block.timestamp, _timestamp);
        }
        // Grace period
        //----------|-----------------------|------------
        //       timestamp           timestamp + grace period
        if (block.timestamp > _timestamp + GRACE_PERIOD)
        {
            revert TimestampExpiredError(block.timestamp, _timestamp + GRACE_PERIOD);
        }
        // delete tx from queue
        queued[txId] = false;

        bytes memory data;
        if(bytes(_func).length > 0)
        {
            data = abi.encodePacked(
                bytes4(keccak256(bytes(_func))), _data
            );
        }
        else 
        {
            data = _data;
        }
        // execute tx
        (bool ok, bytes memory res) = _target.call{value: _value}(data);
        if(!ok)
        {
            revert TxFailedError();
        }
        
        emit Execute(txId, _target, _value, _func, _data, _timestamp);

        return res;
    }

    function cancel(bytes32 _txId) external onlyOwner 
    {
        if(!queued[_txId])
        {
            revert NotQueuedError(_txId);
        }

        queued[_txId] = false;

        emit Cancel(_txId);
    }
}

contract TestTimeLock 
{
    address public timeLock;

    constructor(address _timeLock)
    {
        timeLock = _timeLock;
    }

    function test() external 
    {
        require(msg.sender == timeLock, "Not timelock");
        //more code here such as
        // - upgrade contract
        // - transfer funds
        // - switch price oracle
    }

    function getTimestamp() external view returns(uint)
    {
        return block.timestamp + 100;
    }
}