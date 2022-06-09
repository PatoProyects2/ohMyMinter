# Game  0.1.0
ohMyMinter is a simple nft-based game, where user can buy a nft. 
 The price of nft is movil depend of: 
> base price (initial price of first auction)
> auction number
> time (difference between current time and start time )
> minimal price

yes, fine, but why i buy this nft?
 you can redeem you nft, for the price of buy of next nft. Can be more of you buy(much more) or much less(10-25% of you price).
 you do not depend on the previous purchase, only depends of the next buy.

And that's all for now.



Road Map and ideas:
# Game 0.2.0 
> Garbage token collector, this contract can be convert in a rabit hole where part of money never used.
For this implement garbage token collector, this sistem will redirect (money that can never be repaid) to a pool, where the nfts owner can change your nft
for weight(weight based in bought price of nft) and get some of garbage cake. Yes, garbage = coin used in nft mint. it no personal, you can use the erc of your choice.

# Need a guide? contact with me in twitter
 @Patoverde_




# Advanced Sample Hardhat Project

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
node scripts/deploy.js
npx eslint '**/*.js'
npx eslint '**/*.js' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.js
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
