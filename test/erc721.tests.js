const { BN, ether } = require("@openzeppelin/test-helpers");

const { expect } = require("chai");

const Poemes = artifacts.require("Poemes");

contract("Poemes", function(accounts){
    const _owner = accounts[0];
    const _recipient = accounts[1];

    beforeEach(async function() {
        this.PoemesInstance = await Poemes.new({from : _owner});
    });

    it("a zéro poèmes", async function() {
        expect(await this.PoemesInstance.totalSupply()).to.be.bignumber.equal(new BN('0'));
    });

    it("propriétaire de zéro poèmes", async function() {
        expect(await this.PoemesInstance.balanceOf(_owner)).to.be.bignumber.equal(new BN('0'));
    });

    it("génère un poème", async function() {
        let poemPrice = ether('0.1');
        await this.PoemesInstance.generatePoem({value : poemPrice});
    });


})