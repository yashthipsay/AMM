const { ethers } = require("hardhat")

describe("Lock", () => {
    it("should work", async () => {
        const [owner, otherAccounts] = await ethers.getSigners();
        const Pool = await ethers.getContractFactory("Pool");
        const initialSupply = ethers.parseUnits("20.0", 5);
        const slope = 1;
        const pool = await Pool.deploy(initialSupply, slope);

        await owner.sendTransaction({
            to: pool.target,
            value: ethers.parseEther("1000.0"),
        })

         const contractBalance = await ethers.provider.getBalance(pool.target);
         console.log(contractBalance);

        const tokenPrice = await pool.calculateTokenPrice();
        console.log(tokenPrice);

        await pool.buy({value: ethers.parseEther("20.0")});  

        const balance = await pool.balanceOf(owner.address);
        console.log(balance);

        const newTokenPrice = await pool.calculateTokenPrice();
        console.log(newTokenPrice);


        await pool.sell(balance);
        const priceAfter = await pool.calculateTokenPrice();
        console.log(priceAfter);

        
    });
});