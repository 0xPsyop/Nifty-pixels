const { expect } = require("chai");
const { ethers } = require("hardhat");

describe( "nft contract" , function() {
  
    it("should mint an NFT succesfuly", async function(){

        const[addr1, addr2] = await ethers.getSigners();
        const NiftyContract = await hre.ethers.getContractFactory("NiftyPixels");
        const deployedNiftyContract = await NiftyContract.deploy();
        
        await deployedNiftyContract.connect(addr1).mintPixel();
        await deployedNiftyContract.connect(addr2).mintPixel();
        expect(await deployedNiftyContract.totalSupply ()).to.equal(2);

    })
})