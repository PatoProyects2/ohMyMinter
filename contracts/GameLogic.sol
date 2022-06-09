// SPDX-License-Identifier: MIT
// @dev: @PatoVerde
pragma solidity ^0.8.14;

import "./ConfigureLogic.sol";

contract GameLogic is ConfigureLogic {
  uint public auctionCount = 0;

  constructor (IERC20 _currency, IERC721 _token) ConfigureLogic(_currency, _token) {}

  function setAndStart(uint _initialPrice, uint _auctionInitialDuration) public {
    setInitialPrice(_initialPrice);
    setBasePrice(_initialPrice);
    setAuctionInitialDuration(_auctionInitialDuration);
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
    // token.mint(msg.sender);
  }

  function redeemAndBurn(uint _id) public returns(bool){
    require(token.ownerOf(_id) == msg.sender, "You are not the owner of this token");
    token.transferFrom(msg.sender, address(this), _id);
    uint toPay = priceOfBuy[auctionCount+1];  //guarda con entrar en posiciones no existentes!!
    currency.transfer(msg.sender, toPay);
    return true;
  }

  //
  function getCurrentPrice()public view returns(uint) {
    uint price = (initialPrice * 2) + (basePrice * auctionCount);     
    uint finalTime = auctionMaxDuration + auctionsStartDate;
    uint difTime = block.timestamp - auctionsStartDate;

    uint discountPerSecond = (price - minimalPrice) / (finalTime - auctionsStartDate);
    uint currentPrice = price - (discountPerSecond * difTime);
    return currentPrice;
  }
  
}
