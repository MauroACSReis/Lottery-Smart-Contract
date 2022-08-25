// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

contract Lottery {
    address public manager;
    address payable[] public players;

    constructor() {
        manager = msg.sender;
    }

    function enter() public payable {
        require(msg.value > .01 ether);

        players.push(payable(msg.sender));
    }

    function pickWinner() public restricted {
        //// uses restricted modifier
        uint256 index = random() % players.length;
        players[index].transfer(address(this).balance);
        players = new address payable[](0); //// empty the array for the next round
    }

    function getPlayers() public view returns (address payable[] memory) {
        return players;
    }

    function random() private view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(block.difficulty, block.timestamp, players)
                )
            );
    } //// It's not actually random, it just mimics randomness. Solidity can't actually randomnize

    modifier restricted() {
        //// modifiers functions are used to minify the amount of code by being reusable
        require(msg.sender == manager, "you are not the manager"); //// only the manager can pick winner
        _; //// the used function will be inserted here
    }
}
