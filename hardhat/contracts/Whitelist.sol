// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract Whitelist {
    address public owner;
    mapping(address => bool) public whitelist;
    address[] public tempWhitelist;

    event Added(address addressAdded); //emit when an address gets added to whitelist
    event Removed(address addressRemoved); //emit when an address gets removed from whitelist

    constructor() {
        owner = msg.sender;
    }

    function setOwner(address _owner) public onlyOwner {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function addToWhitelist(address _addr) public onlyOwner {
        whitelist[_addr] = true;
        emit Added(_addr);
    }

    function removeFromWhitelist(address _addr) public onlyOwner {
        whitelist[_addr] = false;
        emit Removed(_addr);
    }

    function isWhitelisted(address _addr) public view returns (bool) {
        return whitelist[_addr];
    }
}
