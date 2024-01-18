// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChainContract {
    address public seller;
    address public buyer;

    enum OrderStatus { Placed, Shipped, Delivered }

    struct Product {
        uint256 productId;
        string name;
        uint256 price;
        uint256 quantity;
    }

    struct Order {
        uint256 orderId;
        address buyer;
        uint256 productId;
        uint256 quantity;
        OrderStatus status;
    }

    mapping(uint256 => Product) public products;
    mapping(uint256 => Order) public orders;
    uint256 public productCount;
    uint256 public orderCount;

    event ProductAdded(uint256 productId, string name, uint256 price, uint256 quantity);
    event OrderPlaced(uint256 orderId, address indexed buyer, uint256 productId, uint256 quantity);
    event OrderShipped(uint256 orderId);
    event OrderDelivered(uint256 orderId);
    event BuyerAddressSet(address indexed buyer);

    modifier onlySeller() {
        require(msg.sender == seller, "Only the seller can call this function");
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only the buyer can call this function");
        _;
    }

    modifier productExists(uint256 _productId) {
        require(products[_productId].productId == _productId, "Product does not exist");
        _;
    }

    modifier orderExists(uint256 _orderId) {
        require(orders[_orderId].orderId == _orderId, "Order does not exist");
        _;
    }

    constructor() {
        seller = msg.sender;
    }

    function setBuyerAddress(address _buyer) external onlySeller {
        buyer = _buyer;
        emit BuyerAddressSet(_buyer);
    }

    function addProduct(string memory _name, uint256 _price, uint256 _quantity) external onlySeller {
        productCount++;
        uint256 productId = productCount;

        products[productId] = Product({
            productId: productId,
            name: _name,
            price: _price,
            quantity: _quantity
        });

        emit ProductAdded(productId, _name, _price, _quantity);
    }

    function placeOrder(uint256 _productId, uint256 _quantity) external onlyBuyer productExists(_productId) {
        require(products[_productId].quantity >= _quantity, "Not enough stock");

        orderCount++;
        uint256 orderId = orderCount;

        orders[orderId] = Order({
            orderId: orderId,
            buyer: buyer,
            productId: _productId,
            quantity: _quantity,
            status: OrderStatus.Placed
        });

        emit OrderPlaced(orderId, buyer, _productId, _quantity);
    }

    function shipOrder(uint256 _orderId) external onlySeller orderExists(_orderId) {
        require(orders[_orderId].status == OrderStatus.Placed, "Order is not in a shippable state");

        orders[_orderId].status = OrderStatus.Shipped;
        emit OrderShipped(_orderId);
    }

    function deliverOrder(uint256 _orderId) external onlyBuyer orderExists(_orderId) {
        require(orders[_orderId].status == OrderStatus.Shipped, "Order is not in a deliverable state");

        orders[_orderId].status = OrderStatus.Delivered;

        // Update product quantity after delivery
        products[orders[_orderId].productId].quantity -= orders[_orderId].quantity;

        emit OrderDelivered(_orderId);
    }
}
