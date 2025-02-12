const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("RentalAgreement", function () {
    let rentalContract, owner, borrower;

    beforeEach(async function () {
        [owner, borrower] = await ethers.getSigners();
        const RentalAgreement = await ethers.getContractFactory("RentalAgreement");
        rentalContract = await RentalAgreement.deploy();
        await rentalContract.waitForDeployment();
    });

    it("Should allow users to list items for rent", async function () {
        await rentalContract.listItem(ethers.parseEther("1"));
        const rental = await rentalContract.rentals(0);

        expect(rental.lender).to.equal(owner.address);
        expect(rental.collateral).to.equal(ethers.parseEther("1"));
        expect(rental.isActive).to.equal(false);
    });

    it("Should allow users to borrow an item", async function () {
        await rentalContract.listItem(ethers.parseEther("1"));

        await rentalContract.connect(borrower).borrowItem(0, { value: ethers.parseEther("1") });

        const rental = await rentalContract.rentals(0);
        expect(rental.borrower).to.equal(borrower.address);
        expect(rental.isActive).to.equal(true);
    });

    // it("Should allow borrowers to return an item and receive collateral back", async function () {
    //     await rentalContract.listItem(ethers.parseEther("1"));
    //     await rentalContract.connect(borrower).borrowItem(0, { value: ethers.parseEther("1") });

    //     const beforeBalance = await ethers.provider.getBalance(borrower.address);

    //     const tx = await rentalContract.connect(borrower).returnItem(0);
    //     const receipt = await tx.wait();

    //     // Ensure gasUsed is defined before converting to BigInt
    //     const gasUsed = receipt.gasUsed && receipt.effectiveGasPrice
    //         ? BigInt(receipt.gasUsed) * BigInt(receipt.effectiveGasPrice)
    //         : BigInt(0);

    //     const afterBalance = await ethers.provider.getBalance(borrower.address);

    //     const rental = await rentalContract.rentals(0);  // Fetch rental again after returning

    //     expect(rental.borrower).to.equal(ethers.ZeroAddress);
    //     expect(rental.isActive).to.equal(false);

    //     expect(BigInt(afterBalance)).to.be.closeTo(
    //         BigInt(beforeBalance) + BigInt(ethers.parseEther("1")),
    //         gasUsed
    //     );
    // });
});
