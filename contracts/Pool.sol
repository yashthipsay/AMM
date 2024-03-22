// SPDX-License-Identifier: UNILICENSED
pragma solidity ^0.8.20;
import "./SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Pool is ERC20 {
    using SafeMath for uint256;
    using SafeMath for uint32;



    // mapping(address => uint256) public balances;
    // uint256 totalSupply;
    uint32 slope;

    // Slope is a constant that determines the rate at which the pool's balance increases or decreases.
    // Equation for the curve if f(x) = x^2, it determines how exponentially the price of the token will increase based on the supply

    constructor(uint256 initialSupply, uint32 _slope) ERC20("Token", "T"){
        _mint(msg.sender, initialSupply);
        // totalSupply = initialSupply;
        slope = _slope;
    }

    function sell(uint256 tokens) public{
        require(balanceOf(msg.sender) >= tokens);

        // totalSupply = totalSupply.sub(tokens);
        // uint256 balance = balanceOf(msg.sender);

        uint256 ethReturn = calculateSellReturn(tokens);

        require(
            ethReturn <= address(this).balance,
            "Insufficient balance in the contract"
        );

        _burn(msg.sender, tokens); 

        payable(msg.sender).transfer(ethReturn);

    }

    function buy() public payable {
                require(msg.value > 0, "eth amount can not be empty");
        uint256 tokensToMint = calculateBuyReturn(msg.value);

        _mint(msg.sender, tokensToMint);



        

    }

    function calculateSellReturn(uint256 tokens) public view returns (uint256){
        uint256 currentPrice = calculateTokenPrice();

        return tokens.mul(currentPrice);
    }

    function calculateBuyReturn(uint256 depositAmount) public view returns (uint256) {
        uint256 currentPrice = calculateTokenPrice();

        return depositAmount.div(currentPrice);
    }

    function calculateTokenPrice() public view returns (uint256) {
        uint256 supply = totalSupply();
        uint256 temp = supply.mul(supply);
        return slope.mul(temp);
    }

    receive() external payable {
         
    }
}
