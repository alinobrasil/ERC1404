// SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IWhitelist.sol";

contract ERC1404 is ERC20 {
    mapping(uint8 => string) codeMessage;

    //need to enter address of whitelist contract
    address public constant WHITELIST_ADDRESS =
        0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    IWhitelist public constant whitelist = IWhitelist(WHITELIST_ADDRESS);

    constructor(string memory name_, string memory symbol_)
        ERC20(name_, symbol_)
    {
        codeMessage[0] = "No restriction";
        codeMessage[1] = "FROM address not whitelisted";
        codeMessage[2] = "TO address not whitelisted";
    }

    /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
    /// @param from Sending address
    /// @param to Receiving address
    /// @param value Amount of tokens being transferred
    /// @return Code by which to reference message for rejection reasoning
    function detectTransferRestriction(
        address from,
        address to,
        uint256 value
    ) public view returns (uint8) {
        //by default, return 0 if there are no restrictions detected
        //no restriction on value
        if (!whitelist.isWhitelisted(from)) {
            return 1;
        } else if (!whitelist.isWhitelisted(to)) {
            return 2;
        }
        return 0;
    }

    /// @notice Returns a human-readable message for a given restriction code
    /// @param restrictionCode Identifier for looking up a message
    /// @return Text showing the restriction's reasoning
    function messageForTransferRestriction(uint8 restrictionCode)
        public
        view
        returns (string memory)
    {
        return codeMessage[restrictionCode];
    }

    //should overwrite transfer/transferFRom functions so that they revert if a transfer restriction is detected
}
