// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// 1. Add id to Tweet Struct to make every Tweet unique
// 2. Set the di to be the Tweet[] length
// HINT: you do it in the createTweet function 
// 3. Add a function to like the tweet 
// HINT: there should be two parameters id and author 
// 4. Add a function to dislike the tweet 
// HINT: make sure you can unlike tweet if and only if the likes count is greater than 0 
// 5. Mark both functions external 

contract Twitter {

    uint16 public MAX_TWEET_LENGTH =280;

    // Define the struct
    struct Tweet {
        uint256 id;
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
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        tweets[msg.sender].push(newTweet);
    }

    function likeTweet(address author,uint256 id) external {
        require(tweets[author][id].id==id, "TWEET DOES NOT EXIST");
        tweets[author][id].likes++;
    }

    function unlikeTweet(address author, uint256 id)external{
        require(tweets[author][id].id==id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes>0,"TWEET HAS NO LIKES");
        tweets[author][id].likes--;
    }

    function getTweet( uint256 _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
