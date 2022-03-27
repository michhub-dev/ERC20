// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./erc20.sol";

// import openzeppelin 

import "@openzeppelin/contracts/access/Ownable.sol";

contract sender is Ownable {

  // my Token Contract
  MyToken varToken;

  // eth token price
  uint256 public tokensPrice = 1000;

  // Event that log buy operation
  event BuyTokens(address buyer, uint256 amountETH, uint256 amountTokens);

  constructor(address tokenAddress) {
    varToken = MyToken(tokenAddress);
  }

  /**
  * Allow users to buy token for ETH
  */
  function buyTokens() public payable returns (uint256 tokenAmount) {
    require(msg.value > 0, "Send ETH to buy some tokens");

    uint256 buyAmount = msg.value * tokensPrice;

    // check if the sender has enough amount of tokens for the transaction
    uint256 senderBalance = varToken.balanceOf(address(this));
    require(senderBalance >= buyAmount, "senders contract doesn't have enough tokens in its balance");

    // Transfer the token to msg.sender
    (bool sent) = varToken.transfer(msg.sender, buyAmount);
    require(sent, "Failed to transfer token to user");

    // emit the event
    emit BuyTokens(msg.sender, msg.value, buyAmount);

    return buyAmount;
  }

  /**
  * @notice this allows the owner of the contract to withdraw ETH
  */
  function withdrawEth() public onlyOwner {
    uint256 ownerBalance = address(this).balance;
    require(ownerBalance > 0, "the owner has no balance to withdraw");

    (bool sent,) = msg.sender.call{value: address(this).balance}("");
    require(sent, "Failed to return user balance to the owner");
  }
}
