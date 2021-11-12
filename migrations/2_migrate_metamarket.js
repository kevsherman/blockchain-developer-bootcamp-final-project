const MetaMarket = artifacts.require("./MetaMarket.sol");

module.exports = function (deployer) {
  deployer.deploy(MetaMarket);
};
