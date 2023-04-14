const { expect } = require("chai");
const { loadFixture } = require("ethereum-waffle");
const { ethers } = require("hardhat");

describe( "nft contract" , function() {

     async function deployFixtures() {
        const[addr1, addr2] = await ethers.getSigners();
        const NiftyContract = await hre.ethers.getContractFactory("NiftyPixels");
        const deployedNiftyContract = await NiftyContract.deploy();

        return {addr1, addr2, deployedNiftyContract };
     }
  
    it("Should mint an NFT succesfuly", async() =>{

        const {deployedNiftyContract, addr1}  = await loadFixture(deployFixtures); 
        expect(await deployedNiftyContract.connect(addr1).mintPixel()).to.emit(1);


    });

    it("The minter should own 1 NFT" , async() => {

        const {deployedNiftyContract, addr1}  = await loadFixture(deployFixtures);
        expect(await deployedNiftyContract.connect(addr1).balanceOf(addr1.address)).to.equal(1);
   });

  
})