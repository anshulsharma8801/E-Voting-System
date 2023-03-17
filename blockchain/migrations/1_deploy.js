const Ballot = artifacts.require("Ballot");
const Types = artifacts.require("Types");



module.exports = function (deployer, network) {
  if (network == "development") {
    deployer.deploy(Types);
    deployer.link(Types, Ballot);
    deployer.deploy(Ballot, 1673171253, 1673862450);
  } else {
    deployer.deploy(Types);
    deployer.link(Types, Ballot);
    deployer.deploy(Ballot, 1673171253, 1673862450);
  }
};
