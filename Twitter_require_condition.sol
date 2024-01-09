// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// 1. Use require tolimit the length of the Tweet to be only 280 character

contract Twitter {

    uint16 constant MAX_TWEET_LENGTH =280;

    // Define the struct
    struct Tweet {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;

    function createTweet(string memory _tweet) public {

        // conditional
        // if tweet length <= 280 then we are good,otherwise revert
        require(bytes(_tweet).length<=MAX_TWEET_LENGTH, "Tweet is too long bro!!");
        Tweet memory newTweet = Tweet({
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function getTweet( uint256 _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
