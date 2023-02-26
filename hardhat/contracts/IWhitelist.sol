pragma solidity ^0.8.0;

interface IWhitelist {
    event Added(address addressAdded); //emit when an address gets added to whitelist
    event Removed(address addressRemoved); //emit when an address gets removed from whitelist

    function addAddress(address newAddress) external returns (bool);

    function removeAddress(address userAddress) external returns (bool);

    function isWhitelisted(address userAddress) external view returns (bool);
}
