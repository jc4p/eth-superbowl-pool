// contracts/BigGamePool.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract BigGamePool is Ownable {  
  struct Question {
    string prompt; // text prompt
    uint choiceCount; // number of used choices
    bytes32 choiceOne;
    bytes32 choiceTwo;
    bytes32 choiceThree;
    bytes32 choiceFour;
    bytes32 choiceFive;
  }

  struct Bets {
    address voter;
    bool voted;
    uint8[30] responses;
  }

  uint8 public questionCount = 30;
  mapping(uint8 => Question) public questions;
  mapping(address => Bets) public bets;

  uint256 public totalPool;
  bool public bettingOpen;

  constructor() {
    bettingOpen = true;
    seedQuestions();
  }

  function placeBets(uint8[30] calldata packedResponses) payable public {
    require(bettingOpen, "Betting is closed");

    // ensure that they sent the right bet amount
    require(msg.value == 0.0056 * 10**18, "Call costs 0.0056 ETH");
    // 0.0056 - 0.0050 -> save ~10% for the house
    totalPool += 0.0050 * 10**18;

    Bets storage sender = bets[msg.sender];
    require(!sender.voted, "You've already placed your bet.");

    sender.voted = true;
    for (uint8 i = 0; i < questionCount; i++) {
      sender.responses[i] = packedResponses[i];
    }
  }

  function payout(address winner) public onlyOwner {
    // send the pool balance to the winner
    payable(winner).transfer(totalPool);
    // send the rest to the contract creator
    payable(msg.sender).transfer(address(this).balance);

    bettingOpen = false;
  }

  function seedQuestions() private {
    questions[1] = Question({
      prompt: "Will the duration of the national anthem be over or under 99.5 seconds?",
      choiceCount: 2,
      choiceOne: "Over",
      choiceTwo: "Under",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[2] = Question({
      prompt: "Who will be shown first during the national anthem?",
      choiceCount: 2,
      choiceOne: "Joe Burrow",
      choiceTwo: "Matthew Stafford",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[3] = Question({
      prompt: "Will the result of the coin toss be heads or tails?",
      choiceCount: 2,
      choiceOne: "Heads",
      choiceTwo: "Tails",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[4] = Question({
      prompt: "What color with Ja'Marr Chase's gloves be at the start of the game?",
      choiceCount: 3,
      choiceOne: "Black",
      choiceTwo: "Orange",
      choiceThree: "White",
      choiceFour: 0x0, choiceFive: 0x0
    });
    questions[5] = Question({
      prompt: "Will the first offensive play of the game be a run or a pass?",
      choiceCount: 2,
      choiceOne: "Run",
      choiceTwo: "Pass",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[6] = Question({
      prompt: "Which LA attraction will be shown first?",
      choiceCount: 2,
      choiceOne: "Hollywood Sign",
      choiceTwo: "Hollywood Walk of Fame",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[7] = Question({
      prompt: "Will the game's first accepted penalty be offensive or defensive?",
      choiceCount: 2,
      choiceOne: "Offensive",
      choiceTwo: "Defensive",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[8] = Question({
      prompt: "Will the team that scores first win the game?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[9] = Question({
      prompt: "Will Peyton Manning bowl a strike in the Michelob Ultra commercial?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[10] = Question({
      prompt: "Will the first touchdown pass be over or under 12.5 yards?",
      choiceCount: 2,
      choiceOne: "Over",
      choiceTwo: "Under",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[11] = Question({
      prompt: "Who will be shown first during the game, Matthew Stafford's wife or Sean McVay's fiancee?",
      choiceCount: 2,
      choiceOne: "Kelly Stafford",
      choiceTwo: "Veronika Khomyn",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[12] = Question({
      prompt: "Which will occur first?",
      choiceCount: 2,
      choiceOne: "Interception",
      choiceTwo: "Fumble",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[13] = Question({
      prompt: "Who will be winning at halftime?",
      choiceCount: 2,
      choiceOne: "Rams",
      choiceTwo: "Bengals",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[14] = Question({
      prompt: "Will the total points scored in the first half be odd or even?",
      choiceCount: 2,
      choiceOne: "Even",
      choiceTwo: "Odd",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[15] = Question({
      prompt: "Who will sing first during the halftime show?",
      choiceCount: 5,
      choiceOne: "Dr. Dre",
      choiceTwo: "Eminem",
      choiceThree: "Kendrick Lamar",
      choiceFour: "Mary J Blige",
      choiceFive: "Snoop Dogg"
    });
    questions[16] = Question({
      prompt: "Will Eminem wear a Detroit Lions Jersey at any point during the halftime show?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[17] = Question({
      prompt: "Will the longest score of the game be a touchdown or a field goal?",
      choiceCount: 2,
      choiceOne: "Touchdown",
      choiceTwo: "Field Goal",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[18] = Question({
      prompt: "Will both teams score at least one point in every quarter?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[19] = Question({
      prompt: "Will there be a missed field goal in the game?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[20] = Question({
      prompt: "Will any player score two touchdowns in the game (not including passing touchdowns)?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[21] = Question({
      prompt: "Will Burrow register more pass completions in Super Bowl LVI than the Boston Celtics do points in the first quarter of their game on Sunday?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[22] = Question({
      prompt: "Will any player register 100+ yards receiving in the game?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[23] = Question({
      prompt: "Will a Rams or Bengals player lead the game in rushing?",
      choiceCount: 2,
      choiceOne: "Rams",
      choiceTwo: "Bengals",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[24] = Question({
      prompt: "Will either coach win a challenge in the game?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[25] = Question({
      prompt: "Will there be any points scored during the final two minutes of the game?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[26] = Question({
      prompt: "Will the price of Bitcoin be higher or lower at the end of the game than it was at the opening kickoff?",
      choiceCount: 2,
      choiceOne: "Higher",
      choiceTwo: "Lower",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[27] = Question({
      prompt: "Will the length of the game's last field goal be higher or lower than the age of the winning coach?",
      choiceCount: 2,
      choiceOne: "Higher",
      choiceTwo: "Lower",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[28] = Question({
      prompt: "Who will win the game?",
      choiceCount: 2,
      choiceOne: "Rams",
      choiceTwo: "Bengals",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[29] = Question({
      prompt: "Will the liquid dumped on the winning coach be clear or colored?",
      choiceCount: 2,
      choiceOne: "Clear",
      choiceTwo: "Colored",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
    questions[30] = Question({
      prompt: "Will a non-quarterback be named MVP?",
      choiceCount: 2,
      choiceOne: "Yes",
      choiceTwo: "No",
      choiceThree: 0x0, choiceFour: 0x0, choiceFive: 0x0
    });
  }
}