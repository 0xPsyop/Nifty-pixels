//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

contract NiftyPixels is ERC721Enumerable, Ownable {
    
    // contract variables
    uint256 public tokenId;
    
    uint256 private immutable i_mintPrice  = 0;
    uint256 private immutable i_maxSupply = 10000;
    mapping (uint256 => bool) public isIdClaimed;
    mapping (uint256 => uint256) public idToColor;

    string partOne = '<svg width="100%" height="100%" xmlns="http://www.w3.org/2000/svg"> <rect width="100%" height="100%" fill="rgb(' ;
    string partThree =  ')"/></svg>';

    //chainlink variables
    /*VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint64 private immutable i_subscriptionId;
    bytes32 private immutable i_gasLane;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUM_WORDS = 1;
    */

    //events 
    event requestedRandomNums(uint256 requestId);
  
   constructor(
       /* address vrfCoordinatorV2,
        uint64 subscriptionId,
        bytes32 gasLane, // keyHash
        uint32 callbackGasLimit*/
        //_mintuint256 mintPrice
        )  
        ERC721("Nifty Pixels", "NP") payable
        //VRFConsumerBaseV2(vrfCoordinatorV2)
        {
           
           /* i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
            i_gasLane = gasLane;
            i_subscriptionId = subscriptionId;
            i_callbackGasLimit = callbackGasLimit;*/
           // i_mintPrice = mintPrice;

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
      /* needs to add the functionality smh call the VRF contract and get the random numbers to use as token id 
       also figure out a way to call it mulitiple ways if the generated token id is already existing
       figure out that is the minting process is breaking down if call the randomness
      */
      _safeMint(msg.sender, tokenId);
      isIdClaimed[tokenId] = true;
  
   }

   //@notice this is the func apparently we should call to start the whole process of getting a random number : needs to figure it out 

  /* function requestRandomNumbers() external {
     
     uint256 requestId = i_vrfCoordinator.requestRandomWords(
          i_gasLane,
          i_subscriptionId,
          REQUEST_CONFIRMATIONS,
          i_callbackGasLimit,
          NUM_WORDS
     );

     emit requestedRandomNums(requestId);
   }*/
    
   // this is the function that the VRF consumerbase contract will call after getting the random numbers
 /*   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override{
       tokenId = randomWords[0] % 10000;
        
    }*/


   // generate and create a HEX color using the random numbers
   

   function pickColor(uint256 _tokenId) internal pure returns(string memory){
      //find out if this is really returning a hex value given a random input
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