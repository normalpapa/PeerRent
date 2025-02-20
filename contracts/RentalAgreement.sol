// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RentalAgreement {
    struct Rental {
        address lender;
        address borrower;
        uint256 collateral;
        bool isActive;
        uint256 maxBorrowDays;
        uint256 borrowedAt;
        uint256 dueDate;
    }

    mapping(uint256 => Rental) public rentals;
    uint256 public rentalCounter;

    uint256 public constant DAILY_LATE_FEE = 0.0001 ether;

    // Events to track when rentals are listed or borrowed and returned
    event ItemListed(
        uint256 rentalId,
        address lender,
        uint256 colalterel,
        uint256 maxBorrowDays
    );
    event ItemBorrowed(uint256 rentalId, address borrower, uint256 collateral);
    event ItemReturned(uint256 rentalId, address borrower);
    event ReturnConfirmed(uint256 rentalId, address lender, address borrower);
    event lateFeeClaimed(uint256 rentalId, address lender, uint256 feeAmount);

    function listItem(uint256 _collateral, uint256 _maxBorrowDays) public {
        require(_collateral > 0, "Collateral must be greater than 0");
        require(_maxBorrowDays > 0, "Borrow duration must be greater than 0");

        rentals[rentalCounter] = Rental(
            msg.sender, // lender
            address(0), // borrower
            _collateral,
            false, // isActive
            _maxBorrowDays,
            0, // BorrowedAt
            0 // dueDate
        );

        // Emit event to check if function is called
        emit ItemListed(rentalCounter, msg.sender, _collateral, _maxBorrowDays);
        rentalCounter++;
    }

    function borrowItem(uint256 _rentalId) public payable {
        Rental storage rental = rentals[_rentalId];

        require(
            rentals[_rentalId].lender != address(0),
            "Rental does not exist"
        );
        require(rentals[_rentalId].borrower == address(0), "Already borrowed");
        require(
            msg.value == rentals[_rentalId].collateral,
            "Incorrect collateral amount"
        );

        // Lock collateral in this escrow contract
        rentals[_rentalId].borrower = msg.sender;
        // Mark renta as active
        rentals[_rentalId].isActive = true;

        // Set borrowing time & due date
        rental.borrowedAt = block.timestamp;
        rental.dueDate = block.timestamp + (rental.maxBorrowDays * 1 days);

        emit ItemBorrowed(_rentalId, msg.sender, msg.value);
    }

    function returnItem(uint256 _rentalId) public {
        Rental storage rental = rentals[_rentalId];

        require(
            rentals[_rentalId].lender != address(0),
            "Rental does not exist"
        );
        require(
            msg.sender == rentals[_rentalId].borrower,
            "Only borrower can return"
        );

        require(rental.borrower == msg.sender, "Only borrower can return");

        // Mark the rental as no longer active
        rental.isActive = false;

        // We do NOT immediately refund collateral here.
        // We just record that the borrower claims to have returned the item.
        // Next step: Lender either confirms or claims fees.

        emit ItemReturned(_rentalId, msg.sender);
    }

    function lenderConfirmRetrun(uint256 _rentalId) public {
        Rental storage rental = rentals[_rentalId];

        require(rental.lender == msg.sender, "Only lender can confirm return");
        require(!rental.isActive, "Item has not been returned yet");
        require(rental.borrower != address(0), "No borrower to refund");

        // Transfer the ENTIRE remaining collateral back to the borrower
        uint256 collateralAmount = rental.collateral;
        address borrowerAddress = rental.borrower;

        // Reset struct fields
        rental.borrower = address(0);
        rental.collateral = 0;

        // Send funds to the borrower
        (bool success, ) = payable(borrowerAddress).call{
            value: collateralAmount
        }("");
        require(success, "Collateral refund failed");

        emit ReturnConfirmed(_rentalId, msg.sender, borrowerAddress);
    }

    function claimLateFee(uint256 _rentalId) public {
        Rental storage rental = rentals[_rentalId];

        require(rental.lender == msg.sender, "Only lender can claim late fee");
        require(rental.isActive, "Rental must still be active to claim fee");
        require(block.timestamp > rental.dueDate, "Not overdue yet");

        // Calculate how many days late
        uint256 daysLate = (block.timestamp - rental.dueDate) / 1 days;
        uint256 fee = daysLate * DAILY_LATE_FEE;

        // Cap the fee at the total collateral
        if (fee > rental.collateral) {
            fee = rental.collateral;
        }

        // Deduct from collateral
        rental.collateral -= fee;

        // Transfer fee to lender
        (bool success, ) = payable(rental.lender).call{value: fee}("");
        require(success, "Fee transfer failed");

        emit lateFeeClaimed(_rentalId, msg.sender, fee);
    }
}
