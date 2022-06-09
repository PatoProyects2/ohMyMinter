// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ConfigureLogic is Ownable{  
  IERC20 public currency;
  IERC721 public token;
  uint public basePrice;
  uint public initialPrice;
  uint public minimalPrice = 1 ether; // 1 usd convertirlo en funcion en porcentual 75% de caida;
  uint public auctionInitialDuration;
  uint public auctionMaxDuration= 20 days;
  uint public auctionsStartDate;

  mapping(uint256 => uint256) public priceOfBuy;

  constructor(IERC20 _currency, IERC721 _token) {
    currency = _currency;
    token = _token;
  }

  function setBasePrice(uint _basePrice) public {
    basePrice = _basePrice;
  }

  function setInitialPrice(uint _initialPrice) public onlyOwner{
    initialPrice = _initialPrice;
  }

  function setAuctionInitialDuration(uint _auctionInitialDuration) public onlyOwner{
    auctionInitialDuration = _auctionInitialDuration;
  }

  function setCurrency(IERC20 _currency) public onlyOwner{
    currency = _currency;
  }
  
  function setToken(IERC721 _token) public onlyOwner{
    token = _token;
  }

  function setMinimalPrice(uint _minimalPrice) public onlyOwner{
    minimalPrice = _minimalPrice;
  }

  function setAuctionMaxDuration(uint _days) public onlyOwner{
    auctionMaxDuration = _days;
  }

  function startAuction()internal onlyOwner{
    auctionsStartDate = block.timestamp;
  }  
}

/* @dev: @PatoVerde
* Contracto que controla el juego de la aplicación.
* CONTROL FLOW: 
> User buy a erc721 token (mint), in dutch sistem. Use stable Erc20 like usdt usdc...
> User can burn token for the price of next buyyer. 
> The price can double or half, depend of time.
*/
