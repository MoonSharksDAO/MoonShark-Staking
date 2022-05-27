// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "hardhat/console.sol";

contract MoonSharkStaker is ERC20,ReentrancyGuard {
    IERC721 moonSharkNFT;

    uint256 SECONDS_PER_DAY = 24 * 60 * 60;
    // Give 1000 tokens
    // 1000 ether == 10 * 10**18
    uint256 BASE_YIELD_RATE = 1000 ether;

    struct Staker {
        uint256 currYield;
        uint256 rewards;
        uint256 lastCheckpoint;
    }

    mapping(address => Staker) public stakers;
    mapping(uint256 => address) public nftOwners;

    constructor( address _nftContract, string memory name, string memory symbol) ERC20(name, symbol) {
      moonSharkNFT = IERC721(_nftContract);
    }

    function stake(uint256[] memory nftIds) external {
      // Remember : User must approve their nft with certain id & this contract address , or else error will happen
      Staker storage user = stakers[msg.sender];
      uint256 yield = user.currYield;

      uint256 length = nftIds.length;
      for (uint256 i = 0; i < length; ++i) {
        require( moonSharkNFT.ownerOf(nftIds[i]) == msg.sender, "Not Owner");
        moonSharkNFT.safeTransferFrom( msg.sender, address(this), nftIds[i]);
        nftOwners[nftIds[i]] = msg.sender;
        yield += BASE_YIELD_RATE;

        console.log("Staked Token ID: ", nftIds[i]);
      }

      accumulate(msg.sender);
      user.currYield = yield;

      console.log("New Yield per day: ", user.currYield);
    }

    function unstake(uint256[] memory nftIds) external {
      Staker storage user = stakers[msg.sender];
      uint256 yield = user.currYield;

      uint256 length = nftIds.length;
      for (uint256 i = 0; i < length; ++i) {
        require(moonSharkNFT.ownerOf(nftIds[i]) == address(this), "Not Staked");
        require(nftOwners[nftIds[i]] == msg.sender, "Not Original Owner");

        if (user.currYield != 0) {
          yield -= BASE_YIELD_RATE;
        }

        moonSharkNFT.safeTransferFrom( address(this), msg.sender, nftIds[i]);
        console.log("Unstaked Token ID: ", nftIds[i]);
      }

      accumulate(msg.sender);
      user.currYield = yield;

      console.log("New Yield per day: ", user.currYield);
    }

    function claim() external nonReentrant {
      // Added ReEntrancy Vulnerability Handler
      Staker storage user = stakers[msg.sender];
      accumulate(msg.sender);

      console.log("Minting ", user.rewards, " tokens to ", msg.sender);

      _mint(msg.sender, user.rewards);
      user.rewards = 0;

      console.log("Rewards set to 0 for ", msg.sender);
    }

    function accumulate(address staker) internal {
      stakers[staker].rewards += getRewards(staker);
      stakers[staker].lastCheckpoint = block.timestamp;
    }

    function getRewards(address staker) public view returns (uint256) {
      Staker memory user = stakers[staker];
      if (user.lastCheckpoint == 0) {
        return 0;
      }

      console.log("Last Checkpoint: ", user.lastCheckpoint);
      console.log("Block Timestamp: ", block.timestamp);
      console.log( "Rewards: ", ((block.timestamp - user.lastCheckpoint) * user.currYield) / SECONDS_PER_DAY);

      // General Formula for accumilation
      // 
      // Give 1000 Tokens Every 24 hour :> , currYield is 1000 & SECONDS_PER_DAY is 24 hours in seconds
      //
      // block.timestamp - user.lastCheckpoint = gives how much time has passed since the last time the rewards has been calculated
      // currentYield is based on how many tokens to give every 24 hours
      // currentYield / Seconds Per Day == Yield Per Second
      return ((block.timestamp - user.lastCheckpoint) * user.currYield) / SECONDS_PER_DAY;
    }

    function ownerOf(uint256 nftId) external view returns (address) {
      return nftOwners[nftId];
    }

    // Must have this function IF running ERC721 safeTransfer , letting the NFT contract know this contract is safe to transfer NFT's
    function onERC721Received( address, address, uint256, bytes calldata) external pure returns (bytes4) {
      return bytes4( keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}
