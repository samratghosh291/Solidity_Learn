// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// 1. Add afunction called changeTweetLength to change max tweet length 
// HINT: Use newTweetLength as input for function 
// 2. Create a constructor function to set an owner of contract 
// 3. Create a modifier called onlyOwner 
// 4. Use onlyOwner on the changeTweetLength function 



contract Twitter {

    uint16 public MAX_TWEET_LENGTH =280;

    // Define the struct
    struct Tweet {
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender==owner,"YOU ARE NOT THE OWNER");
        _;
    }

    function changeTweetLength(uint16 newTweetLength) public onlyOwner{
        MAX_TWEET_LENGTH= newTweetLength;
    }

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
