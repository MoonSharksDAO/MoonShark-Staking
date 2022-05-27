//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

/// @title Template Dummy Smart Contract
/// @notice used to show smart contract functionalities and used for natspec doc generation
contract Greeter {
    string private greeting;

    /// @notice shows the use case of smart contract constructor
    /// @param _greeting gets input from user and sets greeting state variable
    constructor(string memory _greeting) {
        console.log("Deploying a Greeter with greeting:", _greeting);
        greeting = _greeting;
    }

    /// @notice get function for greeting state variable , showcases hardhat console
    /// @return returns greeting state variable
    function greet() public view returns (string memory) {
        return greeting;
    }

    /// @notice sets state variable from parameter , showcases hardhat console
    /// @param _greeting gets string input to set greeting string private state variable
    function setGreeting(string memory _greeting) public {
        console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
        greeting = _greeting;
    }
}
