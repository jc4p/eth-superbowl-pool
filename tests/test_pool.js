const truffleAssert = require('truffle-assertions');
const BigGamePool = artifacts.require("BigGamePool");

const toHex = (str) => web3.utils.padRight(web3.utils.asciiToHex(str), 64);
const toBN = web3.utils.toBN;
const toWei = web3.utils.toWei;
const getBalance = web3.eth.getBalance;

const all_first_choices = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]

contract("BigGamePool", async accounts => {
  it("should not let voting happen for free", async () => {
    const pool = await BigGamePool.new()

    await truffleAssert.fails(
      pool.placeBets(all_first_choices, { from: accounts[1] }),
      "Call costs 0.0056 ETH"
    )
  })

  it("betting should cost 0.0056 ETH", async () => {
    const pool = await BigGamePool.new()

    await truffleAssert.passes(
      pool.placeBets(all_first_choices, { from: accounts[1], value: toWei("0.0056") })
    )
  })

  it("if only two people bet, winner gets 0.01, owner gets rest", async () => {
    const pool = await BigGamePool.new()

    await pool.placeBets(all_first_choices, { from: accounts[2], value: toWei("00.0056") })
    await pool.placeBets(all_first_choices, { from: accounts[3], value: toWei("00.0056") })

    const winnerInitialBalance = await getBalance(accounts[1])
    const ownerInitialBalance = await getBalance(accounts[0])

    await pool.payout(accounts[1])

    const winnerNewBalance = await getBalance(accounts[1])
    console.log('Old winner balance: ' + winnerInitialBalance)
    console.log('New winner balance: ' + winnerNewBalance)
    assert (winnerNewBalance - winnerInitialBalance) == toWei("00.01")

    const ownerNewBalance = await getBalance(accounts[0])
    console.log('Old owner balance: ' + ownerInitialBalance)
    console.log('New winner balance: ' + ownerNewBalance)

    assert (ownerNewBalance - ownerInitialBalance) == toWei("0.0012")
  })
})