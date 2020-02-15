var Chain3 = require('chain3');
var chain3 = new Chain3(new Chain3.providers.HttpProvider('https://mtnode1.jccdex.cn'));

const abi = require('./JCCPrice.abi.js').abi;
const contractAddress = '';
const admin = {'address': '', 'secret':''};

function getPrice(_symbol) {
  // var abi = JSON.parse(abiString);
  var contract = chain3.mc.contract(abi);
  var token = contract.at(contractAddress);
  var ret = token.getPrice(_symbol);
  var _p = {'symbol':ret[0], 'price':chain3.fromSha(ret[1]), 'update': ret[2]};
}

getPrice('ETHUSDT');


// export const moacInstance = (() => {
//     let inst: Moac | null = null;
  
//     const get = (node: string): Moac => {
//       if (inst === null) {
//         const mainnet = isMainnet();
//         inst = new Moac(node, mainnet);
//         inst.initChain3();
//       }
//       return inst;
//     };
  
//     const destroy = () => {
//       inst = null;
//     };
  
//     return { get, destroy };
//   })();
  
//   export const ensInstance = (() => {
//     let inst: ENSRegistryContract | null = null;
  
//     const init = (node: string): ENSRegistryContract => {
//       if (inst === null) {
//         const contractAddress = process.env.ENSContract;
//         const moac = moacInstance.get(node);
//         inst = new ENSRegistryContract(contractAddress);
//         inst.initContract(moac);
//       }
  
//       return inst;
//     };
  
//     const destroy = () => {
//       inst = null;
//     };
  
//     return {
//       destroy,
//       init
//     };
//   })();