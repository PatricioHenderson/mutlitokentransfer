const { StandardMerkleTree } = require("@openzeppelin/merkle-tree");
const fs = require("fs");
const path = require("path");


const values = [
  ["0x1111111111111111111111111111111111111111", "1"],
  ["0x2222222222222222222222222222222222222222", "1"]
];

const tree = StandardMerkleTree.of(values, ["address", "uint256"]);
console.log('Merkle Root:', tree.root);
const filePath = path.join(__dirname, "tree.json");
fs.writeFileSync(filePath, JSON.stringify(tree.dump()));
