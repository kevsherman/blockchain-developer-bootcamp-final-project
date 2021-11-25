let MetaMarket = artifacts.require("MetaMarket");
let NFT = artifacts.require("WorldSwapToken");
// let ERC721 = artifacts.require("../node_modules/@openzeppelin/contracts/token/ERC721/ERC721");
// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract("MetaMarket", function(accounts){

  const [owner, alice, bob] = accounts;
  let instance;
  let nftContract;
  beforeEach(async () => {
    instance = await MetaMarket.new();
    nftContract = await NFT.new();
  });

  describe("createListing", () => {
    it("should create a new Listing object and add it to the listings hash", async () => {
      var listingCreated = false;
      await nftContract.awardToken(alice, 1, {from: owner});
      //approve MetaMarket as a transfer agent for the NFT
      await nftContract.approve(instance.address, 1, {from: alice});
      await instance.createListing(nftContract.address, 1, 5, {from: alice});
      
      const result = await instance.totalListings.call()

      if(result == 1){
        listingCreated = true;
      } 

      assert.equal(
        listingCreated,
        true,
        "calling createListing() should add a Listing to the listings hash",
      );
    });

    it("should set the listing's seller to the NFT owner", async () => {
      var correctSeller = false;
      await nftContract.awardToken(alice, 1, {from: owner});
      //approve MetaMarket as a transfer agent for the NFT
      await nftContract.approve(instance.address, 1, {from: alice});
      await instance.createListing(nftContract.address, 1, 5, {from: alice});
      
      const result = await instance.listings.call(1)

      if(result.seller == alice){
        correctSeller = true;
      } 

      assert.equal(
        correctSeller,
        true,
        "calling createListing() should set the listing's seller to the NFT owner",
      );
    });

    it("should set the listing's price to what was supplied", async () => {
      var correctPrice = false;
      var price = 30;
      await nftContract.awardToken(alice, 1, {from: owner});
      //approve MetaMarket as a transfer agent for the NFT
      await nftContract.approve(instance.address, 1, {from: alice});
      await instance.createListing(nftContract.address, 1, price, {from: alice});
      
      const result = await instance.listings.call(1)

      if(result.price == price){
        correctPrice = true;
      } 

      assert.equal(
        correctPrice,
        true,
        "calling createListing() should set the listing's price to the price supplied",
      );
    });

    it("should transfer the NFT to the MetaMarket contract", async () => {
      var correctAddress = false;

      await nftContract.awardToken(alice, 1, {from: owner});
      //approve MetaMarket as a transfer agent for the NFT
      await nftContract.approve(instance.address, 1, {from: alice});

      await instance.createListing(nftContract.address, 1, 500, {from: alice, gas: 1000000});

      if(await nftContract.ownerOf(1) == instance.address){
        correctAddress = true;
      }

      assert.equal(
        correctAddress,
        true,
        "calling createListing() should transfer the NFT to the MetaMarket contract address"
      )
    });
  });
});