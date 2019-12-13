[Poemes]: Poemes.md#Poemes
[Poemes-poemeVersProprietaire-mapping-uint256----address-]: Poemes.md#Poemes-poemeVersProprietaire-mapping-uint256----address-
[Poemes-proprietaireNombrePoemes-mapping-address----uint256-]: Poemes.md#Poemes-proprietaireNombrePoemes-mapping-address----uint256-
[Poemes-proprietairePoemesId-mapping-address----uint256---]: Poemes.md#Poemes-proprietairePoemesId-mapping-address----uint256---
[Poemes-transferApproval-mapping-address----mapping-address----bool--]: Poemes.md#Poemes-transferApproval-mapping-address----mapping-address----bool--
[Poemes-tokenApproval-mapping-uint256----address-]: Poemes.md#Poemes-tokenApproval-mapping-uint256----address-
[Poemes-totalSupply--]: Poemes.md#Poemes-totalSupply--
[Poemes-balanceOf-address-]: Poemes.md#Poemes-balanceOf-address-
[Poemes-ownerOf-uint256-]: Poemes.md#Poemes-ownerOf-uint256-
[Poemes-safeTransferFrom-address-address-uint256-]: Poemes.md#Poemes-safeTransferFrom-address-address-uint256-
[Poemes-approve-address-uint256-]: Poemes.md#Poemes-approve-address-uint256-
[Poemes-getApproved-uint256-]: Poemes.md#Poemes-getApproved-uint256-
[Poemes-setApprovalForAll-address-bool-]: Poemes.md#Poemes-setApprovalForAll-address-bool-
[Poemes-isApprovedForAll-address-address-]: Poemes.md#Poemes-isApprovedForAll-address-address-
[Poemes-random--]: Poemes.md#Poemes-random--
[Poemes-generatePoem--]: Poemes.md#Poemes-generatePoem--
[Poemes-poemExists-uint256-]: Poemes.md#Poemes-poemExists-uint256-
[Poemes-getVerse-uint256-uint256-]: Poemes.md#Poemes-getVerse-uint256-uint256-
[Poemes-Transfer-address-address-uint256-]: Poemes.md#Poemes-Transfer-address-address-uint256-
[Poemes-Approval-address-address-uint256-]: Poemes.md#Poemes-Approval-address-address-uint256-
[Poemes-ApprovalForAll-address-address-bool-]: Poemes.md#Poemes-ApprovalForAll-address-address-bool-
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





