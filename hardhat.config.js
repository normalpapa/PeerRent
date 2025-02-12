require("@nomicfoundation/hardhat-toolbox");
<<<<<<< HEAD
require("dotenv").config();

module.exports = {
  solidity: "0.8.28",
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY, process.env.BORROWER_PRIVATE_KEY]
    }
  }
=======

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
>>>>>>> 0b2b025 (Initialized Hardjat amd added RentalAgreement.sol)
};
