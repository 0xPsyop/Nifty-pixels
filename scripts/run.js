// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//

// This contract is used to run the contract in the localhost node
const hre = require("hardhat");

async function main() {


  const NiftyContract = await hre.ethers.getContractFactory("NiftyPixels");
  const deployedNiftyContract = await NiftyContract.deploy();

  await deployedNiftyContract.deployed();

  console.log(
    "succesfully deployed"
  );

  let txn  = await deployedNiftyContract.mintPixel();
  await txn.wait();

  console.log("minted");

  //let uri  = await deployedNiftyContract.tokenURI();
 // console.log(uri);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
