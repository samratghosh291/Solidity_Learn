// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransparentMarketplace {
    address public admin;
    
    enum Role {None, Buyer, Seller}
    
    struct Product {
        string name;
        uint256 price;
        address seller;
        bool isAvailable;
    }
    
    struct Order {
        uint256 productId;
        address buyer;
        bool isAccepted;
        bool isCompleted;
    }

    mapping(address => Role) public userRoles;
    mapping(uint256 => Product) public products;
    mapping(address => uint256[]) public sellerProducts;
    mapping(address => Order[]) public buyerOrders;

    uint256 public productCounter;

    event ProductAdded(uint256 productId, string name, uint256 price, address seller);
    event OrderPlaced(uint256 orderId, uint256 productId, address buyer);
    event OrderAccepted(uint256 orderId);
    event OrderCompleted(uint256 orderId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlySeller() {
        require(userRoles[msg.sender] == Role.Seller, "Only seller can call this function");
        _;
    }

    modifier onlyBuyer() {
        require(userRoles[msg.sender] == Role.Buyer, "Only buyer can call this function");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function setRole(Role _role) external {
        require(userRoles[msg.sender] == Role.None, "User role already set");
        userRoles[msg.sender] = _role;
    }

    function addProduct(string memory _name, uint256 _price) external onlySeller {
        uint256 productId = productCounter++;
        Product memory newProduct = Product(_name, _price, msg.sender, true);
        products[productId] = newProduct;
        sellerProducts[msg.sender].push(productId);
        emit ProductAdded(productId, _name, _price, msg.sender);
    }



    function placeOrder(uint256 _productId) external onlyBuyer {
        require(products[_productId].isAvailable, "Product not available");
        Order memory newOrder = Order(_productId, msg.sender, false, false);
        buyerOrders[msg.sender].push(newOrder);
        emit OrderPlaced(buyerOrders[msg.sender].length - 1, _productId, msg.sender);
    }   

    function acceptOrder(uint256 _orderId) external onlySeller {
        Order storage order = buyerOrders[msg.sender][_orderId];
        require(!order.isAccepted, "Order already accepted");
        order.isAccepted = true;
        emit OrderAccepted(_orderId);
    }

    function completeOrder(uint256 _orderId) external onlySeller {
        Order storage order = buyerOrders[msg.sender][_orderId];
        require(order.isAccepted && !order.isCompleted, "Invalid order");
        order.isCompleted = true;
        products[order.productId].isAvailable = false;
        emit OrderCompleted(_orderId);
    }
}
