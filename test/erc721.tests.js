const { BN, ether } = require("@openzeppelin/test-helpers");
const { expect } = require("chai");
const Poemes = artifacts.require("Poemes");
const AchatVente = artifacts.require("AchatVente");

contract("Poemes", function(accounts){
    const owner = accounts[0];
    const recipient = accounts[1];
    const sender = accounts[2];
    const poemPrice = ether("0.1");

    //Avant chaque test unitaire  
    beforeEach(async function() {
        this.PoemesInstance = await Poemes.new();
    });

    //Test 1
    it("a zéro poèmes", async function() {
        expect(await this.PoemesInstance.totalSupply.call()).to.be.bignumber.equal(new BN('0'));
    });

    //Test 2
    it("propriétaire de zéro poèmes", async function() {
        expect(await this.PoemesInstance.balanceOf.call(owner)).to.be.bignumber.equal(new BN('0'));
    });

    //Test 3
    it("génère un poème", async function() {
        let poemId = await this.PoemesInstance.generatePoem.call({from : owner, value : poemPrice});
        expect(poemId.toNumber()).to.be.below(0x3FFFFFFFFFF);
    });

    //Test 4 totalSupply
    it('vérifie totalSupply est à 0 au deploiement', async function () {
        let totalSupply = await this.PoemesInstance.totalSupply();
        expect(totalSupply).to.be.bignumber.equal(new BN("0"));
    });

    //Test 5 balanceOf
    it('vérifie balanceOf est à 0 au deploiement', async function () {
        let balanceOf = await this.PoemesInstance.balanceOf(owner);
        expect(balanceOf).to.be.bignumber.equal(new BN("0"));
    });

    //Test 6 nombreTotalPoemes and proprietaireNombrePoemes in generatePoem()
    it('vérifie nombreTotalPoemes et proprietaireNombrePoemes dans generatePoem()', async function () {
        let nombreTotalPoemesStart = await this.PoemesInstance.totalSupply();

        //Generation poeme par receipient
        await this.PoemesInstance.generatePoem({from: recipient, value: ether("0.1")});

        let nombreTotalPoemesEnd = await this.PoemesInstance.totalSupply();
        expect(nombreTotalPoemesEnd).to.be.bignumber.equal(nombreTotalPoemesStart.add(new BN("1")));

        let proprietaireNombrePoemesEnd = await this.PoemesInstance.balanceOf(recipient);
        expect(proprietaireNombrePoemesEnd).to.be.bignumber.equal(new BN("1"));
    });

    //<<<<<<<<test 7 NE PASSE PAS>>>>>>>> la generation de l'ID du poeme est testée dans le test 8

    //Test 7 poemId and PoemExists in generatePoem() 
    // it('vérifie poemId et PoemExists dans generatePoem()', async function () {
    //     let poemIdBN = await this.PoemesInstance.generatePoem.call({from: recipient, value: ether("0.1")});
    //     console.log(poemIdBN);

    //     let poemExiste = await this.PoemesInstance.poemExists(poemIdBN);
    //     expect(poemExiste).to.equal(true);
    // });

    //Test 8 poemExists() and ownerOf()
    it('vérifie poemExists() et ownerOf()', async function () {
        //Generation poeme par recipient
        await this.PoemesInstance.generatePoem({from: recipient, value: ether("0.1")});

        //Recuperation ID du poeme par mapping proprietairePoemesId
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(recipient, 0);

        //Lancement fonction ownerOf()
        let ownerOf = await this.PoemesInstance.ownerOf(poemIdTest);

        //Lancement fonction poemExists()
        let poemExiste = await this.PoemesInstance.poemExists(poemIdTest);

        //Tests
        expect(poemExiste).to.equal(true);
        expect(ownerOf).to.equal(recipient);
    });

    //Test 9 approve() and getApproved()
    it('vérifie approve() et getApproved()', async function () {
        //Generation poeme par owner
        await this.PoemesInstance.generatePoem({from: owner, value: ether("0.1")});

        //Recuperation ID du poeme
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(owner, 0);

        //Lancement fonction approve owner/recipient
        await this.PoemesInstance.approve(recipient, poemIdTest, {from: owner});

        //Verification mapping tokenApproval à true
        let addressApproved = await this.PoemesInstance.tokenApproval.call(poemIdTest); 
        expect(addressApproved).to.equal(recipient);

        //Verification fonction getApproved renvoie le recipient
        let addressApproved2 = await this.PoemesInstance.getApproved.call(poemIdTest);
        expect(addressApproved2).to.equal(recipient);
    });

    //Test 10 setApprovalForAll() and isApprovedForAll()
    it('vérifie setApprovalForAll() et isApprovedForAll()', async function () {
        //Lancement fonction setApprovalForAll
        await this.PoemesInstance.setApprovalForAll(recipient, true, {from: owner});

        //Verification mapping transferApproval owner/recipient a true
        let approvalState = await this.PoemesInstance.transferApproval.call(owner, recipient);
        expect(approvalState).to.equal(true);

        //Verification mapping transferApproval owner/sender a false
        let approvalState2 = await this.PoemesInstance.transferApproval.call(owner, sender);
        expect(approvalState2).to.equal(false);

        //Verification fonction isApprovedForAll renvoie true pour owner/recipient
        let isApproved = await this.PoemesInstance.isApprovedForAll.call(owner, recipient);
        expect(isApproved).to.equal(true);
    });

    //Test 11 safeTransferFrom()
    it('vérifie safeTransferFrom()', async function () {
        //Generation poeme par sender
        await this.PoemesInstance.generatePoem({from: sender, value: ether("0.1")});
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(sender, 0);

        //Enregistrement nombrePoemes sender et recipient
        let nombrePoemesOwnerStart = await this.PoemesInstance.proprietaireNombrePoemes.call(sender);
        let nombrePoemesReceiverStart = await this.PoemesInstance.proprietaireNombrePoemes.call(recipient);

        //Lancement fonction safeTransferFrom sender vers recipient
        await this.PoemesInstance.safeTransferFrom(sender, recipient, poemIdTest, {from: sender});

        //Verification nouveau proprietaire est recipient
        let poemeVersProprietaire = await this.PoemesInstance.poemeVersProprietaire.call(poemIdTest);
        expect(poemeVersProprietaire).to.equal(recipient);

        //Enregistrement nouvelles valeur nombrePoemes sender et recipient
        let nombrePoemesOwnerEnd = await this.PoemesInstance.proprietaireNombrePoemes.call(sender);
        let nombrePoemesReceiverEnd = await this.PoemesInstance.proprietaireNombrePoemes.call(recipient);

        //Comparaison anciennes et nouvelles valeurs nombrePoemes
        expect(nombrePoemesOwnerEnd).to.be.bignumber.equal(nombrePoemesOwnerStart.sub(new BN("1")));
        expect(nombrePoemesReceiverEnd).to.be.bignumber.equal(nombrePoemesReceiverStart.add(new BN("1")));

        //Verification recipient n'a plus l'approval
        expect(await this.PoemesInstance.tokenApproval.call(poemIdTest)).to.not.equal(recipient);
    });

    it("affiche le poème", async function() {
        //Generation poeme par owner
        await this.PoemesInstance.generatePoem({from: owner, value: ether("0.1")});

        //Recuperation ID du poeme
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(owner, 0);

        for (let i = 0; i < 14; i++) {
            console.log(await this.PoemesInstance.getVerse.call(poemIdTest, i));
        }
    });
})

