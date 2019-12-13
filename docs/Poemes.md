[Poemes]: #Poemes
[Poemes-poemeVersProprietaire-mapping-uint256----address-]: #Poemes-poemeVersProprietaire-mapping-uint256----address-
[Poemes-proprietaireNombrePoemes-mapping-address----uint256-]: #Poemes-proprietaireNombrePoemes-mapping-address----uint256-
[Poemes-proprietairePoemesId-mapping-address----uint256---]: #Poemes-proprietairePoemesId-mapping-address----uint256---
[Poemes-transferApproval-mapping-address----mapping-address----bool--]: #Poemes-transferApproval-mapping-address----mapping-address----bool--
[Poemes-tokenApproval-mapping-uint256----address-]: #Poemes-tokenApproval-mapping-uint256----address-
[Poemes-totalSupply--]: #Poemes-totalSupply--
[Poemes-balanceOf-address-]: #Poemes-balanceOf-address-
[Poemes-ownerOf-uint256-]: #Poemes-ownerOf-uint256-
[Poemes-safeTransferFrom-address-address-uint256-]: #Poemes-safeTransferFrom-address-address-uint256-
[Poemes-approve-address-uint256-]: #Poemes-approve-address-uint256-
[Poemes-getApproved-uint256-]: #Poemes-getApproved-uint256-
[Poemes-setApprovalForAll-address-bool-]: #Poemes-setApprovalForAll-address-bool-
[Poemes-isApprovedForAll-address-address-]: #Poemes-isApprovedForAll-address-address-
[Poemes-random--]: #Poemes-random--
[Poemes-generatePoem--]: #Poemes-generatePoem--
[Poemes-poemExists-uint256-]: #Poemes-poemExists-uint256-
[Poemes-getVerse-uint256-uint256-]: #Poemes-getVerse-uint256-uint256-
[Poemes-Transfer-address-address-uint256-]: #Poemes-Transfer-address-address-uint256-
[Poemes-Approval-address-address-uint256-]: #Poemes-Approval-address-address-uint256-
[Poemes-ApprovalForAll-address-address-bool-]: #Poemes-ApprovalForAll-address-address-bool-
## <span id="Poemes"></span> `Poemes`

Contrat de base du jeu


Contrat basé sur l'ERC721 avec trois fonctions en plus pour les poemes

- [`totalSupply()`][Poemes-totalSupply--]
- [`balanceOf(address _proprietaire)`][Poemes-balanceOf-address-]
- [`ownerOf(uint256 _indicePoeme)`][Poemes-ownerOf-uint256-]
- [`safeTransferFrom(address _from, address _to, uint256 _tokenId)`][Poemes-safeTransferFrom-address-address-uint256-]
- [`approve(address _to, uint256 _tokenId)`][Poemes-approve-address-uint256-]
- [`getApproved(uint256 _tokenId)`][Poemes-getApproved-uint256-]
- [`setApprovalForAll(address operator, bool approved)`][Poemes-setApprovalForAll-address-bool-]
- [`isApprovedForAll(address owner, address operator)`][Poemes-isApprovedForAll-address-address-]
- [`random()`][Poemes-random--]
- [`generatePoem()`][Poemes-generatePoem--]
- [`poemExists(uint256 poemId)`][Poemes-poemExists-uint256-]
- [`getVerse(uint256 poemId, uint256 verseNumber)`][Poemes-getVerse-uint256-uint256-]
- [`Transfer(address from, address to, uint256 tokenId)`][Poemes-Transfer-address-address-uint256-]
- [`Approval(address owner, address approved, uint256 tokenId)`][Poemes-Approval-address-address-uint256-]
- [`ApprovalForAll(address owner, address operator, bool approved)`][Poemes-ApprovalForAll-address-address-bool-]

### <span id="Poemes-totalSupply--"></span> `totalSupply() → uint256` (external)

renvoi le nombre total de poemes


comme le ERC721


### <span id="Poemes-balanceOf-address-"></span> `balanceOf(address _proprietaire) → uint256` (external)

renvoi le nombre de poemes possédés par un joueur


comme le ERC721


### <span id="Poemes-ownerOf-uint256-"></span> `ownerOf(uint256 _indicePoeme) → address` (external)

indique qui est le propriétaire d'un poeme


comme le ERC721


### <span id="Poemes-safeTransferFrom-address-address-uint256-"></span> `safeTransferFrom(address _from, address _to, uint256 _tokenId)` (external)

transfert la propriété d'un poeme d'un jouer à un autre


comme le ERC721


### <span id="Poemes-approve-address-uint256-"></span> `approve(address _to, uint256 _tokenId)` (external)

autorise une adresse à éffectuer un transfert de propriété d'un poeme


comme le ERC721


### <span id="Poemes-getApproved-uint256-"></span> `getApproved(uint256 _tokenId) → address` (external)

renvoi l'adresse autorisée à éffectuer un transfert de propriété d'un poeme


comme le ERC721


### <span id="Poemes-setApprovalForAll-address-bool-"></span> `setApprovalForAll(address operator, bool approved)` (external)

définit l'autorisation d'une adresse à transférer la propriété de tous les poèmes d'un joueur


comme le ERC721


### <span id="Poemes-isApprovedForAll-address-address-"></span> `isApprovedForAll(address owner, address operator) → bool` (external)

indique si une adresse est autorisée à transférer la propriété de tous les poemes d'un joueur


comme le ERC721


### <span id="Poemes-random--"></span> `random() → uint256` (internal)

renvoi un nombre aléatoire


méthode simpliste


### <span id="Poemes-generatePoem--"></span> `generatePoem() → uint256` (external)

créer un nouveau poeme


génere un nouvel identifiant de poeme et vérifie qu'il n'existe pas déjà


### <span id="Poemes-poemExists-uint256-"></span> `poemExists(uint256 poemId) → bool` (external)

indique si un poeme existe déjà


renvoi la valeur contenu dans le mapping poemeExiste


### <span id="Poemes-getVerse-uint256-uint256-"></span> `getVerse(uint256 poemId, uint256 verseNumber) → string` (external)

affiche dans la console les vers du poeme spécifié


pour les tests


### <span id="Poemes-Transfer-address-address-uint256-"></span> `Transfer(address from, address to, uint256 tokenId)`





### <span id="Poemes-Approval-address-address-uint256-"></span> `Approval(address owner, address approved, uint256 tokenId)`





### <span id="Poemes-ApprovalForAll-address-address-bool-"></span> `ApprovalForAll(address owner, address operator, bool approved)`





