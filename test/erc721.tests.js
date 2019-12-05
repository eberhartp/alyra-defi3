const { BN, ether } = require("@openzeppelin/test-helpers");

const { expect } = require("chai");

const Poemes = artifacts.require("Poemes");

contract("Poemes", function(accounts){
    const _owner = accounts[0];
    const _recipient = accounts[1];
    const poemPrice = ether('0.1');

    beforeEach(async function() {
        this.PoemesInstance = await Poemes.new({from : _owner});
    });

    it("a zéro poèmes", async function() {
        expect(await this.PoemesInstance.totalSupply.call()).to.be.bignumber.equal(new BN('0'));
    });

    it("propriétaire de zéro poèmes", async function() {
        expect(await this.PoemesInstance.balanceOf.call(_owner)).to.be.bignumber.equal(new BN('0'));
    });

    it("génère un poème", async function() {
        let poemId = await this.PoemesInstance.generatePoem.call({from : _owner, value : poemPrice});
        // console.log(this.PoemesInstance.generatePoem);
        expect(poemId.toNumber()).to.be.below(0x3FFFFFFFFFF);
    });

    it("a la propriété d'un poème", async function() {
        let poemId = await this.PoemesInstance.generatePoem.call({from : _owner, value : poemPrice});
        console.log(poemId);
        // console.log(this.PoemesInstance);
        // console.log(poemId.toNumber());
        // console.log(0x3FFFFFFFFFF.toString());
        expect(await this.PoemesInstance.totalSupply()).to.be.bignumber.equal(new BN('1'));
        // let poems = await this.PoemesInstance.totalSupply();
        let poemOwner = await this.PoemesInstance.ownerOf(poemId);
        let poemCount = await this.PoemesInstance.balanceOf(_owner);
        // console.log(poems.toNumber());
        console.log(poemOwner);
        console.log(poemCount.toNumber());
        // expect().to.equal(_owner);
    });
})