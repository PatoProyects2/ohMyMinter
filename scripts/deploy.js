const hre = require("hardhat");

async function main() {
  const Currency = await hre.ethers.getContractFactory("currency");
  const currency = await Currency.deploy();
  await currency.deployed();
  console.log("MyCurrency deployed to:", currency.address);

  const OhMyMinter = await hre.ethers.getContractFactory("ohMyMinter");
  const ohMyMinter = await OhMyMinter.deploy();
  await ohMyMinter.deployed();
  console.log("OhMyMinter deployed to:", ohMyMinter.address);

  const GameLogic = await hre.ethers.getContractFactory("GameLogic");
  const gameLogic = await GameLogic.deploy(currency.address, ohMyMinter.address);
  await gameLogic.deployed();
  console.log("GameLogic deployed to:", gameLogic.address);
}
main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });