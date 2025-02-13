// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RentalAgreement {
    struct Rental {
        address lender;
        address borrower;
        uint256 collateral;
        bool isActive;
    }

    mapping(uint256 => Rental) public rentals;
    uint256 public rentalCounter;

    // Add an event to track when rentals are listed or borrowed
    event ItemListed(uint256 rentalId, address lender, uint256 colalterel);
    event ItemBorrowed(uint256 rentalId, address borrower, uint256 collateral);

    function listItem(uint256 _collateral) public {
        require(_collateral > 0, "Collateral must be greater than 0");

        rentals[rentalCounter] = Rental(
            msg.sender,
            address(0),
            _collateral,
            false
        );

        // Emit event to check if function is called
        emit ItemListed(rentalCounter, msg.sender, _collateral);

        rentalCounter++;
    }

    function borrowItem(uint256 _rentalId) public payable {
        require(
            rentals[_rentalId].lender != address(0),
            "Rental does not exist"
        );
        require(rentals[_rentalId].borrower == address(0), "Already borrowed");
        require(
            msg.value == rentals[_rentalId].collateral,
            "Incorrect collateral amount"
        );

        rentals[_rentalId].borrower = msg.sender;
        rentals[_rentalId].isActive = true;

        emit ItemBorrowed(_rentalId, msg.sender, msg.value);
    }

    function returnItem(uint256 _rentalId) public {
        require(
            rentals[_rentalId].lender != address(0),
            "Rental does not exist"
        );
        require(
            msg.sender == rentals[_rentalId].borrower,
            "Only borrower can return"
        );
        require(rentals[_rentalId].isActive == true, "Rental not active");

        uint256 collateralAmount = rentals[_rentalId].collateral;

        rentals[_rentalId].borrower = address(0);
        rentals[_rentalId].isActive = false;
        payable(msg.sender).transfer(collateralAmount);
    }
}
