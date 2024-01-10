// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// Create a Twitter contract
// Create a mapping between user and tweet 
// Add function to create a tweet and save it in mapping 
// Create a function to get Tweet

contract Twitter {

    mapping (address => string[]) public tweets;

    function createTweet(string memory _tweet) public {
        tweets[msg.sender].push(_tweet);
    }

    function getTweet(address _owner, uint256 _i) public view returns (string memory) {
        require(_i < tweets[_owner].length, "Index out of bounds");
        return tweets[_owner][_i];
    }
    function getAllTweets(address _owner) public view returns (string[] memory ){
        return tweets[_owner];
    }
}

