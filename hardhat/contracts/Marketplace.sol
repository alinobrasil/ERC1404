pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OrderBook {
    // mapping of token address to order
    mapping(address => Order[]) public orders;

    event OrderCreated(
        address indexed token,
        uint256 indexed amount,
        uint256 indexed price
    );

    event OrderFilled(
        address indexed token,
        uint256 indexed amount,
        uint256 indexed price
    );

    struct Order {
        uint256 amount; // amount of tokens for sale
        uint256 price; // price per token
        address seller; // address of seller
    }

    // should also approve&transfer the token for sale to the dex/orderbook contract
    function createOrder(
        address token,
        uint256 amount,
        uint256 price
    ) public {
        // create new order
        Order memory order = Order({
            amount: amount,
            price: price,
            seller: msg.sender
        });
        // add order to mapping
        orders[token].push(order);
        // emit event
        emit OrderCreated(token, amount, price);
    }

    // function to fill an order
    function fillOrder(
        address token,
        uint256 amount,
        uint256 price
    ) public {
        // loop through orders
        for (uint256 i = 0; i < orders[token].length; i++) {
            // get order
            Order storage order = orders[token][i];
            // check if order matches
            if (order.amount == amount && order.price == price) {
                // transfer tokens to buyer
                IERC20(token).transfer(msg.sender, amount);
                // transfer ether to seller
                order.seller.transfer(amount * price);
                // delete order
                delete orders[token][i];
                // emit event
                emit OrderFilled(token, amount, price);
            }
        }
    }
}
