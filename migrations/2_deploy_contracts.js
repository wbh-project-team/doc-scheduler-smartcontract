const DocScheduler = artifacts.require('DocScheduler');
const DateTimeLibrary = artifacts.require('DateTimeLibrary');
const DateTimeContract = artifacts.require('DateTimeContract');

module.exports = function (deployer) {
  deployer.deploy(DateTimeLibrary);
  deployer.link(DateTimeLibrary, DateTimeContract);
  deployer.deploy(DateTimeContract);
  deployer.link(DateTimeContract, DocScheduler);
  deployer.deploy(DocScheduler, '0xe00A38B6F023D9a79B7da6D881832379cf53288D');
};
