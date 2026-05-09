// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract X1BuilderNFTV2 is ERC721, Ownable {

    uint256 public nextTokenId;

    string private baseTokenURI;

    constructor(
        string memory baseURI_
    )
        ERC721("X1 Builder NFT", "X1BNFT")
        Ownable(msg.sender)
    {
        baseTokenURI = baseURI_;
    }

    function mint() external {

        uint256 tokenId = nextTokenId;

        _safeMint(msg.sender, tokenId);

        nextTokenId++;
    }

    function ownerMint(address to) external onlyOwner {

        require(to != address(0), "Cannot mint to zero address");

        uint256 tokenId = nextTokenId;

        _safeMint(to, tokenId);

        nextTokenId++;
    }

    function setBaseURI(string memory newBaseURI)
        external
        onlyOwner
    {
        baseTokenURI = newBaseURI;
    }

    function _baseURI()
        internal
        view
        override
        returns (string memory)
    {
        return baseTokenURI;
    }

    function totalSupply() external view returns(uint256) {

        return nextTokenId;
    }
}
