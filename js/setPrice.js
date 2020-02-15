var Chain3 = require('chain3');
var chain3 = new Chain3(new Chain3.providers.HttpProvider('https://mtnode1.jccdex.cn'));

const abi = require('./JCCPrice.abi.js').abi;
const contractAddress = '';
const admin = {address: '', secret:''};

function setPrice(_symbol, _price) {
  //var abi = JSON.parse(abiString);
  var contract = chain3.mc.contract(abi);
  var instance = contract.at(contractAddress);
  var _data = instance.setPrice.getData(_symbol, chain3.toSha(_price));
  //var _data = chain3.sha3('setPrice(string,uint256)').substr(0, 10)+ chain3.encodeParams(['string', 'uint256'], [_symbol, _price]);
  var _nonce = chain3.mc.getTransactionCount(admin.address);
  var rawTx = {
    from: admin.address,
    nonce: chain3.intToHex(_nonce),
    gasPrice: chain3.intToHex(20000000000),
    gasLimit: chain3.intToHex(200000),
    to: contractAddress,
    data: _data,
    chainId: chain3.version.network
  };
  var signedTx = chain3.signTransaction(rawTx, admin.secret);
  chain3.mc.sendRawTransaction(signedTx, function(err, hash) {
      if (!err){
    console.log("Succeed!: ", hash);
    return hash;
      }else{
    console.log("Chain3 error:", err.message);
    return err.message;
      }
  });
}
setPrice('ETHUSDT', 350);