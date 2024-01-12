// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// 1. Create Event for creating the tweet. called TweetCreated
// Use parameters like id, authir, timestamp
// 2. Emit the event in the createTweet() function below
// 3. Create Event for liking the tweet, called TweetLiked
// Use parameters like liker, tweetAuthor, tweetId, newLikeCount
// 4. Emit the event in the likeTweet(), function below 
// 5. Create Event for liking the tweet, called TweetUnliked
// Use parameters like unliker, tweetAuthor, tweetId, newLikeCount
// 6. Emit the event in the unlikeTweet(), function below 


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

    // Define the event here 
    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address uint128liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);




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

        // emit the event 
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    function likeTweet(address author,uint256 id) external {
        require(tweets[author][id].id==id, "TWEET DOES NOT EXIST");
        tweets[author][id].likes++;

        // emit the tweet 
        emit TweetLiked(msg.sender, author, id,tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id)external{
        require(tweets[author][id].id==id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes>0,"TWEET HAS NO LIKES");
        tweets[author][id].likes--;

         // emit the tweet 
        emit TweetUnliked(msg.sender, author, id,tweets[author][id].likes);
    }

    function getTweet( uint256 _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
