/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/// @title A smart contract to enable buying and selling of ERC721 tokens
/// @author @kevsherman
/// @notice Still a WIP, demo purposes only
contract MetaMarket is IERC721Receiver {
  
  /// Owner set when contract deployed
  address public owner;
  
  /// Count of the total listings created
  uint public totalListings;

  /// The state of the Listing
  enum State { ForSale, Sold, Cancelled }

  /// Mapping from listingId to Listing
  mapping(uint => Listing) public listings;

  /// Struct of the Listing object, to store who is selling/buying what 
  struct Listing {
    uint listingId;
    address tokenContractAddress;
    uint tokenContractId;
    uint price;
    State state;
    address payable seller;
    address payable buyer;
  }

  /* 
   * Events
   */

  /// @notice Event to be emitted when a new Listing has been created
  /// @return the listing id for the created Listing
  event LogNewListing(uint listingId);

  /// @notice Event to be emitted when a Listing has been updated
  /// @return the listing id for the updated Listing
  event LogUpdatedListing(uint listingId);

  /// @notice Event to be emitted when a Listing has been removed
  /// @return the listing id for the removed Listing
  event LogRemovedListing(uint listingId);

  /// @notice Event emitted when a Listing has been updated
  /// @return the listing id for the updated Listing
  event LogSoldListing(uint listingId);

  /* 
   * Modifiers
   */

  /// @notice Modifer to ensure that only the contract owner can execute a function
  modifier onlyOwner() {
    require(msg.sender == owner, "Not authorized.");
      _;
  }

  /// @notice Modifier to ensure that the msg.sender is the seller 
  modifier ensureSeller(uint listingId) {
    require (listings[listingId].seller == msg.sender);
    _;
  }

  /// @notice Modifier to ensure that the buyer has supplied enough ETH for the transaction
  /// @dev Purchasing functionality not yet built
  modifier paidEnough(uint listingId) {
    //require (msg.value >= listings[listingId].price)
    _;
  }

  /// @notice Modifier to be called after a purchase transaction to return excess funds
  /// @dev Purchasing functionality not yet built
  modifier returnExcess(uint listingId) {
    _;
    // uint _price = listings[listingId].price;
    // uint amountToRefund = msg.value - _price;
    // listings[listingId].buyer.transfer(amountToRefund);
  }

  /// @notice Initializes the contract by setting the owner and the totalListings variable.
  constructor() {
    owner = msg.sender;
    totalListings = 0;
  }

  /// @notice Allow a seller to list an NFT for sale, transfer the token to the MetaMarket address
  /// @dev The safeTransferFrom() handles ensuring ownership and approvals, so they aren't included as modifiers.
  function createListing(address tokenAddress, uint tokenId, uint price) 
    public 
    returns(uint)
  {
    require(price < type(uint256).max); //Protect against overflow attacks

    totalListings += 1; //Newly updated total count acts as unique ID for new listing
    listings[totalListings] = Listing({
      listingId: totalListings,
      tokenContractAddress: tokenAddress,
      tokenContractId: tokenId,
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

  /// @notice Allow a seller to remove the listing and get the token back from the MetaMarket address
  /// @dev To Do:
  ///      1. validate that msg.sender is the seller
  ///      2. mark the item as 'cancelled'
  ///      3. emit a LogRemovedListing event
  ///      4. Return a bool for success/failure
  function removeListing(uint listingId) 
    public
    ensureSeller(listingId)
    returns(bool)
  {

  }

  /// @notice Allow a seller to update the listing price
  /// @dev To Do:
  ///      1. validate it is the seller attempting to update the listing
  ///      2. validate that msg.sender is the seller
  ///      3. emit a LogUpdatedListing event
  ///      4. Return a bool for success/failure
  function updatePrice(uint listingId)
    public
    ensureSeller(listingId)
    returns(bool)
  {

  }


  /// @notice Allow a buyer to update the listing price
  /// @dev To Do: 
  ///        1. validate the transaction has sufficient eth
  ///        2. transfer eth to seller
  ///        3. transfer nft to buyer
  ///        4. mark listing as Sold
  ///        5. return any excess funds to buyer
  ///        6. return a bool for success/failure
  function purchaseListing(uint listingId) 
    public 
    payable
    paidEnough(listingId)
    returnExcess(listingId)
    returns(bool)
  {

  } 

  /// @notice Allow the contract owner to withdraw accrued fees
  /// @dev To Do: No fees currently collected to withdraw
  function withdrawFees(uint amount)
    public
    payable
    onlyOwner
    returns(bool)  
  {

  }

  /// @notice Override function to allow for recieving ERC721 tokens
  /// @dev Figure out how to remove warning re: unused variables
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
