//pragma solidity >=0.4.24;
//pragma solidity >=0.8.0;
pragma solidity ^0.8.0;

import '../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol';//importing the rule under solidity version 0.8.0

contract StarNotary is ERC721 {
    address public accounts;

    // Star data
    struct Star {
        string name;
    }
    constructor() ERC721("StarNotary","star1"){}

    // Implement Task 1 Add a name and symbol properties
    // name: Is a short name to your token
    // symbol: Is a short string like 'USD' -> 'American Dollar'
        struct StarNameSym {
        string name;
        string symbol;
        
    }
    //StarNameSym starnamearraymain; 
    

    // mapping the Star with the Owner Address
    mapping(uint256 => Star) public tokenIdToStarInfo;
    // mapping the TokenId and price
    mapping(uint256 => uint256) public starsForSale;
    //mapping TokenId to Starname
    mapping(uint256 => StarNameSym) public lookUptokenIdToStarInfoResult;

    
    // Create Star using the Struct
    function createStar(string memory _name, uint256 _tokenId) public { // Passing the name and tokenId as a parameters
        Star memory newStar = Star(_name); // Star is an struct so we are creating a new Star
        tokenIdToStarInfo[_tokenId] = newStar; // Creating in memory the Star -> tokenId mapping
        _mint(msg.sender, _tokenId); // _mint assign the the star with _tokenId to the sender address (ownership)
    }

    // Create a Star using Struct with  Name and Symbol
        function createStar1(string memory _name, string memory _symbol,uint256 _tokenId) public { // Passing the name and tokenId as a parameters
        StarNameSym memory starnamearray = StarNameSym(_name,_symbol); // Star is an struct so we are creating a new Star
        lookUptokenIdToStarInfoResult[_tokenId] = starnamearray; // Creating in memory the Star -> tokenId mapping
        _mint(msg.sender, _tokenId); // _mint assign the the star with _tokenId to the sender address (ownership)
    }

  
    // Putting an Star for sale (Adding the star tokenid into the mapping starsForSale, first verify that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sale the Star you don't owned");
        starsForSale[_tokenId] = _price;
    }


    // Function that allows you to convert an address into a payable address
    function _make_payable(address x) internal pure returns (address payable) {
        return payable(address(uint160(x)));
    }

    function buyStar(uint256 _tokenId) public  payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value > starCost, "You need to have enough Ether");
        transferFrom(ownerAddress, msg.sender, _tokenId); // We can't use _addTokenTo or_removeTokenFrom functions, now we have to use _transferFrom
        address payable ownerAddressPayable = _make_payable(ownerAddress); // We need to make this conversion to be able to use transfer() function to transfer ethers
        ownerAddressPayable.transfer(starCost);
        if(msg.value > starCost) {
            payable(msg.sender).transfer(msg.value - starCost);
        }
    }

        // Implement Task 1 lookUptokenIdToStarInfo
        //1. You should return the Star saved in tokenIdToStarInfo mapping
        function lookUptokenIdToStarInfo(uint256 _tokenId) public view returns (Star memory) {
            Star memory starname = tokenIdToStarInfo[_tokenId];
            //console.log(starname);
            return starname;

    }
  


        // Implement Task 1 Exchange Stars function
        //1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
        //2. You don't have to check for the price of the token (star)
        //3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId1)
        //4. Use _transferFrom function to exchange the tokens.
        function exchangeStars(uint256 _tokenId1, uint256 _tokenId2,address _user2) public returns(address){
            
            address accountAdd1 = ownerOf(_tokenId1); //getting ownership of _tokenId1
            address accountAdd2 = ownerOf(_tokenId2);//getting ownership of _tokenId2
            address seconduser = _user2;
           
          
          if(accountAdd1 == msg.sender){
            transferFrom(accountAdd1, seconduser, _tokenId1);
            return (ownerOf(_tokenId1));
            }else if(accountAdd2 == msg.sender){
                transferFrom(accountAdd2, accountAdd1, _tokenId2);
                return (ownerOf(_tokenId2));
            }
            
        } 
         

    // Implement Task to Transfer Stars
    //1. Check if the sender is the ownerOf(_tokenId)
    //2. Use the transferFrom(from, to, tokenId); function to transfer the Star
    function transferStar(address _to1, uint256 _tokenId) public returns(address) {

        address account1Add1 = ownerOf(_tokenId);
        address account2Add2 = _to1;
        if(account1Add1 == msg.sender){
           transferFrom(account1Add1, account2Add2, _tokenId);
           return (ownerOf(_tokenId));
        }
    }
}

