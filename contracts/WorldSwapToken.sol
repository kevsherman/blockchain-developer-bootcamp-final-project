// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title A smart contract to generate ERC721 tokens for testing the MetaMarket platform
/// @author @kevsherman
/// @notice Still a WIP, demo purposes only
contract WorldSwapToken is ERC721URIStorage, ERC721Enumerable{
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /// @notice Initializes the contract by calling ERC721 with the WorldSwapToken name and symbol.
    constructor() ERC721("WorldSwapToken", "SWAP") {}

    /// @notice Awards a WRLD token to the provided address
    /// @dev Storage functionality included so a link to a json metadata blob can be used later
    function awardToken(address user, string memory tokenURI)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newTokenId = _tokenIds.current();
        _mint(user, newTokenId);
        _setTokenURI(newTokenId, tokenURI); //Could use a local rails address here for URI?

        return newTokenId;
    }

    /// @notice Override functions to allow both enumerable and uriStorage:  
    /// @dev https://ethereum.stackexchange.com/questions/103674/openzeppelin-erc721-uristorage-implementation-missing-enumerable-functions

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    /// End enumerable and uriStorage override functions
}