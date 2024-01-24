// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleWallet {
    address public owner;
    uint256 public balance;

    event Deposit(address indexed account, uint256 amount);
    event Withdrawal(address indexed account, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deposit(uint256 amount) external payable onlyOwner {
        require(amount > 0, "Deposit amount must be greater than 0");
        balance += amount;
        emit Deposit(msg.sender, amount);
    }

    function withdraw(uint256 amount) external onlyOwner {
        require(amount > 0, "Withdrawal amount must be greater than 0");
        require(balance >= amount, "Insufficient balance");

        balance -= amount;
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Withdrawal failed");

        emit Withdrawal(msg.sender, amount);
    }

    // Fallback function to receive ether
    receive() external payable {}
}
