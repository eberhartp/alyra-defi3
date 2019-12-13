[AchatVente]: #AchatVente
[AchatVente-isForSale-mapping-uint256----bool-]: #AchatVente-isForSale-mapping-uint256----bool-
[AchatVente-price-mapping-uint256----uint256-]: #AchatVente-price-mapping-uint256----uint256-
[AchatVente-seller-mapping-uint256----address-payable-]: #AchatVente-seller-mapping-uint256----address-payable-
[AchatVente-constructor-contract-Poemes-]: #AchatVente-constructor-contract-Poemes-
[AchatVente-putOnSale-uint256-uint256-]: #AchatVente-putOnSale-uint256-uint256-
[AchatVente-buy-uint256-]: #AchatVente-buy-uint256-
[AchatVente-Sold-address-address-uint256-]: #AchatVente-Sold-address-address-uint256-
## <span id="AchatVente"></span> `AchatVente`





- [`constructor(contract Poemes _poemes)`][AchatVente-constructor-contract-Poemes-]
- [`putOnSale(uint256 _tokenId, uint256 _price)`][AchatVente-putOnSale-uint256-uint256-]
- [`buy(uint256 _tokenId)`][AchatVente-buy-uint256-]
- [`Sold(address from, address to, uint256 tokenId)`][AchatVente-Sold-address-address-uint256-]

### <span id="AchatVente-constructor-contract-Poemes-"></span> `constructor(contract Poemes _poemes)` (public)





### <span id="AchatVente-putOnSale-uint256-uint256-"></span> `putOnSale(uint256 _tokenId, uint256 _price)` (external)

disponibilise un contrat à la vente


autorise un contrat à êter acheté


### <span id="AchatVente-buy-uint256-"></span> `buy(uint256 _tokenId)` (external)

permet d'acheter un poeme


l'acheteur doit préalablement avoir été approve


### <span id="AchatVente-Sold-address-address-uint256-"></span> `Sold(address from, address to, uint256 tokenId)`





