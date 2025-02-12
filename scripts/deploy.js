const hre = require("hardhat");

async function main() {
    const RentalAgreement = await hre.ethers.getContractFactory("RentalAgreement");
    const rentalContract = await RentalAgreement.deploy();
    await rentalContract.waitForDeployment();

    console.log("RentalAgreement deployed to:", rentalContract.target);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
