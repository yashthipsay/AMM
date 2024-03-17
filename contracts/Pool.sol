// SPDX-License-Identifier: UNILICENSED
pragma solidity ^0.8.0;
import "./SafeMath.sol";

contract Pool {
    using SafeMath for uint256;
    using SafeMath for uint32;

    mapping(address => uint256) public balances;
    uint256 totalSupply;
    uint32 slope;

    // Slope is a constant that determines the rate at which the pool's balance increases or decreases.
    // Equation for the curve if f(x) = x^2, it determines how exponentially the price of the token will increase based on the supply

    constructor(uint256 initialSupply, uint32 _slope) {
        
        totalSupply = initialSupply;
        slope = _slope;
    }

    function buy() public payable {
                require(msg.value > 0);
        uint256 tokensToMint = calculateBuyReturn(msg.value);
        totalSupply = totalSupply.add(tokensToMint);

        uint256 currentBalance = balances[msg.sender];
        balances[msg.sender] = currentBalance.add(tokensToMint);

    }

    function calculateBuyReturn(uint256 deplositAmount) public view returns (uint256) {
        uint256 currentPrice = calculateTokenPrice();
        return deplositAmount.div(currentPrice);
    }

    function calculateTokenPrice() public view returns (uint256) {
        uint256 temp = totalSupply.mul(totalSupply);
        return slope.mul(temp);
    }
}
