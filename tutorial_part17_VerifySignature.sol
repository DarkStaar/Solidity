// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

/*
0. message to sign
1. hash(message)
2. sign(hash(message), private key) | done offchain
3. ecrecover(hash(message), signature) == returns signer
*/

contract VerifySignature
{
    function verify(address _signer, string memory _message, bytes memory _sig)
    external pure returns(bool) //signer address is what we expect verify to return
    {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    function getMessageHash(string memory _message) public pure returns (bytes32)
    {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(bytes32 _hash) public pure returns(bytes32)
    {
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _hash
        )); //This is getting hashed version of offchain signing, it takes keccak256 hash and adds string prefix to it
    }

    function recover(bytes32 _ethSignedMessageHash, bytes memory _sig)
    public pure returns(address)
    {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);
        return ecrecover(_ethSignedMessageHash, v, r, s); //return address of signer with these params
    }

    function _split(bytes memory _sig) internal pure returns(bytes32 r, bytes32 s, uint8 v)
    {
        //Signature length should be 65 32 + 32 + 1 = 65
        require(_sig.length == 65, "Invalid signature length");

        assembly
        {
            //First 32 bytes records length of data for dynamic types(_sig)
            //_sig is pointer to where is signature stored in memory

            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96))) //get first byte  after 96
        }
    }
}