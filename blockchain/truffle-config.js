var HDWalletProvider = require("@truffle/hdwallet-provider");
const mnemonic = "thumb indoor rotate unlock sun wine depart cruise vehicle poverty spot fatigue";

module.exports = {
  plugins: ["truffle-security"],
  contracts_directory: "./contracts",
  contracts_build_directory: "./build",
  migrations_directory: "./migrations",
  networks: {
    
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*", 
      gas: 6721975, 
      gasPrice: 2000000, 
      maxFeePerGas: 10, 
      maxPriorityFeePerGas: 10, 
      
    },
    
  },
  compilers: {
    solc: {
      version: "^0.8.12", 
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
        evmVersion: "istanbul", 
      },
     
    },
    
  },
  
};
