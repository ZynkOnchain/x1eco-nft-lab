// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IERC721 {

    function ownerOf(uint256 tokenId)
        external
        view
        returns (address);

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;
}

contract NFTMarketplaceV2 {

    struct Listing {

        address seller;

        uint256 price;
    }

    IERC721 public nft;

    mapping(uint256 => Listing) public listings;

    constructor(address nftAddress) {

        nft = IERC721(nftAddress);
    }

    function listNFT(
        uint256 tokenId,
        uint256 price
    ) external {

        require(
            nft.ownerOf(tokenId) == msg.sender,
            "Not NFT owner"
        );

        require(
            price > 0,
            "Price must be greater than 0"
        );

        listings[tokenId] = Listing(
            msg.sender,
            price
        );
    }

    function cancelListing(uint256 tokenId)
        external
    {

        require(
            listings[tokenId].seller == msg.sender,
            "Not seller"
        );

        delete listings[tokenId];
    }

    function buyNFT(uint256 tokenId)
        external
        payable
    {

        Listing memory item = listings[tokenId];

        require(
            item.price > 0,
            "NFT not listed"
        );

        require(
            msg.value >= item.price,
            "Insufficient payment"
        );

        (bool success, ) = payable(item.seller).call{
            value: msg.value
        }("");

        require(success, "Payment failed");

        nft.transferFrom(
            item.seller,
            msg.sender,
            tokenId
        );

        delete listings[tokenId];
    }

    function getListing(uint256 tokenId)
        external
        view
        returns (
            address seller,
            uint256 price
        )
    {

        Listing memory item = listings[tokenId];

        return (
            item.seller,
            item.price
        );
    }
}
