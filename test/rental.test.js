const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RentalAgreement", function () {
    let RentalAgreement, rentalContract, owner, borrower;

    before(async function () {
        [owner, borrower] = await ethers.getSigners();
        RentalAgreement = await ethers.getContractFactory("RentalAgreement");
        rentalContract = await RentalAgreement.deploy();
        await rentalContract.waitForDeployment();
    });

    it("Should list an item", async function () {
        const tx = await rentalContract.connect(owner).listItem(ethers.parseEther("0.001"));
        await tx.wait();

        const rental = await rentalContract.rentals(0);
        expect(rental.lender).to.equal(owner.address);
        expect(rental.collateral).to.equal(ethers.parseEther("0.001"));
        expect(rental.isActive).to.be.false;
    });

    it("Should allow borrower to rent item", async function () {
        await borrower.sendTransaction({
            to: owner.address,
            value: ethers.parseEther("0.01"), // Fund borrower
        });

        const tx = await rentalContract.connect(borrower).borrowItem(0, { value: ethers.parseEther("0.001") });
        await tx.wait();

        const rental = await rentalContract.rentals(0);
        expect(rental.borrower).to.equal(borrower.address);
        expect(rental.isActive).to.be.true;
    });

    it("Should allow borrower to return item", async function () {
        const tx = await rentalContract.connect(borrower).returnItem(0);
        await tx.wait();

        const rental = await rentalContract.rentals(0);
        expect(rental.borrower).to.equal(ethers.ZeroAddress);
        expect(rental.isActive).to.be.false;
    });
});