contract("AchatVente", function(accounts){
    const owner = accounts[0];
    const buyer = accounts[1];
    const poemPrice = ether("0.1");

    //Avant chaque test unitaire  
    beforeEach(async function() {
        this.PoemesInstance = await Poemes.new();
        this.AchatVenteInstance = await AchatVente.new(this.PoemesInstance.address);
    });

    //Test 12
    it("test fonction putOnSale", async function() {
        //Generation poeme par recipient
        await this.PoemesInstance.generatePoem({from: owner, value: poemPrice});

        //Recuperation ID du poeme par mapping proprietairePoemesId
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(owner, 0);

        //Enregistrement états mapping avant lancement fonction putOnSale
        let isForSaleBefore = await this.AchatVenteInstance.isForSale.call(poemIdTest);
        let priceBefore = await this.AchatVenteInstance.price.call(poemIdTest);

        //Execution fonction putOnSale
        await this.AchatVenteInstance.putOnSale(poemIdTest, poemPrice, {from: owner});
        
        //Enregistrement états mapping après lancement fonction putOnSale
        let isForSaleAfter = await this.AchatVenteInstance.isForSale.call(poemIdTest);
        let priceAfter = await this.AchatVenteInstance.price.call(poemIdTest);
        let sellerAfter = await this.AchatVenteInstance.seller.call(poemIdTest);

        //Tests
        expect(isForSaleBefore).to.equal(false);
        expect(isForSaleAfter).to.equal(true);
        expect(priceAfter).to.be.bignumber.equal(priceBefore.add(poemPrice));
        expect(sellerAfter).to.equal(owner);
    });

    //Test 13
    it("test fonction buy", async function() {        
        //Generation poeme par recipient
        await this.PoemesInstance.generatePoem({from: owner, value: ether("0.1")});

        //Recuperation ID du poeme par mapping proprietairePoemesId
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(owner, 0);

        //Execution fonction putOnSale
        await this.AchatVenteInstance.putOnSale(poemIdTest, poemPrice, {from: owner});

        //Lancement fonction approve owner/AchatVente
        await this.PoemesInstance.approve(this.AchatVenteInstance.address, poemIdTest, {from: owner});

        //Enregistrement états mapping avant lancement fonction buy
        let ownerBalanceBefore = await this.PoemesInstance.balanceOf.call(owner);
        let isForSaleBefore = await this.AchatVenteInstance.isForSale.call(poemIdTest);

        //Execution fonction buy
        await this.AchatVenteInstance.buy(poemIdTest, {from: buyer, value: poemPrice});
        
        //Enregistrement états mapping après lancement fonction buy
        let ownerBalanceAfter = await this.PoemesInstance.balanceOf.call(owner);
        let isForSaleAfter = await this.AchatVenteInstance.isForSale.call(poemIdTest);

        //Tests
        expect(isForSaleBefore).to.equal(true);
        expect(isForSaleAfter).to.equal(false);
        expect(ownerBalanceAfter).to.be.bignumber.equal(ownerBalanceBefore.sub(new BN("1")));
    });

    /*
    //Test 14
    it("test fonction makeOffer", async function() {        
        //Generation poeme par recipient
        await this.PoemesInstance.generatePoem({from: owner, value: ether("0.1")});

        //Recuperation ID du poeme par mapping proprietairePoemesId
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(owner, 0);

        //Execution fonction putOnSale
        await this.AchatVenteInstance.putOnSale(poemIdTest, poemPrice, {from: owner});

        //Enregistrement états mapping avant lancement fonction makeOffer
        let bestOfferBefore = await this.AchatVenteInstance.bestOffer.call(poemIdTest);
        let hasOfferBefore = await this.AchatVenteInstance.hasOffer.call(poemIdTest);

        //Execution fonction makeOffer(uint256 _tokenId) external payable
        await this.AchatVenteInstance.makeOffer(poemIdTest, {from: buyer, value: poemPrice});
        
        //Enregistrement états mapping après lancement fonction makeOffer
        let bestOfferAfter = await this.AchatVenteInstance.bestOffer.call(poemIdTest);
        let hasOfferAfter = await this.AchatVenteInstance.hasOffer.call(poemIdTest);
        let buyerAfter = await this.AchatVenteInstance.buyer.call(poemIdTest);

        //Tests
        expect(bestOfferAfter).to.be.bignumber.equal(bestOfferBefore.add(poemPrice));
        expect(hasOfferBefore).to.equal(false);
        expect(hasOfferAfter).to.equal(true);
        expect(buyerAfter).to.equal(buyer);
    });

    //Test 15
    it("test fonction acceptOffer", async function() {       
        //Generation poeme par recipient
        await this.PoemesInstance.generatePoem({from: owner, value: ether("0.1")});

        //Recuperation ID du poeme par mapping proprietairePoemesId
        let poemIdTest = await this.PoemesInstance.proprietairePoemesId.call(owner, 0);

        //Execution fonction putOnSale
        await this.AchatVenteInstance.putOnSale(poemIdTest, poemPrice, {from: owner});

        //Execution fonction makeOffer
        await this.AchatVenteInstance.makeOffer(poemIdTest, {from: buyer, value: poemPrice});

        //Lancement fonction approve owner/buyer
        await this.PoemesInstance.approve(buyer, poemIdTest, {from: owner});

        //Enregistrement états mapping avant execution fonction acceptOffer(uint256 _tokenId) external payable
        let ownerBalanceBefore = await this.PoemesInstance.balanceOf.call(owner);
        let isForSaleBefore = await this.AchatVenteInstance.isForSale.call(poemIdTest);
        let ownerOfBefore = await this.PoemesInstance.ownerOf(poemIdTest);

        //Execution fonction acceptOffer(uint256 _tokenId) external
        await this.AchatVenteInstance.acceptOffer(poemIdTest, {from: owner});
        
        //Enregistrement états mapping après execution fonction sell
        let ownerBalanceAfter = await this.PoemesInstance.balanceOf.call(owner);
        let isForSaleAfter = await this.AchatVenteInstance.isForSale.call(poemIdTest);
        let ownerOfAfter = await this.PoemesInstance.ownerOf(poemIdTest);

        //Tests
        expect(isForSaleBefore).to.equal(true);
        expect(isForSaleAfter).to.equal(false);
        expect(ownerBalanceAfter).to.be.bignumber.equal(ownerBalanceBefore.sub(new BN("1")));
        expect(ownerOfBefore).to.equal(owner);
        expect(ownerOfAfter).to.equal(buyer);
    });
    */
})