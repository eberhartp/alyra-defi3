pragma solidity 0.5.12;

import "./Poemes.sol";

contract AchatVente {
    mapping(uint256=>bool) public isForSale;
    mapping(uint256=>uint256) public price;
    mapping(uint256=>address payable) public seller;
    Poemes private poemes;

    constructor (Poemes _poemes) public {
        poemes = _poemes;
    }

    function putOnSale(uint256 _tokenId, uint256 _price) external {
        require(poemes.ownerOf(_tokenId) == msg.sender, 'Not owner of token');
        isForSale[_tokenId] = true;
        price[_tokenId] = _price;
        seller[_tokenId] = msg.sender;
    }

    function buy(uint256 _tokenId) external payable {
        require(isForSale[_tokenId], 'Not for sale');
        require(msg.value >= price[_tokenId], 'Not enough funds');
        poemes.safeTransferFrom(seller[_tokenId], msg.sender, _tokenId);
        seller[_tokenId].transfer(msg.value);
        isForSale[_tokenId] = false;
    }
}