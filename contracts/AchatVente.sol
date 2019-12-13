pragma solidity 0.5.12;

import "./Poemes.sol";

contract AchatVente {
    mapping(uint256=>bool) public isForSale;
    mapping(uint256=>uint256) public price;
    mapping(uint256=>address payable) public seller;

    Poemes private poemes;

    event Sold(address indexed from, address indexed to, uint256 indexed tokenId);

    constructor (Poemes _poemes) public {
        poemes = _poemes;
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice disponibilise un contrat à la vente
    /// @dev autorise un contrat à êter acheté
    /// @param _tokenId identifiant du poeme, _price prix en ether
    /// @return aucun
    function putOnSale(uint256 _tokenId, uint256 _price) external {
        require(poemes.ownerOf(_tokenId) == msg.sender, 'Not owner of token');
        require(isForSale[_tokenId] == false, 'Already for sale');
        isForSale[_tokenId] = true;
        price[_tokenId] = _price;
        seller[_tokenId] = msg.sender;
    }
    /// @author Pacôme Eberhart et Raphael Pinto
    /// @notice permet d'acheter un poeme
    /// @dev l'acheteur doit préalablement avoir été approve
    /// @param _tokenId identifiant du poeme
    /// @return un évenement Sold
    function buy(uint256 _tokenId) external payable {
        require(isForSale[_tokenId], 'Not for sale');
        require(msg.value >= price[_tokenId], 'Not enough funds');
        isForSale[_tokenId] = false;
        seller[_tokenId].transfer(msg.value);
        emit Sold(seller[_tokenId], msg.sender, _tokenId);
        poemes.safeTransferFrom(seller[_tokenId], msg.sender, _tokenId);
    }


    //vente aux enchères (NON IMPLEMENTES!)

    // mapping(uint256=>uint256) public bestOffer;
    // mapping(uint256=>address) public buyer;
    // mapping(uint256=>bool) public hasOffer;

    // bestOffer[_tokenId] = 0;
    // hasOffer[_tokenId] = false;

    // function makeOffer(uint256 _tokenId) external payable {
    //     require(isForSale[_tokenId], 'Not for sale');
    //     require(msg.value >= price[_tokenId] && msg.value > bestOffer[_tokenId], 'Offer not big enough');
    //     bestOffer[_tokenId] = msg.value;
    //     buyer[_tokenId] = msg.sender;
    //     hasOffer[_tokenId] = true;
    // }

    //Faire une fonction qui permet de récuperer son enchère si quelqu'un fait une meilleure offre...

    // function acceptOffer(uint256 _tokenId) external {
    //     require(poemes.ownerOf(_tokenId) == msg.sender, 'Not owner of token');
    //     require(isForSale[_tokenId], 'Not for sale');
    //     require(hasOffer[_tokenId] == true, 'No offer has been made');
    //     isForSale[_tokenId] = false;
    //     seller[_tokenId].transfer(bestOffer[_tokenId]);
    //     poemes.safeTransferFrom(seller[_tokenId], buyer[_tokenId], _tokenId);
    //     emit Sold(seller[_tokenId], buyer[_tokenId], _tokenId);
    // }
}