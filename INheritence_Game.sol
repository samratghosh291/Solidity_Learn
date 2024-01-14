
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// 1. Inherit from the Multiplayer Game
// 2. Call the parent joinGame() function
// HINT: You might have to use the super keyword
// 4. Increment playerCount in joinGame() function

//Multiplayer Contract 
contract MultiplayerGame{
    mapping (address =>bool) public players;

    function joinGame() public virtual {
        players[msg.sender]=true;
    }
}

// Gmae Cpntract inheriting from MultiplayerGame
contract Game is MultiplayerGame{
    string public gameName;
    uint256 public playerCount;

    constructor(string memory _gameName){
        gameName=_gameName;
        playerCount=0;
    }

    function statrGame() public {
        //logic here 
    }

    function joinGame() public override {
        // here it is call the joinGame() of parent class
            super.joinGame();

            playerCount++;
    }
}