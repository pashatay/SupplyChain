pragma solidity ^0.8.0;

import "./ItemManager.sol";

contract Item {
    uint256 public priceInWei;
    uint256 public paidWei;
    uint256 public index;

    ItemManager parentContract;

    constructor(
        ItemManager _parentContract,
        uint256 _priceInWei,
        uint256 _index
    ) {
        priceInWei = _priceInWei;
        index = _index;
        parentContract = _parentContract;
    }

    receive() external payable {
        require(msg.value == priceInWei, "We dont support partial payments");
        require(paidWei == 0, "Item was already paid");

        paidWei += msg.value;
        (bool success, ) =
            address(parentContract).call{value: msg.value}(
                abi.encodeWithSignature("triggerPayment(uint256)", index)
            );
        require(success, "Delivery did not work");
    }
}
