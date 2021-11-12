// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract MetaMarket {
  address public owner;
  uint public itemSku;
  enum State { ForSale, Sold, Cancelled }
  mapping(uint => Item) public items;

  struct Item {
    string name;
    uint sku;
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
    //require (items[listingId].seller == msg.sender)
    _;
  }

  modifier paidEnough(uint listingId) {
    //require (msg.value >= items[listingId].price)
    _;
  }

  modifier returnExcess(uint listingId) {
    _;
    // uint _price = items[listingId].price;
    // uint amountToRefund = msg.value - _price;
    // items[listingId].buyer.transfer(amountToRefund);
  }

  constructor() {
    owner = msg.sender;
    itemSku = 0;
  }


  // Allow a seller to list an NFT for sale on the platform
  // 1. Ensures the NFT address is of a specific token type
  // 2. Persist: 
  // - seller address
  // - NFT item details: token address, name, any other required data
  // - sale price
  // 3. Emit an event
  // 4. Return the listingId;

  function listItem(address tokenAddress, string memory name, uint price) 
    public 
    validToken(tokenAddress) 
    ensureTokenOwnership(tokenAddress)
    returns(uint)
  {

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
}
