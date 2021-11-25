// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// contract MetaMarket is Ownable, IERC721Receiver {
contract MetaMarket is IERC721Receiver {
  address public owner;
  uint public totalListings;
  enum State { ForSale, Sold, Cancelled }
  mapping(uint => Listing) public listings;

  struct Listing {
    uint listingId;
    address tokenContractAddress;
    uint price;
    State state;
    address payable seller;
    address payable buyer;
  }

  
  /* 
   * Events
   */

  event LogNewListing(uint listingId);
  event LogUpdatedListing(uint listingId);
  event LogRemovedListing(uint listingId);
  event LogSoldListing(uint listingId);

  /* 
   * Modifiers
   */

  modifier validToken(address tokenAddress) {
    //require(token at tokenAddress.included in acceptable token types) 
    _;
  }

  modifier ensureTokenOwnership(address tokenAddress) {
    //require( token actually belongs to seller)
    _;
  }

  modifier ensureSeller(uint listingId) {
    //require (listings[listingId].seller == msg.sender)
    _;
  }

  modifier paidEnough(uint listingId) {
    //require (msg.value >= listings[listingId].price)
    _;
  }

  modifier returnExcess(uint listingId) {
    _;
    // uint _price = listings[listingId].price;
    // uint amountToRefund = msg.value - _price;
    // listings[listingId].buyer.transfer(amountToRefund);
  }

  constructor() {
    owner = msg.sender;
    totalListings = 0;
  }

  // Allow a seller to list an NFT for sale on the platform
  function createListing(address tokenAddress, uint tokenId, uint price) 
    public 
    validToken(tokenAddress) 
    ensureTokenOwnership(tokenAddress)
    returns(uint)
  {
    totalListings += 1; //Newly updated total count acts as unique ID for new listing
    listings[totalListings] = Listing({
      listingId: totalListings,
      tokenContractAddress: tokenAddress,
      price: price,
      state: State.ForSale,
      seller: payable(msg.sender),
      buyer: payable(address(0))
    });

    //Transfer the NFT to the MetaMarket contract address.
    ERC721(tokenAddress).safeTransferFrom(msg.sender, address(this), tokenId);

    emit LogNewListing(totalListings);
    return totalListings; 
  }

  // Allow a seller to remove the listing
  // 1. validate it is the seller attempting to remove the listing
  // 2. mark the item as 'cancelled'
  // 3. emit an event
  // 4. Return a bool for success/failure

  function removeListing(uint listingId) 
    public
    ensureSeller(listingId)
    returns(bool)
  {

  }

  // Allow a seller to update the listing price
  // 1. validate its the seller attempting to update the listing
  // 2. update the listing
  // 3. emit an event
  // 4. Return a bool for success/failure
  function updatePrice(uint listingId)
    public
    ensureSeller(listingId)
    returns(bool)
  {

  }


  // Allow a buyer to purchase the listing for the asking price
  // 1. validate the transaction has sufficient eth
  // 2. transfer eth to seller
  // 3. transfer nft to buyer
  // 4. mark listing as Sold
  // 5. return any excess funds to buyer
  // 5. return a bool for success/failure

  function purchaseListing(uint listingId) 
    public 
    payable
    paidEnough(listingId)
    returnExcess(listingId)
    returns(bool)
  {

  } 

  function onERC721Received(
    /* solhint-disable */
      address operator,
      address from,
      uint256 tokenId,
      bytes calldata data
    /* solhint-enable */
    ) external pure override returns (bytes4) {
      return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
  }
}
