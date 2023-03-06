const DocScheduler = artifacts.require('DocScheduler');
const DateTimeContract = artifacts.require('DateTimeContract');

module.exports = function (deployer) {
  // deployer.deploy(DocScheduler);
  deployer.deploy(DateTimeContract);
};
