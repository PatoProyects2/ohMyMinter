// SPDX-License-Identifier: MIT
// @dev: @PatoVerde
pragma solidity ^0.8.14;

import "./ConfigureLogic.sol";

contract GameLogic is ConfigureLogic {
  uint public auctionCount = 0;

  constructor (IERC20 _currency,ohMyMinter _tokenNFT) ConfigureLogic(_currency, _tokenNFT) {}

  function setAndStart(uint _initialPrice) public {
    setInitialPrice(_initialPrice);
    setBasePrice(_initialPrice);    
    startAuction();
  }

  function buy()public {
    uint currentPrice = getCurrentPrice();
    auctionCount++;
    require(currency.balanceOf(msg.sender) >= currentPrice, "You don't have enough tokens");
    require(currency.transferFrom(msg.sender, address(this), currentPrice), "error in transfer tokens");
    priceOfBuy[auctionCount] = currentPrice;
    setInitialPrice(currentPrice);  
    startAuction();
    token.safeMint(msg.sender);
  }

  function redeemAndBurn(uint _id) public returns(bool){
    require(token.ownerOf(_id) == msg.sender, "You are not the owner of this token");
    token.transferFrom(msg.sender, address(this), _id);
    uint toPay = priceOfBuy[auctionCount+1];  //guarda con entrar en posiciones no existentes!!
    currency.transfer(msg.sender, toPay);
    return true;
  }

  function getCurrentPrice()public view returns(uint) {
    uint finalTime = auctionMaxDuration + auctionsStartDate;
    if(block.timestamp >= finalTime) {
      return minimalPrice;
    }

    uint price = (initialPrice * 2) + (basePrice * auctionCount);     
    uint difTime = block.timestamp - auctionsStartDate;
    
    uint discountPerSecond = (price - minimalPrice) / (finalTime - auctionsStartDate);
    uint currentPrice = price - (discountPerSecond * difTime);

    return currentPrice;
  }
  
}
