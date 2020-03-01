const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

// delete build folder if exists
const buildPath = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

// get campaign file path and contents
const campaignPath = path.resolve(__dirname, 'contracts', 'Campaign.sol');
const source = fs.readFileSync(campaignPath, 'utf8')

// compile campaign file contents
const output = solc.compile(source, 1).contracts;

// recreate build folder
fs.ensureDirSync(buildPath);

console.log("output : ", output)
for (let contract in output) {
    fs.outputJsonSync(
        path.resolve(buildPath, contract.replace(':', '') + '.json'),
        output[contract]
    );
}