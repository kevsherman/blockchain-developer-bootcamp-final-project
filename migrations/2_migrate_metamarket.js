const MetaMarket = artifacts.require("./MetaMarket.sol");
const WorldSwapToken = artifacts.require("./WorldSwapToken.sol");

module.exports = function (deployer) {
  deployer.deploy(MetaMarket);
  deployer.deploy(WorldSwapToken);
};
