// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract NumberStorage {
    string[] public allNumbers;
    
    function storeNumber(uint256 _number) external {
        // Convert the number to a string before storing in IPFS
        string memory strNumber = uint2str(_number);
        ipfsHash = strNumber;
        allNumbers.push(strNumber);
    }

    function getNumbers() external view returns (string[] memory) {
        return allNumbers;
    }

    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint256 k = length;
        j = _i;
        while (j != 0) {
            bstr[--k] = bytes1(uint8(48 + j % 10));
            j /= 10;
        }
        return string(bstr);
    }
}
