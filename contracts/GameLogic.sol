// SPDX-License-Identifier: MIT
// @dev: @PatoVerde
pragma solidity ^0.8.14;

import "./ConfigureLogic.sol";

contract GameLogic is ConfigureLogic {
  uint public auctionCount;

  struct profit {
    uint256 profits;
    bool isprofit;
  }
  uint public totalGarbage;

  constructor (IERC20 _currency,ohMyMinter _tokenNFT) ConfigureLogic(_currency, _tokenNFT) {
    auctionCount = _tokenNFT.totalSupply();
  }

  function setAndStart(uint _initialPrice) public onlyOwner{
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
    require(checkMaySell(_id), "You can't sell this token");    
    uint toPay = priceOfBuy[_id+1];  //+1 because need the next sell price

    priceOfSell[_id] = toPay;
    token.transferFrom(msg.sender, address(this), _id);
    currency.transfer(msg.sender, toPay);
    _gargbageCollect(getDifference(_id));

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

  function getDifference(uint _id)public view returns(profit memory){
    uint buyPrice = priceOfBuy[_id];
    uint sell = priceOfSell[_id];
    profit memory profitResults;
    if(buyPrice > sell){
      profitResults.profits = buyPrice - sell;
      profitResults.isprofit = false;
    }else{
      profitResults.profits = sell - buyPrice;
      profitResults.isprofit = true;
    }
    return profitResults;
  }

  function checkMaySell(uint _id)public view returns(bool){
    return priceOfBuy[_id+1]>0;
  }

  function cleanGarbage(uint _ammount, address _owner)public onlyOwner{
    require(_ammount > 0, "You must send a positive amount");
    require(_ammount <= totalGarbage, "You don't have enough garbage");
    currency.transfer(_owner, _ammount);
    totalGarbage -= _ammount;
  }
  
  function _gargbageCollect(profit memory nonProfit) internal {
    if(!nonProfit.isprofit) {
      totalGarbage += nonProfit.profits;      
    }
  }
}
