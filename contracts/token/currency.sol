// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/* @dev: @PatoVerde
* Only a token for testing purposes (ohMyMinter game).
*/

contract currency is ERC20, Ownable {
    constructor() ERC20("currency", "CRY") {
        uint amount = 50000000 * 1 ether;
        _mint(msg.sender,amount);
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}