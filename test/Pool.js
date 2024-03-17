const { ethers } = require("hardhat")

describe("Lock", () => {
    it("should work", async () => {
        const [owner, otherAccounts] = await ethers.getSigners();
        const Pool = await ethers.getContractFactory("Pool");
        const initialSupply = ethers.parseUnits("20", 8);
        const slope = 1;
        const pool = await Pool.deploy(initialSupply, slope);
        const tokenPrice = await pool.calculateTokenPrice();
        console.log(tokenPrice);

        await pool.buy({value: ethers.parseEther("2.0")});  

        const balance = await pool.balanceOf(owner.address);
        console.log(balance);
    });
});