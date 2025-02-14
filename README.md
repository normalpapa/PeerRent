# PeerRent

**PeerRent** is a decentralized rental system built on Ethereum using **Solidity**. It allows users to list items for rent, borrow items by locking collateral, and return items to recover their collateral. The project was developed to gain hands-on experience with **smart contract development**, **testing**, and **deployment** using Hardhat and Ethers.js.

---

## Table of Contents

1. [Introduction](#introduction)  
2. [Features](#features)  
3. [Technologies](#technologies)  
4. [Installation](#installation)  
5. [Usage](#usage)  
6. [Testing](#testing)  
7. [Deployment](#deployment)  
8. [Future Roadmap](#future-roadmap)  
9. [Contributing](#contributing)  
10. [License](#license)

---

## Introduction

PeerRent is designed to create a **decentralized marketplace** for renting physical items without relying on centralized intermediaries. Users can list their items with a specified collateral amount, and borrowers must lock up an equivalent amount of ETH as collateral when renting an item. Once the item is returned, the collateral is refunded to the borrower. This basic mechanism can be expanded in the future to include features such as:

- Late fees for overdue returns
- Damage compensation and dispute resolution
- Reputation systems for lenders and borrowers

---

## Features

- **Item Listing**: Users can list items by specifying a collateral requirement.  
- **Collateral Escrow**: When an item is borrowed, the collateral is securely held by the smart contract.  
- **Borrowing & Returning**: Borrowers lock collateral to rent an item and receive it back upon return.  
- **Expandable Design**: The contract can be extended with late fees, dispute resolution, reputation systems, etc.  
- **Automated Testing**: Comprehensive tests using Hardhat and Ethers.js.

---

## Technologies

- **Solidity**: Smart contract programming language  
- **Hardhat**: Ethereum development environment (compiling, testing, deploying)  
- **Ethers.js**: Library for interacting with Ethereum  
- **Node.js**: JavaScript runtime environment  
- **Git & GitHub**: Version control and project hosting  

---

## Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/PeerRent.git
   cd PeerRent
Install Dependencies:

bash
Copy
npm install
Set Up Environment Variables:
Create a .env file in the root directory and add your keys (for example, your Alchemy API key and private keys):

dotenv
Copy
ALCHEMY_API_KEY="https://eth-sepolia.g.alchemy.com/v2/YOUR_ALCHEMY_KEY"
PRIVATE_KEY="YOUR_OWNER_PRIVATE_KEY"
BORROWER_PRIVATE_KEY="YOUR_BORROWER_PRIVATE_KEY"
Note: Ensure .env is in your .gitignore so you don't commit sensitive data.

Usage
Listing an Item
Deploy the contract (see Deployment).
Call listItem() with the desired collateral amount.
The contract stores the item with its collateral requirement.
Borrowing an Item
The borrower calls borrowItem() with the required collateral amount.
The collateral is held in the contract until the item is returned.
Returning an Item
The borrower calls returnItem().
The collateral is released back to the borrower upon successful return.
Testing
Run the test suite using Hardhat:

bash
Copy
npx hardhat test
Tests include:

Listing an item
Borrowing an item (collateral locking)
Returning an item (collateral refund)
Deployment
To deploy on Sepolia (or any supported network), use the provided script:

bash
Copy
npx hardhat run scripts/deploy.js --network sepolia
Make sure your .env file is properly configured (API keys, private keys, etc.).
The script outputs the contract address upon successful deployment.
Future Roadmap
Escrow & Collateral Enhancements: Deduct late fees or compensate for item damage.
Rental Duration & Penalties: Enforce time limits and automatically apply late fees.
Dispute Resolution: Introduce community or DAO-based dispute resolution.
Item Verification & Metadata: Store item details (e.g., IPFS images) and possibly verify authenticity.
Ratings & Reputation: Implement a karma or star-based system for lenders and borrowers.
Frontend Integration: Build a user-friendly interface (React/Next.js) to interact with the contract.
Contributing
Contributions are welcome! To get started:

Fork the repo
Create a feature branch (git checkout -b feature/someFeature)
Commit your changes (git commit -m "Add some feature")
Push to your branch (git push origin feature/someFeature)
Open a pull request on GitHub
License
This project is licensed under the MIT License. Feel free to use, modify, and distribute it.

Happy renting!

yaml
Copy

---

### **How to Update**
1. Copy all of the above into your `README.md`.
2. Adjust any links or details specific to your repository (e.g., Git URL).
3. Commit and push to GitHub:
   ```bash
   git add README.md
   git commit -m "Update README"
   git push origin main