const { ethers } = require("hardhat")

describe("Lock", () => {
    it("should work", async () => {
        const [owner, otherAccounts] = await ethers.getSigners();
        const Pool = await ethers.getContractFactory("Pool");
        const initialSupply = 20; //ethers.parseUnits("20", 8);
        const slope = 1;
        const pool = await Pool.deploy(initialSupply, slope);

         const contractBalance = await ethers.provider.getBalance(pool.target);
         console.log(contractBalance);

        const tokenPrice = await pool.calculateTokenPrice();
        console.log(tokenPrice);

        await pool.buy({value: ethers.parseEther("20.0")});  

        const balance = await pool.balances(owner.address);
        console.log(balance);

        await pool.sell(balance);
        const priceAfter = await pool.calculateTokenPrice();
        console.log(priceAfter);

        const newBalance = await pool.balances(owner.address);
        console.log(newBalance);
    });
});