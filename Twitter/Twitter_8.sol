// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

// Import Ownable.sol contract from OpenZeppelin
import "@openzeppelin/contracts/access/Ownable.sol";

contract Twitter is Ownable {

    uint16 public MAX_TWEET_LENGTH = 280;

    // Define the struct
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    // Mapping to store tweets for each author
    mapping(address => Tweet[]) public tweets;

    // Define events
    event TweetCreated(uint256 id, address author, string content, uint256 timestamp);
    event TweetLiked(address liker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);
    event TweetUnliked(address unliker, address tweetAuthor, uint256 tweetId, uint256 newLikeCount);

    // Constructor with an initial owner parameter
    constructor (address initialOwner) Ownable(initialOwner) {
        // Additional initialization logic can be added here
    }

    // Function to change the maximum tweet length, only callable by the owner
    function changeTweetLength(uint16 newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = newTweetLength;
    }

    // Function to get the total likes for a given author
    function getTotalLikes(address _author) external view returns (uint256) {
        uint totalLikes = 0;
        for (uint i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }
        return totalLikes;
    }

    // Function to create a new tweet
    function createTweet(string memory _tweet) public {
        // Check if the tweet length is within the allowed limit
        require(bytes(_tweet).length <= MAX_TWEET_LENGTH, "Tweet is too long");

        // Create a new tweet
        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });

        // Add the new tweet to the author's list of tweets
        tweets[msg.sender].push(newTweet);

        // Emit the TweetCreated event
        emit TweetCreated(newTweet.id, newTweet.author, newTweet.content, newTweet.timestamp);
    }

    // Function to like a tweet
    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        tweets[author][id].likes++;

        // Emit the TweetLiked event
        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    // Function to unlike a tweet
    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "Tweet does not exist");
        require(tweets[author][id].likes > 0, "Tweet has no likes");
        tweets[author][id].likes--;

        // Emit the TweetUnliked event
        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    // Function to get a specific tweet by index
    function getTweet(uint256 _i) public view returns (Tweet memory) {
        return tweets[msg.sender][_i];
    }

    // Function to get all tweets for a specific author
    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
