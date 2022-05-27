// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MoonSharkNFT is ERC721 {
    uint256 public nftId;

    constructor() ERC721("MoonShark", "MOON") { }

    function mint() public {
        nftId++;
        _safeMint(msg.sender, nftId);
    }
}
