# @mutliTokenTransfer
![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg)


## Quick Start


To run the project, git, yarn and node is required.
```bash
# Clone this repository
$ git clone https://github.com/PatricioHenderson/mutlitokentransfer.git

# Go into the repository
$ cd multitokentransfer

# Install dependencies
$ yarn

# Run tests to make sure everything is properly set up
$ npx hardhat test
```

## Merkle Tree
If need to generate new mekle tree (an example one it's in test/tree.json) just run 

```

 node test/merkle.js

 ```

## Deploy 
To deploy in goerly, must replace for your own values in scripts/deploygoerly.js
```

 npx hardhat run scripts/deploygoerly.js

 ```
To deploy in local with ganache, must replace with an own contract address and run
```

 npx hardhat run scripts/deploylocalganache.js

 ```



 



## Coverage Results

-------------------------|----------|----------|----------|----------|----------------|
File                     |  % Stmts | % Branch |  % Funcs |  % Lines |Uncovered Lines |
-------------------------|----------|----------|----------|----------|----------------|
 contracts/              |    85.71 |    55.56 |    72.73 |    89.47 |                |
  TestToken.sol          |       50 |      100 |       50 |       50 |             20 |
  multiTokenTransfer.sol |      100 |    55.56 |      100 |      100 |                |
  receiveEther.sol       |        0 |      100 |        0 |        0 |             15 |
-------------------------|----------|----------|----------|----------|----------------|
All files                |    85.71 |    55.56 |    72.73 |    89.47 |                |

Notes: 
    TestToken it's just for testing purposes.
    receiveEther.sol it's not tested because it's been taken from [official site](https://solidity-by-example.org/sending-ether/)
