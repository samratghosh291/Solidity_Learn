// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

contract PesticideSupplyChain {
    address public manufacturer;
    address public distributor;
    address public supplier;

    enum State { Created, Ordered, Shipped, Received }

    struct Order {
        address buyer;
        uint256 quantity;
        bool accepted;
        bool shipped;
        bool received;
    }

    mapping(address => Order) public orders;

    State public currentState;

    modifier onlyManufacturer() {
        require(msg.sender == manufacturer, "Only manufacturer can call this function");
        _;
    }

    modifier onlyDistributor() {
        require(msg.sender == distributor, "Only distributor can call this function");
        _;
    }

    modifier onlySupplier() {
        require(msg.sender == supplier, "Only supplier can call this function");
        _;
    }

    modifier onlyInState(State _state) {
        require(currentState == _state, "Invalid state for this operation");
        _;
    }

    modifier onlyOrderPlaced() {
        require(orders[distributor].buyer != address(0), "No order exists for the distributor");
        _;
    }

    event OrderPlaced(address indexed buyer, uint256 quantity);
    event OrderAccepted(address indexed buyer);
    event OrderShipped(address indexed buyer);
    event OrderReceived(address indexed buyer);

    constructor(address _distributor, address _supplier) {
        manufacturer = msg.sender;
        distributor = _distributor;
        supplier = _supplier;
        currentState = State.Created;
    }

    function placeOrder(uint256 _quantity) external onlySupplier onlyInState(State.Created) {
        orders[distributor] = Order({
            buyer: distributor,
            quantity: _quantity,
            accepted: false,
            shipped: false,
            received: false
        });

        currentState = State.Ordered;

        emit OrderPlaced(distributor, _quantity);
    }

    function acceptOrder() external onlyDistributor onlyInState(State.Ordered) onlyOrderPlaced {
        orders[distributor].accepted = true;

        emit OrderAccepted(distributor);
    }

    function shipOrder() external onlyManufacturer onlyInState(State.Ordered) onlyOrderPlaced {
        orders[distributor].shipped = true;
        currentState = State.Shipped;

        emit OrderShipped(distributor);
    }

    function receiveOrder() external onlyDistributor onlyInState(State.Shipped) onlyOrderPlaced {
        orders[distributor].received = true;
        currentState = State.Received;

        emit OrderReceived(distributor);
    }
}
