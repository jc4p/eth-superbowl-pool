const BigGamePool = artifacts.require("BigGamePool");

module.exports = function(deployer) {
  deployer.deploy(BigGamePool);
};
