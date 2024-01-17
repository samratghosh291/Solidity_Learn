// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract SupplyChainContract {
    address public buyer;
    address public seller;

    enum OrderStatus { Created, Shipped, Delivered }

    struct Order {
        uint256 orderId;
        string product;
        uint256 quantity;
        OrderStatus status;
    }

    mapping(uint256 => Order) public orders;
    uint256 public orderCount;

    event OrderEvent(uint256 orderId, string product, uint256 quantity, OrderStatus status);

    modifier onlyParticipant() {
        require(msg.sender == buyer || msg.sender == seller, "Only buyer or seller can call this function");
        _;
    }

    modifier orderExists(uint256 _orderId) {
        require(orders[_orderId].orderId == _orderId, "Order does not exist");
        _;
    }

    modifier orderNotDelivered(uint256 _orderId) {
        require(orders[_orderId].status != OrderStatus.Delivered, "Order already delivered");
        _;
    }

    constructor(address _seller) {
        buyer = msg.sender;
        seller = _seller;
    }

    function placeOrder(string memory _product, uint256 _quantity) external onlyParticipant {
        orderCount++;
        uint256 orderId = orderCount;

        orders[orderId] = Order({
            orderId: orderId,
            product: _product,
            quantity: _quantity,
            status: OrderStatus.Created
        });

        emit OrderEvent(orderId, _product, _quantity, OrderStatus.Created);
    }

    function updateOrderStatus(uint256 _orderId, OrderStatus _newStatus) internal orderExists(_orderId) {
        orders[_orderId].status = _newStatus;
        emit OrderEvent(_orderId, orders[_orderId].product, orders[_orderId].quantity, _newStatus);
    }

    function shipOrder(uint256 _orderId) external onlyParticipant orderNotDelivered(_orderId) {
        updateOrderStatus(_orderId, OrderStatus.Shipped);
    }

    function deliverOrder(uint256 _orderId) external onlyParticipant orderNotDelivered(_orderId) {
        updateOrderStatus(_orderId, OrderStatus.Delivered);
    }

    function getAllOrders() external view onlyParticipant returns (Order[] memory) {
        Order[] memory allOrders = new Order[](orderCount);

        for (uint256 i = 1; i <= orderCount; i++) {
            allOrders[i - 1] = orders[i];
        }

        return allOrders;
    }

    function getShippableOrders() external view onlyParticipant returns (Order[] memory) {
        uint256 shippableOrderCount = 0;

        for (uint256 i = 1; i <= orderCount; i++) {
            if (orders[i].status == OrderStatus.Created) {
                shippableOrderCount++;
            }
        }

        Order[] memory shippableOrders = new Order[](shippableOrderCount);
        uint256 index = 0;

        for (uint256 i = 1; i <= orderCount; i++) {
            if (orders[i].status == OrderStatus.Created) {
                shippableOrders[index] = orders[i];
                index++;
            }
        }

        return shippableOrders;
    }
}
