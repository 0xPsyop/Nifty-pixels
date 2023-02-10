//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NiftyPixels is ERC721Enumerable, Ownable {
    
    // contract variables
    uint256 private immutable i_mintPrice = 0;
    uint256 private immutable i_maxSupply = 10000;
    
    mapping (uint256 => bool) public isIdClaimed;
    mapping (uint256 => string) public idToColor;


    string partOne = '<svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"> <rect width="100%" height="100%" fill="rgb(' ;
    string partThree =  ')"/></svg>';


   constructor(
    //uint256 mintPrice
    )ERC721("Nifty Pixels", "NP") payable {
           //i_mintPrice = mintPrice;

   }
   
   // check if the current supply isn't surpassing the max nft limit
   modifier notSold {
    uint256 totalSupply = totalSupply();
    require(i_maxSupply > totalSupply);
    _ ;
   }
  
    //Mint a random pixel 
   function mintPixel() public payable notSold {
      require(msg.value >= i_mintPrice, " You're just too poor lol");
      uint256 tokenId =  getRandomTokenId(totalSupply());
      _safeMint(msg.sender, tokenId);
      isIdClaimed[tokenId] = true;
      console.log(tokenId);
  
   }
  
  //get a random tokenId

  function getRandomTokenId(uint256 _claimedNumTokens) private returns(uint256){
      uint256 num = random(string(
                abi.encode(
                    msg.sender,
                    tx.gasprice,
                    block.number,
                    block.timestamp,
                    block.difficulty,
                    blockhash(block.number - 1),
                    address(this),
                    _claimedNumTokens
                )
            )) % 10000;

      if(isIdClaimed[num]) {
         getRandomTokenId(totalSupply());
      } else {
          return num;
      }
     
  }

   // generate and create a HEX color using the random numbers
   function pickColor(uint256 _tokenId) internal pure returns(string memory){
      string memory codeRed =   Strings.toString(random(string(abi.encodePacked(_tokenId, "red"))) % 256);
      string memory codeGreen = Strings.toString(random(string(abi.encodePacked(_tokenId, "green"))) % 256);
      string memory  codeBlue =  Strings.toString(random(string(abi.encodePacked(_tokenId, "blue"))) % 256);
      return string(abi.encodePacked(codeRed,",",codeGreen,",",codeBlue));
   }

   function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        return _buildTokenURI(_tokenId);
    }

    //constructs the final tokenURI based on the tokenId
    function _buildTokenURI(uint256 _tokenId) internal view returns (string memory){
         
         string memory partTwo = pickColor(_tokenId);
         
         string memory finalSvg = string(abi.encodePacked(partOne, partTwo, partThree));

         string memory json = Base64.encode(
             bytes(
              string(
                 abi.encodePacked(
                    '{"Id": "',
                      Strings.toString(_tokenId),
                     '", "description": "Another random 1/10000 pixel in the nifty-pixels", "image": "data:image/svg+xml;base64,',
                     Base64.encode(bytes(finalSvg)),
                     '", "Color": "',
                       partTwo,
                     '"}'
                     )
                    )
                  )
         );

        string memory finalTokenURI = string(abi.encodePacked("data:application/json;base64,", json));

        return finalTokenURI;

    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

   //withdraw Ether from the contract
   function withdraw() public onlyOwner{
     address _owner = owner();
     uint256 balance = address(this).balance;
     (bool sent, ) = _owner.call{value: balance}("");
     require(sent, "Failed to withdraw Ether");
   }

   receive() external payable {}
   fallback() external payable {}
}